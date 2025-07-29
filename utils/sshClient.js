// utils/sshClient.js
const { Client } = require("ssh2");

/**
 * Récupère un fichier JSON distant via SSH
 * @param {Object} options
 * @param {string} options.host - IP ou hostname de la VM
 * @param {string} options.username - utilisateur SSH
 * @param {string} [options.password] - mot de passe SSH (optionnel si privateKey)
 * @param {string} [options.privateKey] - chemin ou contenu de la clé privée
 * @param {string} options.filePath - chemin absolu du fichier JSON à lire
 * @returns {Promise<Object>} - JSON parsé depuis la VM
 */
function getRemoteJSON({ host, username, password, privateKey, filePath }) {
  return new Promise((resolve, reject) => {
    const conn = new Client();

    conn
      .on("ready", () => {
        conn.exec(`cat ${filePath}`, (err, stream) => {
          if (err) return reject(err);

          let data = "";
          stream
            .on("data", (chunk) => (data += chunk))
            .on("close", (code, signal) => {
              conn.end();
              try {
                const json = JSON.parse(data);
                resolve(json);
              } catch (parseError) {
                reject(new Error("Erreur parsing JSON distant: " + parseError.message));
              }
            });
        });
      })
      .on("error", reject)
      .connect({
        host,
        port: 22,
        username,
        password,
        privateKey,
      });
  });
}

module.exports = { getRemoteJSON };
