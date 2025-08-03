const express = require("express");
const router = express.Router();
const {
  createTemplate,
  listTemplates,
  updateTemplate,
  deleteTemplate,
} = require("../../controllers/template/configTemplateController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


router.post(
  "/create",
  verifyToken,
  checkPermission("configTemplate.create"),
  logUserAction("Création d'un template de configuration", req => `Body: ${JSON.stringify(req.body)}`),
  createTemplate
);
router.get(
  "/create",
  verifyToken,
  checkPermission("configTemplate.list"),
  logUserAction("Consultation des templates de configuration"),
  listTemplates
);
router.put(
  "/create/:id",
  verifyToken,
  checkPermission("configTemplate.update"),
  logUserAction("Mise à jour d'un template de configuration", req => `ID: ${req.params.id}`),
  updateTemplate
);
router.delete(
  "/create/:id",
  verifyToken,
  checkPermission("configTemplate.delete"),
  logUserAction("Suppression d'un template de configuration", req => `ID: ${req.params.id}`),
  deleteTemplate
);

module.exports = router;
