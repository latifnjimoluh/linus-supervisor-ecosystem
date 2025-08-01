const express = require("express");
const router = express.Router();
const { createTemplate } = require("../../controllers/template/configTemplateController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.post("/create", verifyToken, checkPermission("configTemplate.create"), createTemplate);

module.exports = router;
