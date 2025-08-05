const express = require('express');
const router = express.Router();
const authController = require('../../controllers/auth/authController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');

console.log('🚦 authRoutes initialisé');

router.post('/register', verifyToken, checkPermission('user.create'), logRequest, (req, res, next) => {
  console.log('➡️ [Route] POST /auth/register');
  next();
}, authController.register);

router.post('/login', logRequest, (req, res, next) => {
  console.log('➡️ [Route] POST /auth/login');
  next();
}, authController.login);

router.post('/request-reset', logRequest, (req, res, next) => {
  console.log('➡️ [Route] POST /auth/request-reset');
  next();
}, authController.requestReset);

router.post('/reset-password', logRequest, (req, res, next) => {
  console.log('➡️ [Route] POST /auth/reset-password');
  next();
}, authController.resetPassword);

router.get('/reset-history', verifyToken, checkPermission('auth.reset-history'), logRequest, (req, res, next) => {
  console.log('➡️ [Route] GET /auth/reset-history');
  next();
}, authController.getUsersWithResetHistory);

module.exports = router;

