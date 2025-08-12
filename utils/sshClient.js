const { Client } = require('ssh2');

/**
 * Retrieve raw content of a remote file via SSH
 * @param {Object} options
 * @param {string} options.host
 * @param {string} options.username
 * @param {string} options.privateKey
 * @param {string} options.filePath
 * @returns {Promise<string>}
 */
const getRemoteFileContent = async ({ host, username, privateKey, filePath }) => {
  console.log(`📥 getRemoteFileContent from ${username}@${host}:${filePath}`);
  return new Promise((resolve, reject) => {
    const conn = new Client();
    conn
      .on('ready', () => {
        conn.sftp((err, sftp) => {
          if (err) return reject(err);
          const stream = sftp.createReadStream(filePath);
          let content = '';
          stream.on('data', chunk => (content += chunk));
          stream.on('end', () => {
            conn.end();
            console.log(`📤 getRemoteFileContent retrieved ${content.length} bytes`);
            resolve(content);
          });
          stream.on('error', err2 => {
            conn.end();
            reject(err2);
          });
        });
      })
      .on('error', reject)
      .connect({ host, username, privateKey });
  });
};

/**
 * Execute a remote command over SSH
 * @param {Object} options
 * @param {string} options.host
 * @param {string} options.username
 * @param {string} options.privateKey
 * @param {string} options.command
 * @returns {Promise<{ stdout: string, stderr: string, code: number | null }>} separate output streams
 */
const execSSHCommand = ({ host, username, privateKey, command }) => {
  console.log(`🔐 execSSHCommand ${command} on ${username}@${host}`);
  return new Promise((resolve, reject) => {
    const conn = new Client();
    let stdout = '';
    let stderr = '';
    let exitCode = null;

    conn
      .on('ready', () => {
        conn.exec(command, (err, stream) => {
          if (err) return reject(err);
          stream
            .on('data', data => {
              stdout += data.toString();
            })
            .on('close', code => {
              exitCode = code;
              conn.end();
              console.log('📤 execSSHCommand stdout:', stdout);
              if (stderr) console.log('📤 execSSHCommand stderr:', stderr);
              resolve({ stdout, stderr, code: exitCode });
            })
            .stderr.on('data', data => {
              stderr += data.toString();
            });
        });
      })
      .on('error', err => {
        console.error('❌ execSSHCommand error:', err.message);
        reject(err);
      })
      .connect({ host, username, privateKey });
  });
};

/**
 * Sanitize raw JSON text by escaping newlines that appear inside
 * quoted strings. Some remote scripts write multi-line values without
 * escaping them, which breaks JSON.parse.
 * @param {string} raw
 * @returns {string}
 */
function sanitizeJSONString(raw) {
  let sanitized = '';
  let inQuotes = false;
  for (let i = 0; i < raw.length; i++) {
    const ch = raw[i];
    if (ch === '"' && raw[i - 1] !== '\\') {
      inQuotes = !inQuotes;
      sanitized += ch;
    } else if (inQuotes && (ch === '\n' || ch === '\r')) {
      sanitized += '\\n';
    } else {
      sanitized += ch;
    }
  }
  return sanitized;
}

/**
 * Retrieve and parse a remote JSON file via SSH
 * @param {Object} options
 * @param {string} options.host
 * @param {string} options.username
 * @param {string} options.privateKey
 * @param {string} options.filePath
 * @returns {Promise<Object>}
 */
const getRemoteJSON = async ({ host, username, privateKey, filePath }) => {
  console.log(`📥 getRemoteJSON from ${filePath}`);
  const raw = await getRemoteFileContent({ host, username, privateKey, filePath });
  try {
    return JSON.parse(raw);
  } catch (err) {
    // If the JSON is invalid due to unescaped newlines inside string values,
    // attempt to sanitize and parse again.
    const sanitized = sanitizeJSONString(raw);
    return JSON.parse(sanitized);
  }
};


module.exports = {
  getRemoteFileContent,
  getRemoteJSON,
  execSSHCommand,
};
