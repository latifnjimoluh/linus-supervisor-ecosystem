const { exec } = require('child_process');

/**
 * Runs a traceroute to the given target.
 * @param {string} target Hostname or IP
 * @returns {Promise<string>} raw traceroute output
 */
function runTraceroute(target) {
  return new Promise((resolve, reject) => {
    if (!target) return reject(new Error('target required'));
    exec(`traceroute -n ${target}`, { timeout: 20000 }, (err, stdout, stderr) => {
      if (err) {
        const msg = stderr || err.message;
        return reject(new Error(`traceroute failed: ${msg}`));
      }
      resolve(stdout);
    });
  });
}

/**
 * Periodically run traceroute to configured targets.
 * Targets provided via options.targets or TRACEROUTE_TARGETS env (comma separated).
 * Interval defined by options.intervalMs or TRACEROUTE_INTERVAL_MS env (default 600000ms).
 * @param {object} [options]
 * @param {string[]} [options.targets]
 * @param {number} [options.intervalMs]
 * @param {(target:string, output:string)=>void} [options.onResult]
 * @param {(target:string, error:Error)=>void} [options.onError]
 */
function startTracerouteMonitor(options = {}) {
  const targets = options.targets || (process.env.TRACEROUTE_TARGETS || '')
    .split(',')
    .map(t => t.trim())
    .filter(Boolean);
  const intervalMs = options.intervalMs || parseInt(process.env.TRACEROUTE_INTERVAL_MS || '600000', 10);
  if (!targets.length || !intervalMs) return null;

  async function tick() {
    for (const t of targets) {
      try {
        const out = await runTraceroute(t);
        if (options.onResult) options.onResult(t, out);
        else console.log(`[TRACEROUTE] ${t}\n${out}`);
      } catch (e) {
        if (options.onError) options.onError(t, e);
        else console.error(`[TRACEROUTE] ${t} error:`, e.message);
      }
    }
  }

  tick();
  return setInterval(tick, intervalMs);
}

module.exports = { runTraceroute, startTracerouteMonitor };
