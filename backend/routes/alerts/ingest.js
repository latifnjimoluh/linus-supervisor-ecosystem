// routes/alerts/ingest.js
const express = require('express');
const router = express.Router();
const { handleResourceMetrics } = require('../../services/alertingService');
const { verifyToken, checkPermission } = require('../../middlewares/auth');

router.use(verifyToken);

router.post('/ingest', checkPermission('alert.create'), async (req, res) => {
  try {
    const { vms = [] } = req.body || {};
    const results = [];
    for (const vm of vms) {
      const r = await handleResourceMetrics(vm, {}, { userEmail: req.user?.email });
      results.push({ vm: vm.id || vm.name || vm.hostname, ...r });
    }
    res.json({ ok: true, results });
  } catch (e) {
    console.error('[INGEST] échec:', e);
    res.status(500).json({ message: 'Erreur lors du traitement des métriques.' });
  }
});

module.exports = router;
