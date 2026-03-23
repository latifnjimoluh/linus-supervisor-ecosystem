// backend/utils/terraformRunner.js
const fs = require('fs');
const fse = require('fs-extra');
const path = require('path');
const { exec, execSync } = require('child_process');
const { publish } = require('./sseHub'); // SSE hub: addClient/removeClient/publish
const { Deployment } = require('../models');

function getNextSequence(baseDir) {
  let seq = 1;
  while (fs.existsSync(path.join(baseDir, seq.toString()))) {
    seq += 1;
  }
  return seq.toString();
}

// --- Détecteur d'erreurs connues (ex: espace disque / ENOSPC) ---
function classifyTerraformError(text) {
  if (!text) return null;

  // Espace disque / thin pool saturé / ENOSPC
  const enospcRe =
    /(free\s+space.*thin\s+pool.*reached\s+threshold|Cannot\s+create\s+new\s+thin\s+volume.*free\s+space.*reached\s+threshold|no\s+space\s+left\s+on\s+device|ENOSPC)/i;

  if (enospcRe.test(text)) {
    const poolMatch = text.match(/thin\s+pool\s+([^\s]+)\s+reached/i);
    const pool = poolMatch?.[1] || 'local-lvm / pve/data';
    return {
      code: 'STORAGE_FULL',
      message: `Espace de stockage insuffisant sur le pool ${pool}. Libérez de l’espace (ou choisissez un autre storage) puis relancez.`,
    };
  }

  // Auth Proxmox (exemples courants)
  const authRe = /(401 Unauthorized|permission\s+check\s+failed|invalid\s+token|authentication\s+failure)/i;
  if (authRe.test(text)) {
    return {
      code: 'PROXMOX_AUTH_FAILED',
      message: "Échec d'authentification Proxmox (token/permissions). Vérifiez vos identifiants ou droits d'accès.",
    };
  }

  // Nom de VM invalide (au cas où la validation front n'a pas agi)
  const nameRe = /"name", must only contain alphanumerics, hyphens and dots/i;
  if (nameRe.test(text)) {
    return {
      code: 'INVALID_VM_NAME',
      message: "Nom de VM invalide. Utilisez uniquement des lettres/chiffres, '-' et '.'.",
    };
  }

  
  // SCP lancé sans hôte (ex: "nexus@:/tmp/…")
  const scpNoHost = /(You must specify a subsystem to invoke|scp:\s*Connection closed)[\s\S]*?@[ ]*:/i;
  if (scpNoHost.test(text)) {
    return {
      code: 'SSH_HOST_MISSING',
      message:
        "Impossible de copier les scripts : l'hôte SSH est vide (IP non détectée). " +
        "Installez/activez le Qemu Guest Agent dans le template ou fournissez une IP statique pour la VM, puis réessayez.",
    };
  }

  // Qemu Guest Agent pas installé / pas démarré
  const guestAgent = /(QEMU guest agent is not running|guest agent.*not installed|guest agent.*not working)/i;
  if (guestAgent.test(text)) {
    return {
      code: 'GUEST_AGENT_DOWN',
      message:
        "Le Qemu Guest Agent n'est pas actif dans la VM. Installez-le dans le template (ex: `sudo apt-get update && sudo apt-get install -y qemu-guest-agent`), " +
        "puis `sudo systemctl enable --now qemu-guest-agent`, et recréez la VM.",
    };
  }

  // Erreurs SSH courantes (permis refusé, timeout, route…)
  const sshCommon = /(Permission denied \(publickey\)|Connection timed out|No route to host|Connection refused)/i;
  if (sshCommon.test(text)) {
    return {
      code: 'SSH_CONNECTION_FAILED',
      message:
        "Connexion SSH impossible vers la VM. Vérifiez la clé privée, l'utilisateur, l'adresse IP et que le port 22 est accessible.",
    };
  }

  return null;
}


