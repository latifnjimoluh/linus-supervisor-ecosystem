"use client";

import * as React from "react";

export type Locale = "en" | "fr";

const dictionaries: Record<Locale, Record<string, string>> = {
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
    privacyPolicy: "Privacy Policy",
    guide: "Guide",
    help: "Help",
    closeSidebar: "Close sidebar",
    expand: "Expand",
    toggleSidebar: "Toggle sidebar",
    lastDeployment: "Last deployment",
    inProgress: "In progress…",
    needHelp: "Need help?",
    notifications: "Notifications",
    myAccount: "My account",
    profile: "Profile",
    logout: "Logout",
    switchLanguage: "Switch language",
  },
  fr: {
    dashboard: "Tableau de bord",
    overview: "Vue d'ensemble",
    infraMap: "Carte Infra",
    stats: "Statistiques",
    supervision: "Supervision",
    monitoring: "Monitoring",
    logs: "Logs",
    alerts: "Alertes",
    deployment: "Déploiement",
    deploy: "Déployer",
    vmHistory: "Historique des VM",
    scriptsTemplates: "Scripts & Templates",
    list: "Liste",
    scripts: "Scripts",
    templates: "Templates",
    users: "Utilisateurs",
    usersList: "Utilisateurs",
    roles: "Rôles",
    permissions: "Permissions",
    terminal: "Terminal",
    codeEditor: "Éditeur de code",
    settings: "Paramètres",
    accountSettings: "Paramètres du Compte",
    proxmoxConnection: "Connexion Proxmox",
    provisioningTemplates: "Templates de Provisionnement",
    storage: "Stockage",
    alertThresholds: "Seuils d'alertes",
    about: "À propos",
    privacyPolicy: "Politique de confidentialité",
    guide: "Guide",
    help: "Aide",
    closeSidebar: "Fermer la barre latérale",
    expand: "Dérouler",
    toggleSidebar: "Ouvrir/fermer la barre",
    lastDeployment: "Dernier déploiement",
    inProgress: "En cours…",
    needHelp: "Besoin d'aide ?",
    notifications: "Notifications",
    myAccount: "Mon Compte",
    profile: "Profil",
    logout: "Déconnexion",
    switchLanguage: "Changer de langue",
  },
};

interface LanguageContextValue {
  lang: Locale;
  setLang: (l: Locale) => void;
  t: (key: string) => string;
}

const LanguageContext = React.createContext<LanguageContextValue | undefined>(
  undefined
);

export function LanguageProvider({
  children,
}: {
  children: React.ReactNode;
}) {
  const [lang, setLangState] = React.useState<Locale>("fr");

  React.useEffect(() => {
    const stored =
      typeof window !== "undefined" ? localStorage.getItem("lang") : null;
    if (stored === "en" || stored === "fr") {
      setLangState(stored);
    }
  }, []);

  const setLang = React.useCallback((l: Locale) => {
    setLangState(l);
    if (typeof window !== "undefined") {
      localStorage.setItem("lang", l);
      document.documentElement.lang = l;
    }
  }, []);

  React.useEffect(() => {
    if (typeof window !== "undefined") {
      document.documentElement.lang = lang;
    }
  }, [lang]);

  const t = React.useCallback(
    (key: string) => dictionaries[lang][key] || key,
    [lang]
  );

  const value = React.useMemo(() => ({ lang, setLang, t }), [lang, setLang, t]);

  return (
    <LanguageContext.Provider value={value}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const ctx = React.useContext(LanguageContext);
  if (!ctx) throw new Error("useLanguage must be used within LanguageProvider");
  return ctx;
}

export function useTranslation() {
  return useLanguage();
}

