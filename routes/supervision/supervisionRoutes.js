const express = require("express");
const router = express.Router();
const controller = require("../../controllers/supervision/supervisionFetchController");
const { StatusSnapshot, ServiceStatus } = require("../../models");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


// 📥 Import JSON depuis VM (auth + permission)
router.post(
  "/fetch",
  verifyToken,
  checkPermission("supervision.fetch"),
  logUserAction("Supervision fetch", (req) => `Host: ${req.body?.host}`),
  controller.fetchFromDynamicVM
);

// 📄 Lire les statuts supervision (lecture simple, pas de permission nécessaire)
router.get("/status", async (req, res) => {
  try {
    const data = await StatusSnapshot.findAll({ order: [["timestamp", "DESC"]] });
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📄 Lire les statuts de services (lecture simple)
router.get("/services", async (req, res) => {
  try {
    const data = await ServiceStatus.findAll({ order: [["timestamp", "DESC"]] });
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
