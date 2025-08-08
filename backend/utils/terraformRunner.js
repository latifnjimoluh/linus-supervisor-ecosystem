const fs = require('fs');
const fse = require('fs-extra');
const path = require('path');
const { exec, execSync } = require('child_process');

function getNextSequence(baseDir) {
  let seq = 1;
  while (fs.existsSync(path.join(baseDir, seq.toString()))) {
    seq += 1;
  }
  return seq.toString();
}

exports.runTerraformApply = (instanceId, variables) => {
  return new Promise((resolve, reject) => {
    const baseDir = path.resolve(__dirname, '../terraform');
    const deployBase = path.join(baseDir, 'deployments');
    const stateBase = path.join(baseDir, 'states');
    const runId = getNextSequence(deployBase);
    const deployDir = path.join(deployBase, runId);
    const stateDir = path.join(stateBase, runId);
    const tfvarsPath = path.join(deployDir, 'variables.tfvars.json');

    if (!fs.existsSync(deployDir)) fse.mkdirpSync(deployDir);
    if (!fs.existsSync(stateDir)) fse.mkdirpSync(stateDir);

    console.log('📁 [Terraform Runner] Répertoire de base :', baseDir);
    console.log('📁 [Terraform Runner] Répertoire de déploiement :', deployDir);
    console.log('📁 [Terraform Runner] Répertoire de state :', stateDir);

    const tfFiles = fs.readdirSync(baseDir).filter(file => file.endsWith('.tf'));
    tfFiles.forEach(file => {
      const src = path.join(baseDir, file);
      const dest = path.join(deployDir, file);
      fse.copyFileSync(src, dest);
      console.log(`📄 [Terraform Runner] Fichier copié : ${file}`);
    });

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

    fs.writeFileSync(tfvarsPath, JSON.stringify(variables, null, 2));
    console.log('✅ [Terraform Runner] Fichier tfvars écrit dans :', tfvarsPath);
    console.log('📤 [Terraform Runner] Variables JSON injectées :', variables);

    const initCmd = `terraform init -input=false -upgrade=false`;
    const applyCmd = `terraform apply -auto-approve -var-file=variables.tfvars.json`;
    const fullCmd = `${initCmd} && ${applyCmd}`;

    console.log('🚀 [Terraform Runner] Commande exécutée :', fullCmd);

    exec(fullCmd, {
      cwd: deployDir,
      env: {
        ...process.env,
        TF_LOG: 'DEBUG',
        TF_LOG_PATH: path.join(deployDir, 'terraform-debug.log')
      }
    }, (error, stdout, stderr) => {
      const success = !error;
      const logFilePath = path.join(deployDir, 'terraform-exec.log');
      const logData = `=== STDOUT ===\n${stdout}\n\n=== STDERR ===\n${stderr}`;
      fs.writeFileSync(logFilePath, logData);

      // 📄 Analyse de terraform-debug.log pour erreurs dans les scripts
      const tfDebugPath = path.join(deployDir, 'terraform-debug.log');
      let hasScriptError = false;
      try {
        const debugContent = fs.readFileSync(tfDebugPath, 'utf8');
        if (debugContent.includes('terraform_script_errors.log') || debugContent.includes('❌')) {
          hasScriptError = true;
        }
      } catch (err) {
        console.warn('⚠️ [Terraform Runner] Impossible de lire terraform-debug.log');
      }

      const srcState = path.join(deployDir, 'terraform.tfstate');
      const destState = path.join(stateDir, 'terraform.tfstate');
      if (fs.existsSync(srcState)) {
        fse.copyFileSync(srcState, destState);
        console.log('💾 [Terraform Runner] State sauvegardé dans :', destState);
      }

      let outputJson = {};
      try {
        const outputBuffer = execSync('terraform output -json', { cwd: deployDir });
        outputJson = JSON.parse(outputBuffer.toString());
        console.log('📤 [Terraform Runner] Outputs Terraform :', outputJson);
      } catch (err) {
        console.warn('⚠️ [Terraform Runner] Outputs non disponibles :', err.message);
      }

      const vmInfo = {
        vm_ips: outputJson?.vm_ips?.value || {},
        vm_names: outputJson?.vm_names?.value || [],
        vm_ids: outputJson?.vm_ids?.value || {},
        ssh_commands: outputJson?.ssh_commands?.value || {},
        status: outputJson?.status?.value || ''
      };

      if (!success) {
        console.error('❌ [Terraform Runner] Terraform a échoué complètement.');
        return reject({ stdout, stderr, success: false });
      }

      if (hasScriptError) {
        console.warn('⚠️ [Terraform Runner] Déploiement terminé avec des erreurs dans les scripts (voir /tmp/terraform_script_errors.log)');
      } else {
        console.log('✅ [Terraform Runner] Déploiement terminé avec succès.');
      }

      return resolve({ stdout, stderr, success: true, hasScriptError, vmInfo });
    });
  });
};
