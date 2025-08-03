const { UserActionLog } = require("../models");
const { v4: uuidv4 } = require("uuid");

module.exports = (req, res, next) => {
  res.on("finish", async () => {
    try {
      const user = req.user;
      if (!user || !user.id) return;

      const actionLabel = `${req.method} ${req.originalUrl}`;
      const details = JSON.stringify({
        params: req.params,
        query: req.query,
        body: req.body
      });

      await UserActionLog.create({
        id: uuidv4(),
        user_id: user.id,
        action: actionLabel,
        details
      });
    } catch (err) {
      console.error("❌ Erreur logAllActions:", err.message);
    }
  });
  next();
};
