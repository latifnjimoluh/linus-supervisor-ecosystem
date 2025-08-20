let snmp;
const { sendSlackMessage } = require('./slackService');

function getSnmpLib() {
  if (!snmp) {
    snmp = require('net-snmp');
  }
  return snmp;
}

function getSnmpValue(host, community, oid) {
  const lib = getSnmpLib();
  return new Promise((resolve, reject) => {
    const session = lib.createSession(host, community);
    session.get([oid], (error, varbinds) => {
      session.close();
      if (error) return reject(error);
      if (!varbinds || varbinds.length === 0 || lib.isVarbindError(varbinds[0])) {
        return reject(new Error('No such OID'));
      }
      resolve(varbinds[0].value);
    });
  });
}

async function checkInterfaceStatus(host, community, ifIndex, options = {}) {
  const oid = `1.3.6.1.2.1.2.2.1.8.${ifIndex}`; // IF-MIB::ifOperStatus
  const status = await getSnmpValue(host, community, oid);
  if (status !== 1) {
    await sendSlackMessage(`Interface ${ifIndex} on ${host} status ${status}`, options.webhook);
  }
  return status;
}

module.exports = { getSnmpValue, checkInterfaceStatus };
