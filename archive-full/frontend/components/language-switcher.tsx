"use client";

import { Button } from "@/components/ui/button";
import { useLanguage } from "@/hooks/use-language";

export function LanguageSwitcher() {
  const { locale, setLocale, t } = useLanguage();
  const toggle = () => setLocale(locale === "fr" ? "en" : "fr");
  return (
    <Button variant="ghost" size="icon" className="rounded-full" onClick={toggle}>
      {locale === "fr" ? "EN" : "FR"}
      <span className="sr-only">{t("switchLanguage")}</span>
    </Button>
  );
}
