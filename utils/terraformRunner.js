const fs = require("fs");
const path = require("path");
const { exec } = require("child_process");

exports.runTerraformApply = (variables) => {
  return new Promise((resolve, reject) => {
    const tfDir = path.resolve(__dirname, "../terraform");
    const tfvarsPath = path.join(tfDir, "variables.tfvars.json");

    // 🛠️ 1. Créer logs/ si besoin
    const logsDir = path.resolve(__dirname, "../logs");
    if (!fs.existsSync(logsDir)) {
      fs.mkdirSync(logsDir);
    }

    // 📝 2. Écriture dynamique du fichier variables.tfvars.json
    fs.writeFileSync(tfvarsPath, JSON.stringify(variables, null, 2));

    // 📦 3. Commandes Terraform
    const initCmd = `terraform init -input=false`;
    const applyCmd = `terraform apply -auto-approve -var-file=variables.tfvars.json`;

    exec(`${initCmd} && ${applyCmd}`, { cwd: tfDir }, (error, stdout, stderr) => {
      const success = !error;

      if (!success) {
        console.error("❌ Erreur Terraform:", stderr);
        return reject({ stdout, stderr, success });
      }

      return resolve({ stdout, stderr, success });
    });
  });
};


exports.runTerraformDestroy = (variables) => {
  return new Promise((resolve, reject) => {
    const tfDir = path.resolve(__dirname, "../terraform");
    const tfvarsPath = path.join(tfDir, "variables.tfvars.json");

    // Réécriture du fichier .tfvars sans toucher au JSON envoyé
    fs.writeFileSync(tfvarsPath, JSON.stringify(variables, null, 2));

    const initCmd = `terraform init -input=false`;
    const destroyCmd = `terraform destroy -auto-approve -var-file=variables.tfvars.json`;

    exec(`${initCmd} && ${destroyCmd}`, { cwd: tfDir }, (error, stdout, stderr) => {
      const success = !error;
      if (!success) {
        console.error("❌ Erreur Terraform destroy:", stderr);
        return reject({ stdout, stderr, success });
      }
      return resolve({ stdout, stderr, success });
    });
  });
};
