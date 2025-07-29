// routes/supervisionRoutes.js
const express = require("express");
const router = express.Router();
const fetchController = require("../../controllers/supervision/fetchSupervisionController");
const { SupervisionStatus, ServiceStatus } = require("../../models");

// 📥 Import JSON depuis VM (déjà existant)
router.post("/fetch", fetchController.fetchFromDynamicVM);


// 📄 Récupérer tous les statuts enregistrés
router.get("/status", async (req, res) => {
  try {
    const data = await SupervisionStatus.findAll({ order: [["timestamp", "DESC"]] });
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📄 Récupérer tous les services enregistrés
router.get("/services", async (req, res) => {
  try {
    const data = await ServiceStatus.findAll({ order: [["timestamp", "DESC"]] });
    res.status(200).json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
