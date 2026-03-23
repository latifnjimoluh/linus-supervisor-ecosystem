import Link from "next/link";

export default function UnauthorizedPage() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center gap-4 p-4 text-center">
      <h1 className="text-2xl font-bold">401 - Non autorisé</h1>
      <p>Vous devez être connecté pour accéder à cette page.</p>
      <Link href="/login" className="text-primary underline">
        Retour à la connexion
      </Link>
    </div>
  );
}
