const fs = require("fs");
const path = require("path");
const { InitScript } = require("../models"); // Ou MonitoringScript selon ta structure
const { v4: uuidv4 } = require("uuid");

exports.generateMonitoringScript = async (req, res) => {
  try {
    const { zone_name, check_domain, port_range } = req.body;

    if (!zone_name || !check_domain || !port_range) {
      return res.status(400).json({ message: "Champs requis : zone_name, check_domain, port_range" });
    }

    // 📄 Charger le template brut
    const templatePath = path.join(__dirname, "../templates/dns/agent-superviseur-dns.tmpl.sh");
    const templateContent = fs.readFileSync(templatePath, "utf8");

    // 🔁 Remplacement des variables
    const finalContent = templateContent
      .replace(/{{ZONE_NAME}}/g, zone_name)
      .replace(/{{CHECK_DOMAIN}}/g, check_domain)
      .replace(/{{PORT_RANGE}}/g, port_range);

    // 📁 Générer un nom unique
    const filename = `agent-dns-${zone_name}-${uuidv4()}.sh`;
    const outputDir = path.join(__dirname, "../generated-scripts");
    const outputPath = path.join(outputDir, filename);

    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });

    // 💾 Écriture du script
    fs.writeFileSync(outputPath, finalContent);
    console.log("✅ Script généré :", outputPath);

    // 🗃️ Enregistrement base de données
    const savedScript = await InitScript.create({
      name: `Agent DNS - ${zone_name}`,
      script_path: outputPath,
      service_type: "dns", // ou autre selon usage
    });

    return res.status(201).json({
      message: "Script de supervision généré et enregistré avec succès",
      script_id: savedScript.id,
      script_path: savedScript.script_path,
    });
  } catch (error) {
    console.error("❌ Erreur génération script DNS :", error);
    res.status(500).json({ message: "Erreur interne", error: error.message });
  }
};
