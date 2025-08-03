"use strict";

const fs = require("fs");
const path = require("path");
const db = require("../../models");
const { getNextSequence } = require("../../utils/sequence");

// Utilitaire de rendu de template
function renderTemplate(template, variables) {
  return template.replace(/{{(\w+)}}/g, (_, key) => variables[key] || "");
}

exports.configureService = async (req, res) => {
  try {
    const { template_id, config_data } = req.body;

    if (!template_id || !config_data) {
      return res.status(400).json({ message: "Champs requis : template_id et config_data." });
    }

    // 🔍 Récupération du template
    const template = await db.ConfigTemplate.findByPk(template_id);
    if (!template) return res.status(404).json({ message: "Template introuvable." });

    const templatePath = template.template_path;
    if (!fs.existsSync(templatePath)) {
      return res.status(404).json({ message: "Fichier template introuvable sur le disque." });
    }

    let rawTemplate = fs.readFileSync(templatePath, "utf-8");

    // Si données DNS
    let dnsRecords = "";
    if (Array.isArray(config_data.records)) {
      dnsRecords = config_data.records.map(record => {
        const { name, type, value } = record;
        return `${name}     IN      ${type}     ${value}`;
      }).join("\n");
    }

    const variables = {
      ...config_data,
      DNS_RECORDS: dnsRecords
    };

    const renderedScript = renderTemplate(rawTemplate, variables);

    const baseDir = path.resolve(__dirname, "../../generated-scripts");
    const categoryDir = path.join(baseDir, template.category || "autre");
    if (!fs.existsSync(categoryDir)) fs.mkdirSync(categoryDir, { recursive: true });

    const safeName = template.name.replace(/\s+/g, "-").toLowerCase();
    const seq = getNextSequence(categoryDir, `config-${template.service_type}-${safeName}-`, ".sh");
    const filename = `config-${template.service_type}-${safeName}-${seq}.sh`;
    const scriptPath = path.join(categoryDir, filename);

    fs.writeFileSync(scriptPath, renderedScript, "utf-8");

    // 💾 Enregistrement dans la table renommée
    const configRecord = await db.ConfigTemplateService.create({
      service_type: template.service_type,
      config_data,
      script_path: scriptPath,
    });

    return res.status(200).json({
      message: "✅ Script généré avec succès à partir du template.",
      id: configRecord.id,
      script_path: scriptPath
    });

  } catch (error) {
    console.error("❌ Erreur génération script :", error);
    return res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};
