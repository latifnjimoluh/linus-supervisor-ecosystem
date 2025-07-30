const express = require("express");
const router = express.Router();
const { createTemplate } = require("../../controllers/template/configTemplateController");
const { verifyToken, checkRole } = require("../../middlewares/auth");

router.post("/Create", verifyToken, checkRole(["superadmin"]), createTemplate);

module.exports = router;
