-- SQL schema for SupervisionStatus table
CREATE TABLE IF NOT EXISTS supervision_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    instance_id UUID,
    hostname VARCHAR(255),
    "timestamp" TIMESTAMP,
    bind9_status VARCHAR(255),
    port_53 VARCHAR(255),
    named_checkconf VARCHAR(255),
    zone_check VARCHAR(255),
    dig_test_local VARCHAR(255),
    open_ports VARCHAR(255),
    scan_duration_seconds FLOAT,
    cpu_load VARCHAR(255),
    ram_usage VARCHAR(255),
    disk_usage VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
