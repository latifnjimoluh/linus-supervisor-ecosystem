"use client"

import * as React from "react"
import { FileText } from "lucide-react"

import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"
import { Table, TableHeader, TableRow, TableHead, TableBody, TableCell } from "@/components/ui/table"
import { useToast } from "@/hooks/use-toast"
import { getLogs, type LogEntry } from "@/services/api"

export default function LogsPage() {
  const [logs, setLogs] = React.useState<LogEntry[]>([])
  const [loading, setLoading] = React.useState(true)
  const { toast } = useToast()

  React.useEffect(() => {
    setLoading(true)
    getLogs()
      .then((data) => setLogs(data.data || data || []))
      .catch((e: any) => toast({ title: "Erreur", description: e.message, variant: "destructive" }))
      .finally(() => setLoading(false))
  }, [toast])

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <FileText className="h-8 w-8 text-primary" />
        <h1 className="text-3xl font-bold">Logs</h1>
      </div>

      <Card className="rounded-2xl">
        <CardHeader>
          <CardTitle>Historique des actions</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Date</TableHead>
                <TableHead>Utilisateur</TableHead>
                <TableHead>Action</TableHead>
                <TableHead>Détails</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {logs.map((log) => (
                <TableRow key={log.id}>
                  <TableCell>{new Date(log.created_at).toLocaleString()}</TableCell>
                  <TableCell>{log.user?.email || "-"}</TableCell>
                  <TableCell>{log.action}</TableCell>
                  <TableCell>{log.details}</TableCell>
                </TableRow>
              ))}
              {!logs.length && !loading && (
                <TableRow>
                  <TableCell colSpan={4} className="text-center">
                    Aucun log
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  )
}
