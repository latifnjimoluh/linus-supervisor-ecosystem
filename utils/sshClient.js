// utils/sshClient.js
const { Client } = require("ssh2");

/**
 * Récupère le contenu brut d'un fichier distant via SSH
 * @param {Object} options
 * @param {string} options.host
 * @param {string} options.username
 * @param {string} options.privateKey
 * @param {string} options.filePath
 * @returns {Promise<string>}
 */
const getRemoteFileContent = async ({ host, username, privateKey, filePath }) => {
  return new Promise((resolve, reject) => {
    const conn = new Client();
    conn
      .on("ready", () => {
        conn.sftp((err, sftp) => {
          if (err) return reject(err);
          const stream = sftp.createReadStream(filePath);
          let content = "";
          stream.on("data", chunk => (content += chunk));
          stream.on("end", () => {
            conn.end();
            resolve(content);
          });
          stream.on("error", reject);
        });
      })
      .on("error", reject)
      .connect({ host, username, privateKey });
  });
};

/**
 * Exécute une commande distante via SSH
 * @param {Object} options
 * @param {string} options.host
 * @param {string} options.username
 * @param {string} options.privateKey
 * @param {string} options.command
 * @returns {Promise<{ stdout: string, stderr: string }>}
 */

const execSSHCommand = ({ host, username, privateKey, command }) => {
  return new Promise((resolve, reject) => {
    const conn = new Client();
    let output = "";

    conn
      .on("ready", () => {
        conn.exec(command, (err, stream) => {
          if (err) return reject(err);
          stream
            .on("data", (data) => {
              output += data.toString();
            })
            .on("close", () => {
              conn.end();
              resolve(output.trim());
            })
            .stderr.on("data", (data) => {
              output += data.toString(); // capture stderr aussi
            });
        });
      })
      .on("error", reject)
      .connect({ host, username, privateKey });
  });
};


/**
 * Récupère un fichier JSON distant et le parse
 * @param {Object} options
 * @param {string} options.host
 * @param {string} options.username
 * @param {string} options.privateKey
 * @param {string} options.filePath
 * @returns {Promise<Object>}
 */
const getRemoteJSON = async ({ host, username, privateKey, filePath }) => {
  const raw = await getRemoteFileContent({ host, username, privateKey, filePath });
  return JSON.parse(raw);
};

module.exports = {
  getRemoteFileContent,
  getRemoteJSON,
  execSSHCommand
};
