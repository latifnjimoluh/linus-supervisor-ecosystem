const fs = require("fs");
const path = require("path");
const { Deployment, Delete, UserSetting } = require("../../models");
const {
  summarizeDeploymentLogs,
  analyzeDeploymentPlan,
} = require("../../services/iaService");
const axios = require("axios");
const https = require("https");
const { Op } = require("sequelize");

const isUUID = (v) =>
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(v);

exports.getById = async (req, res) => {
  try {
    const { id } = req.params;

    let dep = null;
    if (isUUID(id)) {
      dep = await Deployment.findOne({ where: { instance_id: id } });
    } else {
      const pk = Number(id);
      if (!Number.isFinite(pk)) {
        return res.status(400).json({ message: "Paramètre id invalide." });
      }
      dep = await Deployment.findByPk(pk);
    }

    if (!dep) {
      return res.status(404).json({ message: "Déploiement introuvable" });
    }

    let log = null;
    if (dep.log_path) {
      try {
        const absPath = path.isAbsolute(dep.log_path)
          ? dep.log_path
          : path.resolve(process.cwd(), dep.log_path);
        if (fs.existsSync(absPath)) {
          log = fs.readFileSync(absPath, "utf8");
        }
      } catch {
        log = null; // on n’échoue pas si le log est illisible
      }
    }

    return res.json({
      id: dep.id,
      vm_name: dep.vm_name,
      template: dep.service_name,
      status: dep.status || (dep.success ? "completed" : "failed"),
      started_at: dep.started_at,
      ended_at: dep.ended_at,
      log,
    });
  } catch (err) {
    console.error("getById error:", err); // aide debug serveur
    return res
      .status(500)
      .json({ message: "Erreur lors de la récupération du déploiement", error: err.message });
  }
};

// 📋 Résumer les logs d'un déploiement
exports.summarizeLogs = async (req, res) => {
  try {
    const { id } = req.params;

    const where = isUUID(id) ? { instance_id: id } : { id: Number(id) };
    const dep = await Deployment.findOne({ where });
    if (!dep) {
      return res.status(404).json({ message: "Déploiement introuvable" });
    }
    if (!dep.log_path) {
      return res.status(404).json({ message: "Aucun log disponible pour ce déploiement" });
    }

    const absPath = path.isAbsolute(dep.log_path)
      ? dep.log_path
      : path.resolve(process.cwd(), dep.log_path);
    if (!fs.existsSync(absPath)) {
      return res.status(404).json({ message: "Fichier de log introuvable" });
    }
    const logs = fs.readFileSync(absPath, "utf8");

    const summary = await summarizeDeploymentLogs(logs, {
      entityType: "deployment",
      entityId: dep.id,
    });
    return res.json({ summary });
  } catch (err) {
    console.error("summarizeLogs error:", err);
    return res
      .status(500)
      .json({ message: "Erreur lors du résumé des logs", error: err.message });
  }
};

// 🧠 Analyse IA des paramètres de déploiement (avant exécution)
exports.analyzeConfig = async (req, res) => {
  try {
    const plan = req.body || {};
    const analysis = await analyzeDeploymentPlan(plan, {
      entityType: "deployment_plan",
      entityId: null,
    });
    return res.json({ analysis });
  } catch (err) {
    console.error("analyzeConfig error:", err);
    return res
      .status(500)
      .json({ message: "Erreur lors de l'analyse de la configuration", error: err.message });
  }
};

// 📦 Vérifier l'espace disque disponible pour le stockage cible
exports.checkSpace = async (req, res) => {
  try {
    const { disk_size } = req.query; // en Go
    const requested = Number(disk_size);

    const settings = await UserSetting.findOne({ where: { user_id: req.user.id } });
    if (!settings) {
      return res.status(404).json({ message: "Paramètres Proxmox introuvables." });
    }

    const url = `${settings.proxmox_api_url}/nodes/${settings.proxmox_node}/storage/${settings.vm_storage}/status`;
    const headers = {
      Authorization: `PVEAPIToken=${settings.proxmox_api_token_id}!${settings.proxmox_api_token_name}=${settings.proxmox_api_token_secret}`,
    };
    const httpsAgent = new https.Agent({ rejectUnauthorized: false });
    const response = await axios.get(url, { httpsAgent, headers });
    const availBytes = response.data?.data?.avail || 0;
    const available = Math.floor(availBytes / (1024 ** 3));
    const fits = Number.isFinite(requested) ? requested <= available : true;
    const suggested = available > 0 ? Math.max(available, 10) : 10;
    return res.json({ available, requested, fits, suggested });
  } catch (err) {
    console.error("checkSpace error:", err);
    return res.status(500).json({ message: "Erreur lors de la vérification d'espace disque", error: err.message });
  }
};

// 📚 Historique des opérations de VM (déploiements et destructions)
exports.history = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 10,
      status,
      user: userEmail,
      startDate,
      endDate,
    } = req.query;

    const offset = (Number(page) - 1) * Number(limit);

    const deployWhere = {};
    const deleteWhere = {};

    if (status === "success") deployWhere.success = true;
    if (status === "failed") deployWhere.success = false;

    if (userEmail) {
      deployWhere.user_email = userEmail;
      deleteWhere.user_email = userEmail;
    }

    if (startDate || endDate) {
      const range = {};
      if (startDate) range[Op.gte] = new Date(startDate);
      if (endDate) range[Op.lte] = new Date(endDate);
      deployWhere.started_at = range;
      deleteWhere.deleted_at = range;
    }

    const [deployments, deletions] = await Promise.all([
      Deployment.findAndCountAll({
        where: deployWhere,
        order: [["started_at", "DESC"]],
        offset,
        limit: Number(limit),
      }),
      Delete.findAndCountAll({
        where: deleteWhere,
        order: [["deleted_at", "DESC"]],
        offset,
        limit: Number(limit),
      }),
    ]);

    return res.json({
      deployments: deployments.rows.map((d) => ({
        id: d.id,
        vm_name: d.vm_name,
        started_at: d.started_at,
        status: d.success ? "success" : "failed",
        user_email: d.user_email,
      })),
      deletes: deletions.rows.map((d) => ({
        id: d.id,
        vm_name: d.vm_name,
        deleted_at: d.deleted_at,
        user_email: d.user_email,
      })),
      pagination: {
        page: Number(page),
        limit: Number(limit),
        deploymentsTotal: deployments.count,
        deletionsTotal: deletions.count,
      },
    });
  } catch (err) {
    console.error("history error:", err);
    return res
      .status(500)
      .json({ message: "Erreur lors de la récupération de l'historique", error: err.message });
  }
};
