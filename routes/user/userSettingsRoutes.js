const express = require("express");
const router = express.Router();
const userSettingsController = require("../../controllers/user/userSettingsController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");


router.get("/", verifyToken, checkPermission("userSettings.read"), userSettingsController.getUserSettings);
router.patch("/", verifyToken, checkPermission("userSettings.update"), userSettingsController.updateUserSettings);
router.post("/", verifyToken, checkPermission("userSettings.create"), userSettingsController.createUserSettings);

module.exports = router;
