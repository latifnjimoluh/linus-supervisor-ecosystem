const express = require("express");
const router = express.Router();
const { convertToTemplate } = require("../controllers/templateController");
const { verifyToken, checkPermission } = require("../middlewares/auth");

router.post(
  "/convert",
  verifyToken,
  checkPermission("template.convert"),
  convertToTemplate
);

module.exports = router;
