const express = require("express");
const router = express.Router();
const { convertToTemplate, getConversionHistory } = require("../../controllers/vm/templateVmController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");

router.post(
  "/convert",
  verifyToken,
  checkPermission("template.convert"),
  logUserAction("Conversion d'une VM en template", req => `Body: ${JSON.stringify(req.body)}`),
  convertToTemplate
);

router.get(
  "/history",
  verifyToken,
  checkPermission("convert.history.view"),
  logUserAction("Consultation de l'historique de conversion"),
  getConversionHistory
);

module.exports = router;
