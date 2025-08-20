'use strict';

const { Alert, Sequelize } = require('../../models');
const { Op } = Sequelize;
const mailQueue = require('../../utils/notificationQueue');
const { handleResourceMetrics } = require('../../services/alertingService');

/**
 * GET /alerts
 * Filtres :
 * - severity=critique|majeure|mineure
 * - server=<hostname or ip> (match exact)
 * - service=CPU|RAM|...
 * - status=open|acknowledged|resolved
 * - q=texte (recherche dans description/comment/server/service)
 * - from=ISO8601, to=ISO8601 (fenêtre dates sur created_at)
 * - sort=severity|created_at|server|service (par défaut severity puis created_at desc)
 * - dir=asc|desc (si sort présent)
 * - page, limit
 */
exports.listAlerts = async (req, res) => {
  try {
    const page  = Math.max(parseInt(req.query.page) || 1, 1);
    const limit = Math.min(Math.max(parseInt(req.query.limit) || 20, 1), 200);
    const offset = (page - 1) * limit;

    const where = {};

    if (req.query.severity) {
      where.severity = req.query.severity;
    }

    if (req.query.server) {
      where.server = req.query.server;
    }

    if (req.query.service) {
      where.service = req.query.service;
    }

    if (req.query.status) {
      where.status = req.query.status;
    }

    // Fenêtre temporelle
    const from = req.query.from ? new Date(req.query.from) : null;
    const to   = req.query.to   ? new Date(req.query.to)   : null;
    if (from || to) {
      where.created_at = {};
      if (!isNaN(from?.getTime())) where.created_at[Op.gte] = from;
      if (!isNaN(to?.getTime()))   where.created_at[Op.lte] = to;
    }

    // Recherche plein texte simple
    if (req.query.q) {
      const q = `%${req.query.q}%`;
      where[Op.or] = [
        { description: { [Op.like]: q } },
        { comment:     { [Op.like]: q } },
        { server:      { [Op.like]: q } },
        { service:     { [Op.like]: q } },
      ];
    }

    // Tri
    let order = [
      [Sequelize.literal("CASE WHEN severity='critique' THEN 0 WHEN severity='majeure' THEN 1 ELSE 2 END"), 'ASC'],
      ['created_at', 'DESC'],
    ];

    const allowedSort = new Set(['severity', 'created_at', 'server', 'service']);
    const sort = (req.query.sort || '').toLowerCase();
    const dir  = (req.query.dir  || 'desc').toLowerCase() === 'asc' ? 'ASC' : 'DESC';

    if (allowedSort.has(sort)) {
      if (sort === 'severity') {
        order = [[Sequelize.literal("CASE WHEN severity='critique' THEN 0 WHEN severity='majeure' THEN 1 ELSE 2 END"), dir]];
      } else {
        order = [[sort, dir]];
      }
    }

    const { count, rows } = await Alert.findAndCountAll({
      where,
      order,
      limit,
      offset,
    });

    const data = rows.map((r) => ({
      ...r.toJSON(),
      notification_status: mailQueue.getStatus(r.id),
    }));

    res.json({
      data,
      pagination: {
        total: count,
        page,
        pages: Math.ceil(count / limit),
        limit,
      },
      filters: { severity: req.query.severity, server: req.query.server, service: req.query.service, status: req.query.status, from, to, q: req.query.q },
      sort: sort || 'severity,created_at',
      dir: allowedSort.has(sort) ? dir : 'DESC',
    });
  } catch (error) {
    console.error('Erreur récupération alertes:', error);
    res.status(500).json({ message: "Erreur serveur lors de la récupération des alertes." });
  }
};

exports.getAlert = async (req, res) => {
  try {
    const alert = await Alert.findByPk(req.params.id);
    if (!alert) return res.status(404).json({ message: 'Alerte introuvable.' });

    const json = alert.toJSON();
    json.notification_status = mailQueue.getStatus(alert.id);
    res.json(json);
  } catch (error) {
    console.error('Erreur récupération alerte:', error);
    res.status(500).json({ message: "Erreur serveur lors de la récupération de l'alerte." });
  }
};

/**
 * PATCH /alerts/:id
 * Body: { status?, comment? }
 */
exports.updateAlert = async (req, res) => {
  const { id } = req.params;
  try {
    const alert = await Alert.findByPk(id);
    if (!alert) return res.status(404).json({ message: 'Alerte introuvable.' });

    const { status, comment } = req.body;

    if (status) {
      alert.status = status;
      // si on passe en "resolved", on marque ended_at
      if (status === 'resolved') {
        alert.ended_at = new Date();
      }
    }

    if (comment !== undefined) {
      alert.comment = comment;
    }

    await alert.save();
    res.json({ message: 'Alerte mise à jour avec succès', alert });
  } catch (error) {
    console.error('Erreur mise à jour alerte:', error);
    res.status(500).json({ message: "Erreur serveur lors de la mise à jour de l'alerte." });
  }
};

