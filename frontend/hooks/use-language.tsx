// hooks/use-language.tsx
"use client";

import * as React from "react";

export type Locale = "en" | "fr";

type Dict = Record<string, string>;
type Dictionaries = Record<Locale, Dict>;

const dictionaries: Dictionaries = {
  en: {
    dashboard: "Dashboard",
    overview: "Overview",
    infraMap: "Infra Map",
    stats: "Statistics",
    supervision: "Monitoring",
    monitoring: "Monitoring",
    logs: "Logs",
    alerts: "Alerts",
    deployment: "Deployment",
    deploy: "Deploy",
    vmHistory: "VM History",
    scriptsTemplates: "Scripts & Templates",
    list: "List",
    scripts: "Scripts",
    templates: "Templates",
    users: "Users",
    usersList: "Users",
    roles: "Roles",
    permissions: "Permissions",
    terminal: "Terminal",
    codeEditor: "Code editor",
    settings: "Settings",
    accountSettings: "Account Settings",
    proxmoxConnection: "Proxmox Connection",
    provisioningTemplates: "Provisioning Templates",
    storage: "Storage",
    alertThresholds: "Alert thresholds",
    about: "About",
  },
  fr: {
    dashboard: "Tableau de bord",
    overview: "Aperçu",
    infraMap: "Carte Infra",
    stats: "Statistiques",
    supervision: "Supervision",
    monitoring: "Monitoring",
    logs: "Logs",
    alerts: "Alertes",
    deployment: "Déploiement",
    deploy: "Déployer",
    vmHistory: "Historique VMs",
    scriptsTemplates: "Scripts & Modèles",
    list: "Liste",
    scripts: "Scripts",
    templates: "Modèles",
    users: "Utilisateurs",
    usersList: "Utilisateurs",
    roles: "Rôles",
    permissions: "Permissions",
    terminal: "Terminal",
    codeEditor: "Éditeur de code",
    settings: "Paramètres",
    accountSettings: "Paramètres du compte",
    proxmoxConnection: "Connexion Proxmox",
    provisioningTemplates: "Modèles de provisioning",
    storage: "Stockage",
    alertThresholds: "Seuils d’alerte",
    about: "À propos",
  },
};

type LanguageContextType = {
  locale: Locale;
  setLocale: (l: Locale) => void;
  t: (key: string) => string;
};

const LanguageContext = React.createContext<LanguageContextType | null>(null);

export const LanguageProvider = ({ children }: { children: React.ReactNode }) => {
  const [locale, setLocale] = React.useState<Locale>("fr");

  // Charger/sauver la langue depuis localStorage côté client
  React.useEffect(() => {
    try {
      const saved = window.localStorage.getItem("app:locale") as Locale | null;
      if (saved === "en" || saved === "fr") setLocale(saved);
    } catch {}
  }, []);

  const safeSetLocale = React.useCallback((l: Locale) => {
    setLocale(l);
    try {
      window.localStorage.setItem("app:locale", l);
    } catch {}
  }, []);

  const t = React.useCallback(
    (key: string) => dictionaries[locale]?.[key] ?? key,
    [locale]
  );

  const value = React.useMemo(
    () => ({ locale, setLocale: safeSetLocale, t }),
    [locale, safeSetLocale, t]
  );

  
  return (
    <LanguageContext.Provider value={{ locale, setLocale, t }}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const ctx = React.useContext(LanguageContext);
  if (!ctx) {
    throw new Error("useLanguage must be used within <LanguageProvider>");
  }
  return ctx;
}



export default LanguageProvider;
