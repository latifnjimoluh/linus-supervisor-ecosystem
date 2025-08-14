const express = require('express');
const router = express.Router();
const authController = require('../../controllers/auth/authController');
const { verifyToken, checkPermission } = require('../../middlewares/auth');
const { logRequest } = require('../../middlewares/log');
const loginLimiter = require('../../middlewares/loginLimiter');

console.log('🚦 authRoutes initialisé');

router.post('/register', verifyToken, checkPermission('user.create'), logRequest, (req, res, next) => {
  console.log('➡️ [Route] POST /auth/register');
  next();
}, authController.register);

router.post('/login', loginLimiter(), logRequest, (req, res, next) => {
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

router.post('/logout', verifyToken, logRequest, (req, res, next) => {
  console.log('➡️ [Route] POST /auth/logout');
  next();
}, authController.logout);

router.post('/refresh', logRequest, (req, res, next) => {
  console.log('➡️ [Route] POST /auth/refresh');
  next();
}, authController.refresh);

router.get('/me', verifyToken, logRequest, (req, res, next) => {
  console.log('➡️ [Route] GET /auth/me');
  next();
}, authController.getMe);

router.post('/change-password', verifyToken, logRequest, (req, res, next) => {
  console.log('➡️ [Route] POST /auth/change-password');
  next();
}, authController.changePassword);

router.post('/2fa/setup', verifyToken, logRequest, (req, res, next) => {
  console.log('➡️ [Route] POST /auth/2fa/setup');
  next();
}, authController.setup2FA);

router.post('/2fa/verify', verifyToken, logRequest, (req, res, next) => {
  console.log('➡️ [Route] POST /auth/2fa/verify');
  next();
}, authController.verify2FA);

router.post('/2fa/disable', verifyToken, logRequest, (req, res, next) => {
  console.log('➡️ [Route] POST /auth/2fa/disable');
  next();
}, authController.disable2FA);

router.get('/reset-history', verifyToken, checkPermission('auth.reset-history'), logRequest, (req, res, next) => {
  console.log('➡️ [Route] GET /auth/reset-history');
  next();
}, authController.getUsersWithResetHistory);

module.exports = router;

