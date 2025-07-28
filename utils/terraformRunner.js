const fs = require("fs");
const path = require("path");
const { execSync, exec } = require("child_process");

exports.runTerraformApply = (variables) => {
  return new Promise((resolve, reject) => {
    const tfDir = path.resolve(__dirname, "../terraform");
    const tfvarsPath = path.join(tfDir, "variables.tfvars.json");

    // 🛠️ Créer logs/ si besoin
    const logsDir = path.resolve(__dirname, "../logs");
    if (!fs.existsSync(logsDir)) {
      fs.mkdirSync(logsDir);
    }

    console.log("📁 [Terraform Runner] Dossier Terraform :", tfDir);
    console.log("📄 [Terraform Runner] Chemin variables.tfvars.json :", tfvarsPath);
    console.log("📤 [Terraform Runner] Variables JSON injectées :", variables);

    // 📝 Écriture dynamique des variables
    fs.writeFileSync(tfvarsPath, JSON.stringify(variables, null, 2));
    console.log("✅ [Terraform Runner] Fichier tfvars écrit avec succès");

    // 📦 Commandes Terraform
    const initCmd = `terraform init -input=false -upgrade=false`;
    const applyCmd = `terraform apply -auto-approve -var-file=variables.tfvars.json`;

    const fullCmd = `${initCmd} && ${applyCmd}`;
    console.log("🚀 [Terraform Runner] Commande exécutée :", fullCmd);

    exec(fullCmd, {
      cwd: tfDir,
      env: {
        ...process.env,
        TF_REGISTRY_CLIENT_TIMEOUT: "0",
        TF_LOG: "ERROR"
      }
    }, (error, stdout, stderr) => {
      const success = !error;

      if (!success) {
        console.error("❌ [Terraform Runner] Erreur d'exécution:", stderr);
        return reject({ stdout, stderr, success });
      }

      console.log("✅ [Terraform Runner] Déploiement terminé avec succès.");

      let outputJson = {};
      try {
        const outputBuffer = execSync(`terraform output -json`, { cwd: tfDir });
        outputJson = JSON.parse(outputBuffer.toString());
        console.log("📤 [Terraform Runner] Outputs Terraform :", outputJson);
      } catch (err) {
        console.warn("⚠️ [Terraform Runner] Échec de récupération des outputs:", err.message);
      }

      // 📦 Extraction utile
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
