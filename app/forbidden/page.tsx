import Link from "next/link";

export default function ForbiddenPage() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center gap-4 p-4 text-center">
      <h1 className="text-2xl font-bold">403 - Accès interdit</h1>
      <p>Vous n'avez pas les permissions nécessaires pour accéder à cette page.</p>
      <Link href="/dashboard" className="text-primary underline">
        Retour au tableau de bord
      </Link>
    </div>
  );
}
