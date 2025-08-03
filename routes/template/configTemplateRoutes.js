const express = require("express");
const router = express.Router();
const {
  createTemplate,
  listTemplates,
  updateTemplate,
  deleteTemplate,
} = require("../../controllers/template/configTemplateController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.post("/create", verifyToken, checkPermission("configTemplate.create"), createTemplate);
router.get("/create", verifyToken, checkPermission("configTemplate.list"), listTemplates);
router.put("/create/:id", verifyToken, checkPermission("configTemplate.update"), updateTemplate);
router.delete("/create/:id", verifyToken, checkPermission("configTemplate.delete"), deleteTemplate);

module.exports = router;
