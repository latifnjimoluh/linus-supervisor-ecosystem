const fs = require("fs");
const path = require("path");
const { MonitoringScript, ServiceTemplate } = require("../../models");
const { Op } = require("sequelize");
const { getNextSequence } = require("../../utils/sequence");

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

    const outputDir = path.join(__dirname, "../../generated-scripts");
    const seq = getNextSequence(outputDir, `monitor-${template.service_type}-`, ".sh");
    const filename = `monitor-${template.service_type}-${seq}.sh`;
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

exports.listMonitoringScripts = async (req, res) => {
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
    const { count, rows } = await MonitoringScript.findAndCountAll({
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
    console.error("❌ Erreur list monitoring scripts:", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

exports.updateMonitoringScript = async (req, res) => {
  try {
    const { id } = req.params;
    const record = await MonitoringScript.findByPk(id);
    if (!record) return res.status(404).json({ message: "Script introuvable" });
    const { name, config_data } = req.body;
    if (name) record.name = name;
    if (config_data) record.config_data = config_data;
    await record.save();
    res.json({ message: "Script mis à jour", record });
  } catch (err) {
    console.error("❌ Erreur update monitoring script:", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
};

exports.deleteMonitoringScript = async (req, res) => {
  try {
    const { id } = req.params;
    const record = await MonitoringScript.findByPk(id);
    if (!record) return res.status(404).json({ message: "Script introuvable" });
    await record.destroy();
    res.json({ message: "Script supprimé" });
  } catch (err) {
    console.error("❌ Erreur delete monitoring script:", err);
    res.status(500).json({ message: "Erreur serveur" });
  }
};
