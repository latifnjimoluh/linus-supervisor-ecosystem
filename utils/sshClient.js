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
 * @returns {Promise<string>} stdout/stderr combined
 */
const execSSHCommand = ({ host, username, privateKey, command }) => {
  console.log(`🔐 execSSHCommand ${command} on ${username}@${host}`);
  return new Promise((resolve, reject) => {
    const conn = new Client();
    let output = '';

    conn
      .on('ready', () => {
        conn.exec(command, (err, stream) => {
          if (err) return reject(err);
          stream
            .on('data', data => {
              output += data.toString();
            })
            .on('close', () => {
              conn.end();
              console.log('📤 execSSHCommand output:', output.trim());
              resolve(output.trim());
            })
            .stderr.on('data', data => {
              output += data.toString();
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
  return JSON.parse(raw);
};

module.exports = {
  getRemoteFileContent,
  getRemoteJSON,
  execSSHCommand,
};
