const express = require("express");
const router = express.Router();
const { configureService } = require("../../controllers/template/templateServiceController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.post(
  "/config-template",
  verifyToken,
  checkPermission("serviceConfig.configure"),
  configureService
);

module.exports = router;
