const express = require("express");
const router = express.Router();
const { createTemplate } = require("../controllers/serviceTemplateController");
const { verifyToken, checkRole } = require("../middlewares/auth");

router.post("/templates", verifyToken, checkRole(["superadmin"]), createTemplate);

module.exports = router;
