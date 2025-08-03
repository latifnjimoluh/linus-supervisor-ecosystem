const express = require("express");
const router = express.Router();
const {
  generateServiceTemplate,
  listServiceTemplates,
  updateServiceTemplate,
  deleteServiceTemplate,
} = require("../../controllers/template/serviceTemplateController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");


router.post(
  "/",
  verifyToken,
  checkPermission("serviceTemplate.create"),
  logUserAction("Création de service template", req => `Body: ${JSON.stringify(req.body)}`),
  generateServiceTemplate
);

router.get(
  "/",
  verifyToken,
  checkPermission("serviceTemplate.read"),
  logUserAction("Consultation des service templates"),
  listServiceTemplates
);

router.put(
  "/:id",
  verifyToken,
  checkPermission("serviceTemplate.update"),
  logUserAction("Mise à jour de service template", req => `ID: ${req.params.id}`),
  updateServiceTemplate
);

router.delete(
  "/:id",
  verifyToken,
  checkPermission("serviceTemplate.delete"),
  logUserAction("Suppression de service template", req => `ID: ${req.params.id}`),
  deleteServiceTemplate
);

module.exports = router;
