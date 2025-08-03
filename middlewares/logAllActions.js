const { UserActionLog } = require("../models");
const { v4: uuidv4 } = require("uuid");

const ACTIONS = [
  { method: "GET", path: /^\/api\/user-logs/, label: "Consultation des journaux utilisateur" },
  { method: "GET", path: /^\/api\/services\/config-template/, label: "Consultation des services configurés" },
  { method: "POST", path: /^\/api\/services\/config-template/, label: "Création d'un service configuré" },
  { method: "GET", path: /^\/api\/vm\/deployed/, label: "Liste des VMs déployées" },
  { method: "GET", path: /^\/api\/vm\/destroyed/, label: "Liste des VMs détruites" },
  { method: "GET", path: /^\/api\/monitoring\/generate/, label: "Consultation des scripts de monitoring" },
  { method: "POST", path: /^\/api\/monitoring\/generate/, label: "Génération d'un script de monitoring" },
  { method: "PUT", path: /^\/api\/monitoring\/generate/, label: "Mise à jour d'un script de monitoring" },
  { method: "DELETE", path: /^\/api\/monitoring\/generate/, label: "Suppression d'un script de monitoring" },
  { method: "GET", path: /^\/api\/monitoring\/monitoring-services\/generate/, label: "Consultation des scripts de surveillance de services" },
  { method: "POST", path: /^\/api\/monitoring\/monitoring-services\/generate/, label: "Génération d'un script de surveillance de services" },
  { method: "PUT", path: /^\/api\/monitoring\/monitoring-services\/generate/, label: "Mise à jour d'un script de surveillance de services" },
  { method: "DELETE", path: /^\/api\/monitoring\/monitoring-services\/generate/, label: "Suppression d'un script de surveillance de services" },
  { method: "GET", path: /^\/api\/init-scripts\/generate/, label: "Consultation des scripts d'initialisation" },
  { method: "POST", path: /^\/api\/init-scripts\/generate/, label: "Génération d'un script d'initialisation" },
  { method: "PUT", path: /^\/api\/init-scripts\/generate/, label: "Mise à jour d'un script d'initialisation" },
  { method: "DELETE", path: /^\/api\/init-scripts\/generate/, label: "Suppression d'un script d'initialisation" },
  { method: "GET", path: /^\/api\/templates\/create/, label: "Consultation des templates" },
  { method: "POST", path: /^\/api\/templates\/create/, label: "Création d'un template" },
  { method: "PUT", path: /^\/api\/templates\/create/, label: "Mise à jour d'un template" },
  { method: "DELETE", path: /^\/api\/templates\/create/, label: "Suppression d'un template" },
];

function describeAction(req) {
  const entry = ACTIONS.find(a => a.method === req.method && a.path.test(req.originalUrl));
  return entry ? entry.label : `${req.method} ${req.originalUrl}`;
}

module.exports = (req, res, next) => {
  res.on("finish", async () => {
    try {
      const user = req.user;
      if (!user || !user.id) return;

      const actionLabel = describeAction(req);
      const hasDetails =
        (req.params && Object.keys(req.params).length) ||
        (req.query && Object.keys(req.query).length) ||
        (req.body && Object.keys(req.body).length);
      const details = hasDetails
        ? JSON.stringify({ params: req.params, query: req.query, body: req.body })
        : "ℹ️ Aucune information détaillée fournie.";

      await UserActionLog.create({
        id: uuidv4(),
        user_id: user.id,
        action: actionLabel,
        details,
      });
    } catch (err) {
      console.error("❌ Erreur logAllActions:", err.message);
    }
  });
  next();
};
