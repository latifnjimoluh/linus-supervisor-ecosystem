/**
 * Mock Data for LinuSupervisor Demo Mode
 * Provides realistic responses for all API endpoints.
 */

export const MOCK_DATA = {
  // --- AUTH ---
  "/auth/login": {
    token: "mock-jwt-token",
    user: {
      id: 1,
      first_name: "Anas Farid",
      last_name: "NJIMOLUH",
      email: "latifnjimoluh@gmail.com",
      role: "Administrateur"
    }
  },
  "/auth/me": {
    id: 1,
    first_name: "Anas Farid",
    last_name: "NJIMOLUH",
    email: "latifnjimoluh@gmail.com",
    role: "Administrateur",
    status: "actif",
    avatar: "https://github.com/latifnjimoluh.png"
  },

  // --- DASHBOARD ---
  "/dashboard": {
    totalVms: 12,
    activeServices: 48,
    alerts: { critical: 1, major: 3, minor: 7 },
    systemHealth: 94,
    networkTraffic: { incoming: 1240, outgoing: 850 },
    recentActivity: [
      { id: "1", type: "deployment", message: "Déploiement réussi sur Web-Server-01", timestamp: new Date().toISOString() },
      { id: "2", type: "alert", message: "CPU élevé détecté sur DB-Master", timestamp: new Date(Date.now() - 3600000).toISOString() },
      { id: "3", type: "system", message: "Nouveau backup généré pour l'infrastructure", timestamp: new Date(Date.now() - 7200000).toISOString() }
    ],
    lastUpdated: new Date().toISOString(),
    apiError: false,
    deploymentStats: { total: 156, success: 148, failed: 5, deleted: 3 }
  },

  "/dashboard/stats": {
    totals: { deployed: 156, success: 148, failed: 5, deleted: 3 },
    timeline: [
      { period: "Lundi", deployed: 12, deleted: 1, success: 11, failed: 1 },
      { period: "Mardi", deployed: 15, deleted: 0, success: 15, failed: 0 },
      { period: "Mercredi", deployed: 8, deleted: 2, success: 7, failed: 1 },
      { period: "Jeudi", deployed: 20, deleted: 0, success: 19, failed: 1 },
      { period: "Vendredi", deployed: 25, deleted: 0, success: 25, failed: 0 }
    ],
    successRate7d: 96.5,
    successRate30d: 94.8,
    medianDeploymentTimeSec: 125,
    topFailureCauses: [
      { cause: "Timeout Réseau", count: 3 },
      { cause: "Erreur Authentification SSH", count: 2 }
    ],
    storageCapacity: [
      { datastore: "Local-SSD", total_bytes: 1000000000000, used_bytes: 450000000000 },
      { datastore: "NAS-Storage", total_bytes: 5000000000000, used_bytes: 1200000000000 }
    ],
    deploymentsByZone: { "Europe-West": 45, "US-East": 32, "Africa-South": 12 },
    avgDestroyTimeSec: 45
  },

  "/dashboard/map": {
    status: "ok",
    servers: [
      { id: "vm-101", name: "Web-Server-PROD", ip: "192.168.1.10", zone: "Zone-A", role: "Web", status: "ok", uptime: "15d 4h", position: { x: 100, y: 150 }, isTemplate: false },
      { id: "vm-102", name: "DB-Master", ip: "192.168.1.20", zone: "Zone-A", role: "Database", status: "alert", uptime: "42d 12h", position: { x: 300, y: 150 }, isTemplate: false },
      { id: "vm-103", name: "Load-Balancer", ip: "192.168.1.5", zone: "Zone-B", role: "Network", status: "ok", uptime: "5d 22h", position: { x: 200, y: 50 }, isTemplate: false }
    ]
  },

  // --- MONITORING ---
  "/monitoring": {
    summary: { total: 12, running: 10, stopped: 1, error: 1 },
    vms: [
      { id: "vm-101", name: "Web-Server-PROD", ip: "192.168.1.10", status: 'running', hostname: "web-prod-01", cpu_usage: 12.5, memory_usage: 2048, memory_total: 8192, disk_usage: 45, uptime: "15d", services_count: 5, active_services: 5, last_monitoring: new Date().toISOString() },
      { id: "vm-102", name: "DB-Master", ip: "192.168.1.20", status: 'running', hostname: "db-master", cpu_usage: 88.2, memory_usage: 6144, memory_total: 8192, disk_usage: 72, uptime: "42d", services_count: 3, active_services: 2, last_monitoring: new Date().toISOString(), alerts: [{ type: 'CPU', value_percent: 88.2, threshold: 80, state: 'CRITICAL', freshness: 'fresh' }] },
      { id: "vm-103", name: "Staging-App", ip: "192.168.1.30", status: 'stopped', hostname: "stage-app", cpu_usage: 0, memory_usage: 0, memory_total: 4096, disk_usage: 15, uptime: "0s", services_count: 4, active_services: 0, last_monitoring: new Date().toISOString() }
    ],
    templates: [
      { id: "tpl-ubuntu", name: "Ubuntu 22.04 Base", ip: "N/A", status: 'stopped', hostname: "template", cpu_usage: 0, memory_usage: 0, memory_total: 2048, disk_usage: 10, uptime: "0s", services_count: 0, active_services: 0, last_monitoring: null }
    ]
  },

  // --- ALERTS ---
  "/alerts": {
    data: [
      { id: 1, server: "DB-Master", service: "PostgreSQL", severity: "critical", status: "en_cours", description: "Utilisation CPU élevée (88%) détectée", created_at: new Date().toISOString() },
      { id: 2, server: "Web-Server-PROD", service: "Nginx", severity: "warning", status: "en_cours", description: "Temps de réponse anormalement long (> 500ms)", created_at: new Date(Date.now() - 1800000).toISOString() }
    ],
    pagination: { page: 1, pages: 1, total: 2, limit: 10 }
  },

  // --- USERS ---
  "/users": {
    data: [
      { id: 1, first_name: "Anas Farid", last_name: "NJIMOLUH", email: "latifnjimoluh@gmail.com", role_id: 1, status: "actif", created_at: "2026-01-01T10:00:00Z", avatar: "https://github.com/latifnjimoluh.png" },
      { id: 2, first_name: "Admin", last_name: "Demo", email: "admin@demo.local", role_id: 2, status: "actif", created_at: "2026-02-15T14:30:00Z" }
    ]
  },

  // --- LOGS ---
  "/logs": {
    data: [
      { id: 1, user: "Anas Farid", action: "DEPLOY", target: "VM-101", details: "Déploiement de l'agent de monitoring", timestamp: new Date().toISOString() },
      { id: 2, user: "System", action: "ALERT", target: "VM-102", details: "Alerte critique CPU générée", timestamp: new Date(Date.now() - 3600000).toISOString() }
    ],
    pagination: { page: 1, pages: 1, total: 2, limit: 20 }
  },

  // --- ROLES & PERMISSIONS ---
  "/roles": [
    { id: 1, name: "Administrateur", description: "Accès total au système" },
    { id: 2, name: "Opérateur", description: "Consultation et maintenance de base" }
  ],

  "/permissions": [
    { id: 1, name: "MANAGE_USERS", description: "Gérer les utilisateurs" },
    { id: 2, name: "MANAGE_VMS", description: "Gérer les machines virtuelles" },
    { id: 3, name: "VIEW_MONITORING", description: "Voir le monitoring" }
  ]
};

