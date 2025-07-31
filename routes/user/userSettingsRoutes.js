const express = require("express");
const router = express.Router();
const userSettingsController = require("../../controllers/user/userSettingsController");

const { verifyToken, checkRole } = require("../../middlewares/auth");

router.get("/", verifyToken, userSettingsController.getUserSettings);
router.patch("/", verifyToken, userSettingsController.updateUserSettings);
router.post("/", verifyToken, userSettingsController.createUserSettings);

module.exports = router;
