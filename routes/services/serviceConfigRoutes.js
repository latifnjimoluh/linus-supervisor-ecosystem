const express = require("express");
const router = express.Router();
const {
  configureService,
  listConfigTemplates,
  updateConfigTemplate,
  deleteConfigTemplate,
} = require("../../controllers/template/templateServiceController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.post(
  "/config-template",
  verifyToken,
  checkPermission("serviceConfig.configure"),
  configureService
);

router.get(
  "/config-template",
  verifyToken,
  checkPermission("serviceConfig.read"),
  listConfigTemplates
);

router.put(
  "/config-template/:id",
  verifyToken,
  checkPermission("serviceConfig.update"),
  updateConfigTemplate
);

router.delete(
  "/config-template/:id",
  verifyToken,
  checkPermission("serviceConfig.delete"),
  deleteConfigTemplate
);

module.exports = router;
