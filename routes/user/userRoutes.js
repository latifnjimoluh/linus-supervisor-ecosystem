const express = require("express");
const router = express.Router();
const userController = require("../../controllers/user/userController");
const { verifyToken, checkPermission } = require("../../middlewares/auth");
const logUserAction = require("../../middlewares/logUserAction");

router.get("/", verifyToken, checkPermission("users.read"), userController.getAllUsers);
router.get("/search", verifyToken, checkPermission("users.read"), userController.searchUsers);
router.get("/:id", verifyToken, checkPermission("users.read"), userController.getUserById);
router.post(
  "/",
  verifyToken,
  checkPermission("users.create"),
  logUserAction("Création d'utilisateur", (req) => `Email: ${req.body.email}`),
  userController.createUser
);
router.put(
  "/:id",
  verifyToken,
  checkPermission("users.update"),
  logUserAction("Modification utilisateur", (req) => `ID: ${req.params.id}`),
  userController.updateUser
);
router.patch(
  "/:id",
  verifyToken,
  checkPermission("users.update"),
  logUserAction("Patch utilisateur", (req) => `ID: ${req.params.id}`),
  userController.patchUser
);
router.delete(
  "/:id",
  verifyToken,
  checkPermission("users.delete"),
  logUserAction("Suppression utilisateur", (req) => `ID: ${req.params.id}`),
  userController.softDeleteUser
);

module.exports = router;
