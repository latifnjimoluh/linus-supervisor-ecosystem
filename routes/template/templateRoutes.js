const express = require("express");
const router = express.Router();
const { convertToTemplate, getConversionHistory } = require("../../controllers/vm/templateVmController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");

router.post(
  "/convert",
  verifyToken,
  checkPermission("template.convert"),
  convertToTemplate
);

router.get(
  "/history",
  verifyToken,
  checkPermission("convert.history.view"),
  getConversionHistory
);

module.exports = router;
