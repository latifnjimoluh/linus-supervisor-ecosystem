const fs = require("fs");
const path = require("path");
const { MonitoringScript, ServiceTemplate } = require("../../models");
const { getNextSequence } = require("../../utils/sequence");

function renderTemplate(template, variables) {
  return template.replace(/{{(\w+)}}/g, (_, key) => variables[key] || "");
}

exports.generateServiceMonitoringAgent = async (req, res) => {
  try {
    const { template_id, services, cron_interval } = req.body;

    if (!template_id || !Array.isArray(services) || services.length === 0 || !cron_interval) {
      return res.status(400).json({
        message: "Champs requis : template_id, services (array non vide), cron_interval"
      });
    }

    // Récupérer le template depuis la base
    const template = await ServiceTemplate.findByPk(template_id);
    if (!template) {
      return res.status(404).json({ message: "Template introuvable." });
    }

    const templatePath = template.template_path;
    if (!fs.existsSync(templatePath)) {
      return res.status(404).json({ message: "Fichier template manquant sur le disque." });
    }

    const rawTemplate = fs.readFileSync(templatePath, "utf8");

    // Convertir la liste des services en texte brut (ligne par ligne)
    const serviceList = services.join("\n");

    // Injecter les variables dans le template
    const finalScript = renderTemplate(rawTemplate, {
      SERVICES: serviceList,
      CRON_INTERVAL: cron_interval
    });

    // Générer le fichier final dans generated-scripts/
    const outputDir = path.join(__dirname, "../../generated-scripts");
    const seq = getNextSequence(outputDir, "agent-services-", ".sh");
    const filename = `agent-services-${seq}.sh`;
    const outputPath = path.join(outputDir, filename);
    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });

    fs.writeFileSync(outputPath, finalScript);

    // Sauvegarder le script généré dans la base
    const record = await MonitoringScript.create({
      name: `Agent Services (${services.length} services)`,
      script_path: outputPath,
      service_type: "supervision",
      config_data: {
        services,
        cron_interval
      }
    });

    return res.status(201).json({
      message: "✅ Script de supervision des services généré avec succès.",
      script_id: record.id,
      script_path: record.script_path
    });

  } catch (error) {
    console.error("❌ Erreur génération agent services :", error);
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};
