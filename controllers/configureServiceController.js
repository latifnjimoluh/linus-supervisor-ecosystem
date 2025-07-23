"use strict";

const fs = require("fs");
const path = require("path");
const { v4: uuidv4 } = require("uuid");
const db = require("../models");

function renderTemplate(template, variables) {
  return template.replace(/{{(\w+)}}/g, (_, key) => variables[key] || "");
}

exports.configureService = async (req, res) => {
  try {
    const { service_type, config_data } = req.body;

    if (!service_type || !config_data) {
      return res.status(400).json({ message: "Champs requis : service_type et config_data." });
    }

    const templatePath = path.join(__dirname, `../templates/${service_type}/${service_type}-template.sh`);
    if (!fs.existsSync(templatePath)) {
      return res.status(404).json({ message: "Template introuvable pour ce service." });
    }

    // Lire le template brut
    let rawTemplate = fs.readFileSync(templatePath, "utf-8");

    // Générer dynamiquement les enregistrements DNS
    let dnsRecords = "";
    if (Array.isArray(config_data.records)) {
      dnsRecords = config_data.records.map(record => {
        return `${record.name}     IN      ${record.type}     ${record.value}`;
      }).join("\n");
    }

    // Ajouter les variables pour remplacement
    const variables = {
      ...config_data,
      dns_records: dnsRecords
    };

    const renderedScript = renderTemplate(rawTemplate, variables);

    const filename = `${service_type}-install-${Date.now()}.sh`;
    const outputDir = path.join(__dirname, "../generated-scripts");
    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });

    const scriptPath = path.join(outputDir, filename);
    fs.writeFileSync(scriptPath, renderedScript, "utf-8");

    // Sauvegarder en base
    const configRecord = await db.ServiceConfiguration.create({
      service_type,
      config_data,
      script_path: scriptPath
    });

    return res.status(200).json({
      message: "✅ Script généré et sauvegardé.",
      id: configRecord.id,
      script_path: scriptPath
    });

  } catch (error) {
    console.error("❌ Erreur de génération :", error);
    return res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};
