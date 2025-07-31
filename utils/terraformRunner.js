const fs = require("fs");
const path = require("path");
const { execSync, exec } = require("child_process");
const fse = require("fs-extra");

exports.runTerraformApply = (instanceId, variables) => {
  return new Promise((resolve, reject) => {
    const baseDir = path.resolve(__dirname, "../terraform");
    const deployDir = path.join(baseDir, "deployments", instanceId);
    const stateDir = path.join(baseDir, "states", instanceId);
    const tfvarsPath = path.join(deployDir, "variables.tfvars.json");

    if (!fs.existsSync(deployDir)) fse.mkdirpSync(deployDir);
    if (!fs.existsSync(stateDir)) fse.mkdirpSync(stateDir);

    console.log("📁 [Terraform Runner] Répertoire de base :", baseDir);
    console.log("📁 [Terraform Runner] Répertoire de déploiement :", deployDir);
    console.log("📁 [Terraform Runner] Répertoire de state :", stateDir);

    const tfFiles = fs.readdirSync(baseDir).filter(file => file.endsWith(".tf"));
    tfFiles.forEach(file => {
      const src = path.join(baseDir, file);
      const dest = path.join(deployDir, file);
      fse.copyFileSync(src, dest);
      console.log(`📄 [Terraform Runner] Fichier copié : ${file}`);
    });

    if (variables.init_script && fs.existsSync(variables.init_script)) {
      try {
        const rawInit = fs.readFileSync(variables.init_script, "utf8");
        const interpolatedInit = rawInit.replace(/\${instance_id}/g, instanceId);
        const targetInitPath = path.join(deployDir, "init.sh");
        fs.writeFileSync(targetInitPath, interpolatedInit);
        console.log("🔁 [Terraform Runner] Script init.sh personnalisé avec instance_id injecté :", targetInitPath);
        variables.init_script = targetInitPath;
      } catch (err) {
        console.warn("⚠️ [Terraform Runner] Échec injection instance_id dans init.sh :", err.message);
      }
    }

    fs.writeFileSync(tfvarsPath, JSON.stringify(variables, null, 2));
    console.log("✅ [Terraform Runner] Fichier tfvars écrit dans :", tfvarsPath);
    console.log("📤 [Terraform Runner] Variables JSON injectées :", variables);

    const initCmd = `terraform init -input=false -upgrade=false`;
    const applyCmd = `terraform apply -auto-approve -var-file=variables.tfvars.json`;
    const fullCmd = `${initCmd} && ${applyCmd}`;

    console.log("🚀 [Terraform Runner] Commande exécutée :", fullCmd);

    exec(fullCmd, {
      cwd: deployDir,
      env: {
        ...process.env,
        TF_LOG: "DEBUG",
        TF_LOG_PATH: path.join(deployDir, "terraform-debug.log")
      }
    }, (error, stdout, stderr) => {
      const success = !error;
      const logFilePath = path.join(deployDir, "terraform-exec.log");
      const logData = `=== STDOUT ===\n${stdout}\n\n=== STDERR ===\n${stderr}`;
      fs.writeFileSync(logFilePath, logData);

      if (!success) {
        console.error("❌ [Terraform Runner] Erreur :", stderr);
        return reject({ stdout, stderr, success });
      }

      const srcState = path.join(deployDir, "terraform.tfstate");
      const destState = path.join(stateDir, "terraform.tfstate");
      if (fs.existsSync(srcState)) {
        fse.copyFileSync(srcState, destState);
        console.log("💾 [Terraform Runner] State sauvegardé dans :", destState);
      }

      let outputJson = {};
      try {
        const outputBuffer = execSync(`terraform output -json`, { cwd: deployDir });
        outputJson = JSON.parse(outputBuffer.toString());
        console.log("📤 [Terraform Runner] Outputs Terraform :", outputJson);
      } catch (err) {
        console.warn("⚠️ [Terraform Runner] Outputs non disponibles :", err.message);
      }

      const vmInfo = {
        vm_ips: outputJson?.vm_ips?.value || {},
        vm_names: outputJson?.vm_names?.value || [],
        vm_ids: outputJson?.vm_ids?.value || {},
        ssh_commands: outputJson?.ssh_commands?.value || {},
        status: outputJson?.status?.value || ""
      };

      return resolve({ stdout, stderr, success, vmInfo });
    });
  });
};
