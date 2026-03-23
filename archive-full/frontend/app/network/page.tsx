"use client";

import Link from "next/link";
import { Card, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { useLanguage } from "@/hooks/use-language";

export default function NetworkPage() {
  const { t } = useLanguage();
  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold">{t("network")}</h1>
      <div className="grid gap-4 sm:grid-cols-2">
        <Link href="/network/traceroute">
          <Card className="h-full transition-colors hover:bg-accent">
            <CardHeader>
              <CardTitle>{t("traceroute")}</CardTitle>
              <CardDescription>Diagnostiquer les chemins réseau</CardDescription>
            </CardHeader>
          </Card>
        </Link>
        <Link href="/network/snmp">
          <Card className="h-full transition-colors hover:bg-accent">
            <CardHeader>
              <CardTitle>{t("snmp")}</CardTitle>
              <CardDescription>Vérifier l'état d'une interface via SNMP</CardDescription>
            </CardHeader>
          </Card>
        </Link>
      </div>
    </div>
  );
}
