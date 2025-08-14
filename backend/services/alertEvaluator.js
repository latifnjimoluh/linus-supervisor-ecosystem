const DEFAULT_THRESHOLDS = {
  cpu: Number(process.env.ALERT_CPU_THRESHOLD) || 10,
  ram: Number(process.env.ALERT_RAM_THRESHOLD) || 10,
  freshnessMinutes: Number(process.env.ALERT_FRESHNESS_MINUTES) || 5,
};

/**
 * Evaluate CPU and RAM usage against thresholds.
 * @param {object} metrics
 * @param {number} metrics.cpu_usage - CPU usage in percentage (0-100).
 * @param {number} metrics.memory_usage - Memory used in KB.
 * @param {number} metrics.memory_total - Total memory in KB.
 * @param {Date|string|null} metrics.last_monitoring - Last monitoring timestamp.
 * @param {object} [overrides] thresholds overrides
 * @returns {Array} Array of alert objects
 */
function evaluateResourceAlerts(metrics, overrides = {}) {
  const cfg = { ...DEFAULT_THRESHOLDS, ...overrides };
  const alerts = [];
  const { cpu_usage = 0, memory_usage = 0, memory_total = 0, last_monitoring } = metrics;
  const now = Date.now();
  const last = last_monitoring ? new Date(last_monitoring).getTime() : null;
  const fresh = last ? now - last <= cfg.freshnessMinutes * 60 * 1000 : false;

  if (cpu_usage > cfg.cpu) {
    alerts.push({
      type: 'CPU',
      value_percent: Number(cpu_usage.toFixed(2)),
      threshold: cfg.cpu,
      state: 'WARNING',
      freshness: fresh ? 'fresh' : 'stale',
    });
  }

  const memPct = memory_total ? (memory_usage / memory_total) * 100 : 0;
  if (memPct > cfg.ram) {
    alerts.push({
      type: 'RAM',
      value_percent: Number(memPct.toFixed(2)),
      threshold: cfg.ram,
      state: 'WARNING',
      freshness: fresh ? 'fresh' : 'stale',
    });
  }

  return alerts;
}

module.exports = { evaluateResourceAlerts };
