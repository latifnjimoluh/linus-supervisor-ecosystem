const express = require("express");
const router = express.Router();
const {
  configureService,
  listConfigTemplates,
  updateConfigTemplate,
  deleteConfigTemplate,
} = require("../../controllers/template/templateServiceController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


router.post(
  "/config-template",
  verifyToken,
  checkPermission("serviceConfig.configure"),
  logUserAction("Création de template de configuration", req => `Body: ${JSON.stringify(req.body)}`),
  configureService
);

router.get(
  "/config-template",
  verifyToken,
  checkPermission("serviceConfig.read"),
  logUserAction("Consultation des templates de configuration"),
  listConfigTemplates
);

router.put(
  "/config-template/:id",
  verifyToken,
  checkPermission("serviceConfig.update"),
  logUserAction("Mise à jour de template de configuration", req => `ID: ${req.params.id}`),
  updateConfigTemplate
);

router.delete(
  "/config-template/:id",
  verifyToken,
  checkPermission("serviceConfig.delete"),
  logUserAction("Suppression de template de configuration", req => `ID: ${req.params.id}`),
  deleteConfigTemplate
);

module.exports = router;
