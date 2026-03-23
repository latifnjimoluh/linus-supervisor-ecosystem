import { Badge } from "@/components/ui/badge"

export const getStatusBadge = (status: string) => {
  switch (status) {
    case "pending":
    case "running":
      return (
        <Badge variant="secondary" className="bg-yellow-500/20 text-yellow-600 animate-pulse">
          En cours…
        </Badge>
      )
    case "success":
      return <Badge variant="success">Terminé</Badge>
    case "failed":
      return <Badge variant="destructive">Échec</Badge>
    case "canceled":
      return <Badge variant="secondary">Annulé</Badge>
    default:
      return <Badge variant="secondary">Inconnu</Badge>
  }
}
