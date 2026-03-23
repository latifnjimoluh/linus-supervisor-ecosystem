// src/hooks/use-errors.tsx
"use client";

import * as React from "react";
import { usePathname } from "next/navigation";

export interface PanelError {
  message: string;
  detailsUrl?: string;
  /** durée de vie en ms ; si omis => pas d'auto-dismiss */
  ttlMs?: number;
}

interface ErrorContextType {
  errors: Record<string, PanelError | undefined>;
  setError: (id: string, error: PanelError) => void;
  clearError: (id: string) => void;
  clearAll: () => void;
}

const ErrorContext = React.createContext<ErrorContextType | undefined>(undefined);

export function ErrorProvider({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const [errors, setErrors] = React.useState<Record<string, PanelError | undefined>>({});
  // on garde les timers pour gérer le TTL par erreur
  const timersRef = React.useRef<Record<string, number>>({});

  const clearTimer = (id: string) => {
    const t = timersRef.current[id];
    if (t) {
      clearTimeout(t);
      delete timersRef.current[id];
    }
  };

  const setError = React.useCallback((id: string, error: PanelError) => {
    // (re)pose l'erreur
    setErrors((prev) => ({ ...prev, [id]: error }));
    // gère l'auto-dismiss si ttlMs est fourni
    clearTimer(id);
    if (error.ttlMs && error.ttlMs > 0) {
      timersRef.current[id] = window.setTimeout(() => {
        setErrors((prev) => {
          const next = { ...prev };
          delete next[id];
          return next;
        });
        delete timersRef.current[id];
      }, error.ttlMs);
    }
  }, []);

  const clearError = React.useCallback((id: string) => {
    clearTimer(id);
    setErrors((prev) => {
      const next = { ...prev };
      delete next[id];
      return next;
    });
  }, []);

  const clearAll = React.useCallback(() => {
    // nettoie tous les timers + l'état
    Object.keys(timersRef.current).forEach((id) => clearTimer(id));
    setErrors({});
  }, []);

  // 🔹 IMPORTANT : nettoyage à chaque navigation (empêche l'erreur de "voyager")
  React.useEffect(() => {
    clearAll();
  }, [pathname, clearAll]);

  const value = React.useMemo(
    () => ({ errors, setError, clearError, clearAll }),
    [errors, setError, clearError, clearAll]
  );

  return <ErrorContext.Provider value={value}>{children}</ErrorContext.Provider>;
}

export function useErrors() {
  const ctx = React.useContext(ErrorContext);
  if (!ctx) throw new Error("useErrors must be used within ErrorProvider");
  return ctx;
}
