const preview = (req, res) => {
  const { serverId, service } = req.params;
  const format = req.query.format === 'ansible' ? 'ansible' : 'bash';

  let script;
  if (format === 'ansible') {
    script = `- hosts: ${serverId}\n  tasks:\n    - name: Configure ${service}\n      debug: msg="Configure ${service} via Ansible"`;
  } else {
    script = `#!/bin/bash\n# Configure ${service} on server ${serverId}\necho "Configuring ${service}"`;
  }

  res.json({ format, script });
};

module.exports = { preview };
