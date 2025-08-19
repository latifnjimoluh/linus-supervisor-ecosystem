const { Alert, Sequelize } = require('../../models');
const mailQueue = require('../../utils/notificationQueue');

exports.listAlerts = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    const offset = (page - 1) * limit;

    const where = {};
    if (req.query.severity) where.severity = req.query.severity;
    if (req.query.server) where.server = req.query.server;
    if (req.query.service) where.service = req.query.service;
    if (req.query.status) where.status = req.query.status;

    const order = [
      [Sequelize.literal("CASE WHEN severity='critique' THEN 0 WHEN severity='majeure' THEN 1 ELSE 2 END"), 'ASC'],
      ['created_at', 'DESC'],
    ];

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
    res.json(alert);
  } catch (error) {
    console.error('Erreur récupération alerte:', error);
    res.status(500).json({ message: "Erreur serveur lors de la récupération de l'alerte." });
  }
};

exports.updateAlert = async (req, res) => {
  const { id } = req.params;
  try {
    const alert = await Alert.findByPk(id);
    if (!alert) {
      return res.status(404).json({ message: 'Alerte introuvable.' });
    }
    const { status, comment } = req.body;
    if (status) alert.status = status;
    if (comment !== undefined) alert.comment = comment;
    await alert.save();
    res.json({ message: 'Alerte mise à jour avec succès', alert });
  } catch (error) {
    console.error('Erreur mise à jour alerte:', error);
    res.status(500).json({ message: "Erreur serveur lors de la mise à jour de l'alerte." });
  }
};

exports.markAlert = async (req, res) => {
  const { id } = req.params;
  try {
    const alert = await Alert.findByPk(id);
    if (!alert) {
      return res.status(404).json({ message: 'Alerte introuvable.' });
    }
    alert.status = 'acknowledged';
    await alert.save();
    res.json({ message: 'Alerte marquée comme traitée', alert });
  } catch (error) {
    console.error('Erreur marquage alerte:', error);
    res.status(500).json({ message: "Erreur serveur lors du marquage de l'alerte." });
  }
};

exports.notificationStatuses = (req, res) => {
  res.json({ data: mailQueue.getAllStatuses() });
};

exports.resendNotification = async (req, res) => {
  try {
    const alert = await Alert.findByPk(req.params.id);
    if (!alert) {
      return res.status(404).json({ message: 'Alerte introuvable.' });
    }
    const recipients = (process.env.ALERT_EMAIL_TO || '')
      .split(',')
      .map((e) => e.trim())
      .filter(Boolean);
    mailQueue.enqueue(alert.id, recipients, {
      server: alert.server,
      service: alert.service,
      value: 0,
      threshold: 0,
      description: alert.description || '',
    });
    res.json({ message: 'Notification reprogrammée', id: alert.id });
  } catch (error) {
    console.error('Erreur renvoi notification:', error);
    res.status(500).json({ message: "Erreur serveur lors du renvoi de la notification." });
  }
};
