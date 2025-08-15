#cloud-config
write_files:
  - path: /tmp/monitoring.sh
    permissions: '0755'
    content: |
      ${indent(6, monitoring_script)}
runcmd:
  - /tmp/monitoring.sh
