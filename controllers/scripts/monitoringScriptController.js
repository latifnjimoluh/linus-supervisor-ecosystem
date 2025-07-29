const fs = require("fs");
const path = require("path");
const { MonitoringScript, ServiceTemplate } = require("../../models");
const { v4: uuidv4 } = require("uuid");

function renderTemplate(template, variables) {
  return template.replace(/{{(\w+)}}/g, (_, key) => variables[key] || "");
}

exports.generateMonitoringScript = async (req, res) => {
  try {
    const { template_id, zone_name, check_domain, ports_to_scan, cron_interval } = req.body;

    if (!template_id || !zone_name || !check_domain || !ports_to_scan || !cron_interval) {
      return res.status(400).json({
        message: "Champs requis : template_id, zone_name, check_domain, ports_to_scan, cron_interval"
      });
    }

    const template = await ServiceTemplate.findByPk(template_id);
    if (!template) {
      return res.status(404).json({ message: "Template de supervision introuvable." });
    }

    const templatePath = template.template_path;
    if (!fs.existsSync(templatePath)) {
      return res.status(404).json({ message: "Fichier template manquant sur le disque." });
    }

    const rawTemplate = fs.readFileSync(templatePath, "utf8");

    const finalContent = renderTemplate(rawTemplate, {
      ZONE_NAME: zone_name,
      CHECK_DOMAIN: check_domain,
      PORTS_TO_SCAN: ports_to_scan,
      CRON_INTERVAL: cron_interval
    });

    const filename = `monitor-${template.service_type}-${zone_name}-${uuidv4()}.sh`;
    const outputDir = path.join(__dirname, "../../generated-scripts");
    const outputPath = path.join(outputDir, filename);

    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });
    fs.writeFileSync(outputPath, finalContent);

    const savedScript = await MonitoringScript.create({
      name: `Agent ${template.service_type.toUpperCase()} - ${zone_name}`,
      script_path: outputPath,
      service_type: template.service_type,
      config_data: {
        zone_name,
        check_domain,
        ports_to_scan,
        cron_interval
      }
    });

    return res.status(201).json({
      message: "✅ Script de monitoring généré et sauvegardé.",
      script_id: savedScript.id,
      script_path: savedScript.script_path
    });

  } catch (error) {
    console.error("❌ Erreur génération monitoring :", error);
    res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
};
