import { BackButton } from "@/components/back-button";

export const revalidate = 3600;

export default function GuidePage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center gap-4">
        <BackButton href="/dashboard" />
        <h1 className="text-3xl font-bold">Mode d'emploi</h1>
      </div>
      <p className="text-muted-foreground">
        Cette section n'est pas encore disponible.
      </p>
    </div>
  );
}
