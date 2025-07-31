const express = require("express");
const router = express.Router();
const { convertToTemplate } = require("../controllers/templateController");
const { verifyToken } = require("../middlewares/auth");

router.post("/convert", verifyToken, convertToTemplate);

module.exports = router;
