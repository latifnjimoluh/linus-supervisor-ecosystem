const express = require("express");
const router = express.Router();
const db = require("../models");
const { verifyToken, checkRole } = require("../middlewares/auth");

// 🔎 Lister les scripts initiaux disponibles pour un service donné
router.get("/:service_type", verifyToken, checkRole(["technicien", "superadmin"]), async (req, res) => {
  const { service_type } = req.params;

  try {
    const scripts = await db.InitScript.findAll({
      where: { service_type },
      order: [["created_at", "DESC"]],
    });

    return res.status(200).json({
      count: scripts.length,
      scripts,
    });

  } catch (error) {
    console.error("❌ Erreur récupération init scripts :", error);
    return res.status(500).json({ message: "Erreur serveur", error: error.message });
  }
});

module.exports = router;