exports.runTerraformApplyStream = (instanceId, variables, externalLogPath = null) => {
  return new Promise((resolve, reject) => {
    const baseDir   = path.resolve(__dirname, '../terraform');
    const deployBase= path.join(baseDir, 'deployments');
    const stateBase = path.join(baseDir, 'states');
    const runId     = getNextSequence(deployBase);
    const deployDir = path.join(deployBase, runId);
    const stateDir  = path.join(stateBase, runId);
    const tfvarsPath= path.join(deployDir, 'variables.tfvars.json');

    if (!fs.existsSync(deployDir)) fse.mkdirpSync(deployDir);
    if (!fs.existsSync(stateDir))  fse.mkdirpSync(stateDir);

    console.log('📁 [Terraform Runner] Répertoire de base :', baseDir);
    console.log('📁 [Terraform Runner] Répertoire de déploiement :', deployDir);
    console.log('📁 [Terraform Runner] Répertoire de state :', stateDir);

    // Copier tous les .tf
    const tfFiles = fs.readdirSync(baseDir).filter(file => file.endsWith('.tf'));
    tfFiles.forEach(file => {
      const src = path.join(baseDir, file);
      const dest = path.join(deployDir, file);
      fse.copyFileSync(src, dest);
      console.log(`📄 [Terraform Runner] Fichier copié : ${file}`);
    });

    // Injection des scripts avec ${instance_id}
    if (variables.scripts) {
      const updatedScripts = {};
      for (const [vm, scripts] of Object.entries(variables.scripts)) {
        updatedScripts[vm] = [];
        scripts.forEach((scriptPath, idx) => {
          if (fs.existsSync(scriptPath)) {
            try {
              const raw = fs.readFileSync(scriptPath, 'utf8');
              const interpolated = raw.replace(/\${instance_id}/g, instanceId);
              const target = path.join(deployDir, `${vm}-script-${idx + 1}.sh`);
              fs.writeFileSync(target, interpolated);
              console.log(`📄 [Terraform Runner] Script copié pour ${vm} :`, target);
              updatedScripts[vm].push(target);
            } catch (err) {
              console.warn('⚠️ [Terraform Runner] Échec injection instance_id :', err.message);
            }
          } else {
            console.warn('⚠️ [Terraform Runner] Script introuvable :', scriptPath);
          }
        });
      }
      variables.scripts = updatedScripts;
    }

    // Écriture du tfvars
    fs.writeFileSync(tfvarsPath, JSON.stringify(variables, null, 2));
    console.log('✅ [Terraform Runner] Fichier tfvars écrit dans :', tfvarsPath);
    console.log('📤 [Terraform Runner] Variables JSON injectées :', variables);

    // Commandes (toujours celles demandées)
    const initCmd  = `terraform init -input=false -upgrade=false`;
    const applyCmd = `terraform apply -auto-approve -var-file=variables.tfvars.json`;
    const fullCmd  = `${initCmd} && ${applyCmd}`;

    console.log('🚀 [Terraform Runner] Commande exécutée :', fullCmd);

    const logFilePath = path.join(deployDir, 'terraform-exec.log');
    const outStream   = fs.createWriteStream(logFilePath, { flags: 'w' });
    const teeStream   = externalLogPath ? fs.createWriteStream(externalLogPath, { flags: 'a' }) : null;

    // Buffers pour classification finale
    let collectedStdout = '';
    let collectedStderr = '';

    // PATH Windows-friendly
    const EXTRA_PATHS = [
      'C:\\ProgramData\\chocolatey\\bin',
      'C:\\HashiCorp\\Terraform',
      'C:\\HashiCorp\\Terraform\\bin'
    ];
    const ENV_PATH = process.env.PATH
      ? `${process.env.PATH};${EXTRA_PATHS.join(';')}`
      : EXTRA_PATHS.join(';');

    const options = {
      cwd: deployDir,
      shell: true,               // important sous Windows
      windowsHide: true,
      maxBuffer: 1024 * 1024 * 50,
      env: {
        ...process.env,
        PATH: ENV_PATH,
        TF_LOG: 'DEBUG',
        TF_LOG_PATH: path.join(deployDir, 'terraform-debug.log'),
      },
    };

    // Notifier statut initial + bannière de départ
    Deployment.update({ status: 'running' }, { where: { instance_id: instanceId } }).catch(() => {});
    publish(instanceId, 'status', { status: 'running' });
    const banner =
`==== LANCEMENT Terraform (runId=${runId}) ====
CWD: ${deployDir}
CMD: ${fullCmd}

`;
    outStream.write(banner);
    if (teeStream) teeStream.write(banner);
    publish(instanceId, 'log', { chunk: banner });

    // Lancement + streaming
    const child = exec(fullCmd, options);

    const writeAll = (text) => {
      outStream.write(text);
      if (teeStream) teeStream.write(text);
      publish(instanceId, 'log', { chunk: text });

      // Affichage console live (conserve tes logs)
      if (text) {
        // Coloration rudimentaire: envoie le rouge vers stderr
        if (/\x1b\[31m/.test(text)) process.stderr.write(text);
        else process.stdout.write(text);
      }
    };

    if (child.stdout) {
      child.stdout.on('data', (c) => {
        const t = c.toString();
        collectedStdout += t;
        writeAll(t);
      });
    }
    if (child.stderr) {
      child.stderr.on('data', (c) => {
        const t = c.toString();
        collectedStderr += t;
        writeAll(t);
      });
    }

    child.on('error', (err) => {
      const t = `\n[spawn:error] ${err.message}\n`;
      collectedStderr += t;
      writeAll(t);
    });

    child.on('close', (code) => {
      outStream.write(`\n[close] code=${code}\n`);
      outStream.end();
      if (teeStream) teeStream.end();

      const success = code === 0;

      // 📄 Analyse de terraform-debug.log pour erreurs dans les scripts (best effort)
      const tfDebugPath = path.join(deployDir, 'terraform-debug.log');
      let hasScriptError = false;
      try {
        const debugContent = fs.readFileSync(tfDebugPath, 'utf8');
        if (debugContent.includes('terraform_script_errors.log') || debugContent.includes('❌')) {
          hasScriptError = true;
        }
      } catch {
        console.warn('⚠️ [Terraform Runner] Impossible de lire terraform-debug.log');
      }

      // 💾 Sauvegarde du state
      const srcState  = path.join(deployDir, 'terraform.tfstate');
      const destState = path.join(stateDir,  'terraform.tfstate');
      if (fs.existsSync(srcState)) {
        fse.copyFileSync(srcState, destState);
        console.log('💾 [Terraform Runner] State sauvegardé dans :', destState);
      }

      // 📤 Récup des outputs
      let outputJson = {};
      try {
        const outputBuffer = execSync('terraform output -json', { cwd: deployDir, shell: true, env: options.env });
        outputJson = JSON.parse(outputBuffer.toString());
        console.log('📤 [Terraform Runner] Outputs Terraform :', outputJson);
      } catch (err) {
        console.warn('⚠️ [Terraform Runner] Outputs non disponibles :', err.message);
      }

      const vmInfo = {
        vm_ips:       outputJson?.vm_ips?.value       || {},
        vm_names:     outputJson?.vm_names?.value     || [],
        vm_ids:       outputJson?.vm_ids?.value       || {},
        ssh_commands: outputJson?.ssh_commands?.value || {},
        status:       outputJson?.status?.value       || '',
      };

      if (!success) {
        const combined = `${collectedStdout}\n${collectedStderr}`;
        const known = classifyTerraformError(combined);

        if (known) {
          console.error(`❌ [Terraform Runner] ${known.message}`);
          publish(instanceId, 'error', { code: known.code, message: known.message });
          publish(instanceId, 'status', { status: 'failed' });
          publish(instanceId, 'done', {});
          return reject({ success: false, vmInfo, code: known.code, message: known.message });
        }

        console.error('❌ [Terraform Runner] Terraform a échoué complètement.');
        publish(instanceId, 'error', { code: 'TF_APPLY_FAILED', message: 'Le déploiement a échoué.' });
        publish(instanceId, 'status', { status: 'failed' });
        publish(instanceId, 'done', {});
        return reject({ success: false, vmInfo, code: 'TF_APPLY_FAILED', message: 'Le déploiement a échoué.' });
      }

      // ✅ Succès
      console.log('✅ [Terraform Runner] Déploiement terminé avec succès.');
      publish(instanceId, 'status', { status: 'success' });
      publish(instanceId, 'done', {});
      return resolve({ stdout: '', stderr: '', success: true, hasScriptError, vmInfo });
    });
  });
};