/**
 * Interceptor logic for mock responses
 */
export const getMockResponse = (url: string, method: string) => {
  // Normalize URL to match keys
  const cleanUrl = url.split('?')[0]; 
  
  // Find exact match or pattern match
  const responseData = MOCK_DATA[cleanUrl as keyof typeof MOCK_DATA];

  if (responseData) {
    console.log(`[Mock API] Returning data for ${method} ${cleanUrl}`);
    return { data: responseData, status: 200, statusText: "OK", headers: {}, config: {} };
  }

  // Handle Dynamic IDs (e.g., /monitoring/vm-101)
  if (cleanUrl.startsWith('/monitoring/')) {
    const id = cleanUrl.split('/')[2];
    if (cleanUrl.endsWith('/history')) {
        return { data: [
            { id: 1, vm_ip: "192.168.1.10", retrieved_at: new Date().toISOString(), system_status: { cpu: 12, ram: 20 } },
            { id: 2, vm_ip: "192.168.1.10", retrieved_at: new Date(Date.now() - 60000).toISOString(), system_status: { cpu: 15, ram: 22 } }
        ], status: 200 };
    }
    const vm = MOCK_DATA["/monitoring"].vms.find(v => v.id === id) || MOCK_DATA["/monitoring"].vms[0];
    return { data: { ...vm, disk_total: 100, network_in: 120, network_out: 80, load_average: 0.5 }, status: 200 };
  }

  if (cleanUrl.startsWith('/alerts/')) {
    return { data: MOCK_DATA["/alerts"].data[0], status: 200 };
  }

  if (cleanUrl.startsWith('/users/')) {
    return { data: MOCK_DATA["/users"].data[0], status: 200 };
  }

  console.warn(`[Mock API] No mock data found for ${method} ${cleanUrl}`);
  return null;
};
