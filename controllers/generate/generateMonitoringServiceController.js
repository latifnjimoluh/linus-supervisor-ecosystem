const fs = require("fs");
const path = require("path");
const { v4: uuidv4 } = require("uuid");
const db = require("../../models");
const { MonitoringService } = db;
const ServiceTemplate = db.ServiceTemplate;

function renderTemplate(template, variables) {
  return template.replace(/{{(\w+)}}/g, (_, key) => variables[key] || "");
}

exports.generateMonitoringServiceScript = async (req, res) => {
  try {
    const { template_id, services, cron_interval } = req.body;

    if (!template_id || !Array.isArray(services) || !cron_interval) {
      return res.status(400).json({ message: "Champs requis : template_id, services (array), cron_interval" });
    }

    if (!ServiceTemplate) {
      return res.status(500).json({ message: "Modèle de service non chargé" });
    }

    const template = await ServiceTemplate.findByPk(template_id);
    if (!template) {
      return res.status(404).json({ message: "Template introuvable." });
    }

    const rawTemplate = fs.readFileSync(template.template_path, "utf8");
    const formattedServices = services.join("\n");

    const rendered = renderTemplate(rawTemplate, {
      SERVICES: formattedServices,
      CRON_INTERVAL: cron_interval
    });

    const filename = `detect-services-${uuidv4()}.sh`;
    const outputDir = path.join(__dirname, "../../generated-scripts");
    const outputPath = path.join(outputDir, filename);

    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });
    fs.writeFileSync(outputPath, rendered);

    const saved = await MonitoringService.create({
      name: `Service Watcher - ${uuidv4().slice(0, 8)}`,
      service_type: "services",
      script_path: outputPath,
      config_data: {
        services,
        cron_interval
      }
    });

    return res.status(201).json({
      message: "✅ Script généré et sauvegardé dans monitoring_services",
      script_id: saved.id,
      script_path: saved.script_path
    });

  } catch (err) {
    console.error("❌ Erreur génération services:", err);
    return res.status(500).json({ message: "Erreur serveur", error: err.message });
  }
};
