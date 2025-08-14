"use client";

import { Button } from "@/components/ui/button";
import { useLanguage } from "@/hooks/use-language";

export function LanguageSwitcher() {
  const { lang, setLang, t } = useLanguage();
  const toggle = () => setLang(lang === "fr" ? "en" : "fr");
  return (
    <Button variant="ghost" size="icon" className="rounded-full" onClick={toggle}>
      {lang === "fr" ? "EN" : "FR"}
      <span className="sr-only">{t("switchLanguage")}</span>
    </Button>
  );
}
