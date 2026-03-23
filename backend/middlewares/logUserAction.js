const { UserActivityLog } = require("../models");
const { v4: uuidv4 } = require("uuid");

const logUserAction = (actionLabel, detailsInput = "") => {
  return async (req, res, next) => {
    try {
      const user = req.user;

      if (!user || !user.id) {
        console.warn("⛔️ logUserAction : req.user.id non défini");
        return next();
      }

      let details = "";

      // 🔐 Détails générés dynamiquement ou statiquement
      if (typeof detailsInput === "function") {
        try {
          details = detailsInput(req) || "ℹ️ Aucune information détaillée fournie.";
        } catch (err) {
          console.warn("⚠️ Erreur génération des détails:", err.message);
          details = "⚠️ Impossible de générer les détails.";
        }
      } else if (typeof detailsInput === "string") {
        details = detailsInput || "ℹ️ Aucune information détaillée fournie.";
      }

      console.log(`📝 Tentative de log - Utilisateur ID: ${user.id}, Action: ${actionLabel}, Details: ${details}`);

      const logEntry = await UserActivityLog.create({
        id: uuidv4(),
        user_id: user.id,
        action: actionLabel,
        details,
      });

      console.log("✅ Action loguée avec succès :", logEntry.toJSON());
    } catch (err) {
      console.error("❌ Erreur lors du log d'action :", err);
    }

    next();
  };
};

module.exports = logUserAction;
