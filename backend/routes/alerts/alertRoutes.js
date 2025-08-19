'use strict';

const express = require('express');
const router = express.Router();

const alertController = require('../../controllers/alerts/alertController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');

// 🔐 Middlewares globaux pour toutes les routes d'alertes
router.use(verifyToken, logRequest);

/**
 * Liste paginée + filtres/tri
 * GET /alerts
 */
router.get(
  '/',
  checkPermission('alert.list'),
  alertController.listAlerts
);

/**
 * Statuts de la file d’envoi des notifications email
 * GET /alerts/notifications/status
 */
router.get(
  '/notifications/status',
  checkPermission('alert.list'),
  alertController.notificationStatuses
);

/**
 * Statistiques de synthèse (par status / severity)
 * GET /alerts/stats/summary
 */
router.get(
  '/stats/summary',
  checkPermission('alert.list'),
  alertController.summaryStats
);

/**
 * Ingestion de métriques (CPU/RAM…) → évaluations + création d’alertes + envoi mail
 * POST /alerts/ingest/resources
 */
router.post(
  '/ingest/resources',
  checkPermission('alert.create'),
  alertController.ingestResources
);

/**
 * Détail d’une alerte
 * GET /alerts/:id
 */
router.get(
  '/:id',
  checkPermission('alert.list'),
  alertController.getAlert
);

/**
 * Marquer une alerte comme "acknowledged"
 * POST /alerts/:id/mark
 */
router.post(
  '/:id/mark',
  checkPermission('alert.update'),
  alertController.markAlert
);

/**
 * Résoudre une alerte (status=resolved + ended_at)
 * POST /alerts/:id/resolve
 */
router.post(
  '/:id/resolve',
  checkPermission('alert.update'),
  alertController.resolveAlert
);

/**
 * Relancer l’envoi de notification email pour une alerte
 * POST /alerts/:id/resend
 */
router.post(
  '/:id/resend',
  checkPermission('alert.update'),
  alertController.resendNotification
);

/**
 * Mise à jour partielle (status, comment, …)
 * PATCH /alerts/:id
 */
router.patch(
  '/:id',
  checkPermission('alert.update'),
  alertController.updateAlert
);

module.exports = router;
