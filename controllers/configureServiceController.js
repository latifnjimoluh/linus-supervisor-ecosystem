"use strict";

const fs = require("fs");
const path = require("path");
const db = require("../models");

// Remplacement des {{VARIABLES}} dans le template
function renderTemplate(template, variables) {
  return template.replace(/{{(\w+)}}/g, (_, key) => variables[key] || "");
}

exports.configureService = async (req, res) => {
  try {
    const { template_id, config_data } = req.body;

    if (!template_id || !config_data) {
      return res.status(400).json({ message: "Champs requis : template_id et config_data." });
    }

    // 🔍 Chargement du template en base
    const template = await db.ServiceTemplate.findByPk(template_id);
    if (!template) return res.status(404).json({ message: "Template introuvable." });

    const templatePath = template.template_path;
    if (!fs.existsSync(templatePath)) {
      return res.status(404).json({ message: "Fichier template introuvable sur le disque." });
    }

    // 📄 Lecture brute du fichier template
    let rawTemplate = fs.readFileSync(templatePath, "utf-8");

    // 🔧 Transformation des enregistrements DNS en texte brut
    let dnsRecords = "";
    if (Array.isArray(config_data.records)) {
      dnsRecords = config_data.records.map(record => {
        const { name, type, value } = record;
        return `${name}     IN      ${type}     ${value}`;
      }).join("\n");
    }

    // 🧠 Variables injectées dans le template
    const variables = {
      ...config_data,
      DNS_RECORDS: dnsRecords
    };

    // 🏗️ Génération du script rendu final
    const renderedScript = renderTemplate(rawTemplate, variables);

    // 📁 Emplacement de sauvegarde
    const filename = `${template.service_type}-install-${Date.now()}.sh`;
    const outputDir = path.join(__dirname, "../generated-scripts");
    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });

    const scriptPath = path.join(outputDir, filename);
    fs.writeFileSync(scriptPath, renderedScript, "utf-8");

    // 💾 Sauvegarde dans la BDD
    const configRecord = await db.ServiceConfiguration.create({
      service_type: template.service_type,
      config_data,
      script_path: scriptPath
    });

    // ✅ Résultat
    return res.status(200).json({
      message: "✅ Script généré avec succès à partir du template.",
      id: configRecord.id,
      script_path: scriptPath
    });

  } catch (error) {
    console.error("❌ Erreur génération script DNS :", error);
    return res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};
