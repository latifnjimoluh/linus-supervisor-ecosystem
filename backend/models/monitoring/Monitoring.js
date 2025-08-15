const { evaluateResourceAlerts } = require('../../services/alertEvaluator');
const { sendAlertEmail } = require('../../utils/mailer');

module.exports = (sequelize, DataTypes) => {
  const Monitoring = sequelize.define('Monitoring', {
    vm_ip: {
      type: DataTypes.STRING,
    },
    ip_address: {
      type: DataTypes.STRING,
    },
    instance_id: {
      type: DataTypes.STRING,
    },
    services_status: {
      type: DataTypes.JSONB,
    },
    system_status: {
      type: DataTypes.JSONB,
    },
    logs_status: {
      type: DataTypes.JSONB,
    },
    retrieved_at: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: DataTypes.NOW,
    },
  }, {
    tableName: 'monitorings',
    underscored: true,
    timestamps: true,
    createdAt: 'created_at',
    updatedAt: 'updated_at',
  });

  Monitoring.addHook('afterCreate', async (monitoring) => {
    try {
      const system = monitoring.system_status || {};
      const mem = system.memory || {};
      const metrics = {
        cpu_usage: system.cpu_usage || system.cpu?.percent || 0,
        memory_total: mem.total_kb || mem.total || 0,
        memory_usage: (mem.total_kb || mem.total || 0) - (mem.available_kb || mem.free_kb || 0),
        last_monitoring: monitoring.retrieved_at,
      };
      const alerts = evaluateResourceAlerts(metrics);
      for (const a of alerts) {
        const serverName = monitoring.vm_ip || monitoring.ip_address || monitoring.instance_id || 'unknown';
        const description = `${a.type} usage ${a.value_percent}% (seuil ${a.threshold}%)`;
        const [record, created] = await sequelize.models.Alert.findOrCreate({
          where: { server: serverName, service: a.type, status: 'en_cours' },
          defaults: { severity: 'critique', description },
        });
        if (created) {
          const recipients = (process.env.ALERT_EMAIL_TO || '')
            .split(',')
            .map((e) => e.trim())
            .filter(Boolean);
          await sendAlertEmail(recipients, {
            server: serverName,
            service: a.type,
            value: a.value_percent,
            threshold: a.threshold,
            description,
          });
        }
      }
    } catch (e) {
      console.error('afterCreate Monitoring hook failed', e);
    }
  });

  return Monitoring;
};
