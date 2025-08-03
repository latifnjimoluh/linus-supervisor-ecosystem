const fs = require("fs");
const path = require("path");
const db = require("../../models");
const { Op } = require("sequelize");
const { getNextSequence } = require("../../utils/sequence");
const { MonitoredService } = db;
const ScriptTemplate = db.ScriptTemplate;

function renderTemplate(template, variables) {
  return template.replace(/{{(\w+)}}/g, (_, key) => variables[key] || "");
}

exports.generateMonitoredServiceScript = async (req, res) => {
  try {
    const { template_id, services, cron_interval } = req.body;

    if (!template_id || !Array.isArray(services) || !cron_interval) {
      return res.status(400).json({ message: "Champs requis : template_id, services (array), cron_interval" });
    }

    if (!ScriptTemplate) {
      return res.status(500).json({ message: "Modèle de script non chargé" });
    }

    const template = await ScriptTemplate.findByPk(template_id);
    if (!template) {
      return res.status(404).json({ message: "Template introuvable." });
    }

    const rawTemplate = fs.readFileSync(template.template_path, "utf8");
    const formattedServices = services.join("\n");

    const rendered = renderTemplate(rawTemplate, {
      SERVICES: formattedServices,
      CRON_INTERVAL: cron_interval
    });

    const outputDir = path.join(__dirname, "../../generated-scripts");
    const seq = getNextSequence(outputDir, "detect-services-", ".sh");
    const filename = `detect-services-${seq}.sh`;
    const outputPath = path.join(outputDir, filename);

    if (!fs.existsSync(outputDir)) fs.mkdirSync(outputDir, { recursive: true });
    fs.writeFileSync(outputPath, rendered);

    const saved = await MonitoredService.create({
      name: `Service Watcher - ${seq}`,
      service_type: "services",
      script_path: outputPath,
      config_data: {
        services,
        cron_interval
      }
    });

    return res.status(201).json({
      message: "✅ Script généré et sauvegardé dans monitored_services",
      script_id: saved.id,
      script_path: saved.script_path
    });

  } catch (err) {
    console.error("❌ Erreur génération services:", err);
    return res.status(500).json({ message: "Erreur serveur", error: err.message });
  }
};

exports.listMonitoredServiceScripts = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const sort = req.query.sort || "created_at";
    const direction = req.query.order === "asc" ? "ASC" : "DESC";
    const where = {};
    if (req.query.q) {
      const q = req.query.q;
      where[Op.or] = [
        { name: { [Op.iLike]: `%${q}%` } },
        { service_type: { [Op.iLike]: `%${q}%` } },
      ];
    }
    const { count, rows } = await MonitoredService.findAndCountAll({
      where,
      order: [[sort, direction]],
      limit,
      offset,
    });
    res.json({
      data: rows,
      pagination: {
        total: count,
        page,
        pages: Math.ceil(count / limit),
        limit,
      },
    });
  } catch (err) {
    console.error("❌ Erreur list monitoring services:", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

exports.updateMonitoredServiceScript = async (req, res) => {
  try {
    const { id } = req.params;
    const record = await MonitoredService.findByPk(id);
    if (!record) return res.status(404).json({ message: "Script introuvable" });
    const { name, config_data } = req.body;
    if (name) record.name = name;
    if (config_data) record.config_data = config_data;
    await record.save();
    res.json({ message: "Script mis à jour", record });
  } catch (err) {
    console.error("❌ Erreur update monitoring service:", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

exports.deleteMonitoredServiceScript = async (req, res) => {
  try {
    const { id } = req.params;
    const record = await MonitoredService.findByPk(id);
    if (!record) return res.status(404).json({ message: "Script introuvable" });
    await record.destroy();
    res.json({ message: "Script supprimé" });
  } catch (err) {
    console.error("❌ Erreur delete monitoring service:", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
};