/**
 * POST /alerts/:id/mark
 * Marque comme "acknowledged"
 */
exports.markAlert = async (req, res) => {
  const { id } = req.params;
  try {
    const alert = await Alert.findByPk(id);
    if (!alert) return res.status(404).json({ message: 'Alerte introuvable.' });

    alert.status = 'acknowledged';
    await alert.save();
    res.json({ message: 'Alerte marquée comme traitée', alert });
  } catch (error) {
    console.error('Erreur marquage alerte:', error);
    res.status(500).json({ message: "Erreur serveur lors du marquage de l'alerte." });
  }
};

/**
 * POST /alerts/:id/resolve
 * Raccourci pour passer au statut "resolved" + ended_at
 */
exports.resolveAlert = async (req, res) => {
  const { id } = req.params;
  try {
    const alert = await Alert.findByPk(id);
    if (!alert) return res.status(404).json({ message: 'Alerte introuvable.' });

    alert.status = 'resolved';
    alert.ended_at = new Date();
    await alert.save();

    res.json({ message: 'Alerte résolue', alert });
  } catch (error) {
    console.error('Erreur résolution alerte:', error);
    res.status(500).json({ message: "Erreur serveur lors de la résolution de l'alerte." });
  }
};

/**
 * GET /alerts/notifications/status
 */
exports.notificationStatuses = (req, res) => {
  res.json({ data: mailQueue.getAllStatuses() });
};

/**
 * POST /alerts/:id/resend
 * Relance l’envoi email pour l’alerte (même contenu que description)
 * Body optionnel: { recipients?: string[] }
 */
exports.resendNotification = async (req, res) => {
  try {
    const alert = await Alert.findByPk(req.params.id);
    if (!alert) return res.status(404).json({ message: 'Alerte introuvable.' });

    const bodyRecipients = Array.isArray(req.body?.recipients) ? req.body.recipients : null;
    const defaultRecipients = (process.env.ALERT_EMAIL_TO || '')
      .split(',')
      .map((e) => e.trim())
      .filter(Boolean);

    const recipients = bodyRecipients?.length ? bodyRecipients : defaultRecipients;

    // Si tu as ajouté value_percent/threshold au modèle, on peut les réutiliser. Sinon, 0 fallback.
    mailQueue.enqueue(alert.id, recipients, {
      server: alert.server,
      service: alert.service,
      value: Number(alert.value_percent || 0),
      threshold: Number(alert.threshold || 0),
      description: alert.description || '',
      severity: alert.severity || undefined,
    });

    res.json({ message: 'Notification reprogrammée', id: alert.id, recipients });
  } catch (error) {
    console.error('Erreur renvoi notification:', error);
    res.status(500).json({ message: "Erreur serveur lors du renvoi de la notification." });
  }
};

/**
 * POST /alerts/ingest/resources
 * Attendu body:
 * {
 *   "server": "srv-proxmox-01",
 *   "cpu_usage": 92.4,
 *   "memory_usage": 12345678,
 *   "memory_total": 16000000,
 *   "last_monitoring": "2025-08-19T16:45:00Z"
 * }
 *
 * -> Déclenche automatiquement création alerte + email via alertingService
 */
exports.ingestResources = async (req, res) => {
  try {
    const out = await handleResourceMetrics(req.body, {}, { userEmail: req.user?.email }); // { created, totalAlerts }
    res.json({ ok: true, ...out });
  } catch (error) {
    console.error('Erreur ingestion métriques:', error);
    res.status(500).json({ ok: false, message: "Erreur lors de l'ingestion des métriques." });
  }
};

/**
 * GET /alerts/stats/summary
 * Donne des stats rapides : total par status et par severity
 */
exports.summaryStats = async (req, res) => {
  try {
    const [byStatus] = await Alert.sequelize.query(`
      SELECT status, COUNT(*) as total
      FROM alerts
      GROUP BY status
    `);

    const [bySeverity] = await Alert.sequelize.query(`
      SELECT severity, COUNT(*) as total
      FROM alerts
      GROUP BY severity
    `);

    res.json({ byStatus, bySeverity });
  } catch (error) {
    console.error('Erreur stats summary:', error);
    res.status(500).json({ message: "Erreur serveur lors du calcul des statistiques." });
  }
};
