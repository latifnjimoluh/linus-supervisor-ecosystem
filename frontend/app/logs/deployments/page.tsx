"use client"

import * as React from "react";
import { Search, ArrowUpDown, Loader2 } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { useErrors } from "@/hooks/use-errors";
import { ErrorBanner } from "@/components/error-banner";
import { listDeploymentLogs, DeploymentLog } from "@/services/logs";

export default function DeploymentLogsPage() {
  const [logs, setLogs] = React.useState<DeploymentLog[]>([]);
  const [loading, setLoading] = React.useState(true);
  const [search, setSearch] = React.useState("");
  const [sort, setSort] = React.useState("date");
  const [order, setOrder] = React.useState<"asc" | "desc">("desc");
  const [page, setPage] = React.useState(1);
  const [limit, setLimit] = React.useState(25);
  const [total, setTotal] = React.useState(0);
  const { setError, clearError } = useErrors();

  const fetchLogs = React.useCallback(async () => {
    try {
      setLoading(true);
      const res = await listDeploymentLogs({
        search: search || undefined,
        sort,
        order,
        page,
        limit,
      });
      setLogs(res.items);
      setTotal(res.total_after_filter);
      clearError("deployment-logs");
    } catch (err) {
      setError("deployment-logs", {
        message: "Impossible de charger les logs de déploiement",
        detailsUrl: "/logs/deployments",
      });
    } finally {
      setLoading(false);
    }
  }, [search, sort, order, page, limit]);

  React.useEffect(() => {
    fetchLogs();
  }, [fetchLogs]);

  const totalPages = Math.max(1, Math.ceil(total / limit));

  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearch(e.target.value);
    setPage(1);
  };
  const handleSortChange = (value: string) => {
    setSort(value);
    setPage(1);
  };
  const handleOrderToggle = () => {
    setOrder(order === "asc" ? "desc" : "asc");
    setPage(1);
  };
  const handleLimitChange = (value: string) => {
    setLimit(Number(value));
    setPage(1);
  };

  const statusVariant = (status: string) => {
    switch (status) {
      case "success":
        return "success";
      case "failed":
      case "error":
        return "destructive";
      case "pending":
        return "secondary";
      default:
        return "secondary";
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-4xl font-semibold">Logs de déploiement</h1>
        <div className="flex gap-2">
          <div className="relative">
            <Search className="absolute left-2 top-2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Rechercher..."
              value={search}
              onChange={handleSearchChange}
              className="pl-8 w-[250px]"
            />
          </div>
          <Select value={sort} onValueChange={handleSortChange}>
            <SelectTrigger className="w-[150px]">
              <SelectValue placeholder="Tri" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="date">Date</SelectItem>
              <SelectItem value="instance_id">Instance</SelectItem>
              <SelectItem value="status">Statut</SelectItem>
            </SelectContent>
          </Select>
          <Button variant="outline" size="icon" onClick={handleOrderToggle}>
            <ArrowUpDown className="h-4 w-4" />
          </Button>
        </div>
      </div>
      <ErrorBanner scope="deployment-logs" />
      <Card>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Date</TableHead>
                <TableHead>Instance</TableHead>
                <TableHead>VM</TableHead>
                <TableHead>Statut</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {loading ? (
                <TableRow>
                  <TableCell colSpan={4} className="text-center">
                    <Loader2 className="h-4 w-4 animate-spin mx-auto" />
                  </TableCell>
                </TableRow>
              ) : logs.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={4} className="text-center text-muted-foreground">
                    Aucun log
                  </TableCell>
                </TableRow>
              ) : (
                logs.map((log) => (
                  <TableRow key={log.id}>
                    <TableCell>
                      {log.started_at ? new Date(log.started_at).toLocaleString() : "-"}
                    </TableCell>
                    <TableCell>{log.instance_id || "-"}</TableCell>
                    <TableCell>{log.vm_name || "-"}</TableCell>
                    <TableCell>
                      <Badge variant={statusVariant(log.status)}>{log.status}</Badge>
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
      <div className="flex justify-between items-center">
        <div className="flex items-center gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => setPage((p) => Math.max(1, p - 1))}
            disabled={page <= 1}
          >
            Précédent
          </Button>
          <span>
            Page {page} / {totalPages}
          </span>
          <Button
            variant="outline"
            size="sm"
            onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
            disabled={page >= totalPages}
          >
            Suivant
          </Button>
        </div>
        <div className="flex items-center gap-2">
          <span>Par page</span>
          <Select value={String(limit)} onValueChange={handleLimitChange}>
            <SelectTrigger className="w-[80px]">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="25">25</SelectItem>
              <SelectItem value="50">50</SelectItem>
              <SelectItem value="100">100</SelectItem>
            </SelectContent>
          </Select>
        </div>
      </div>
    </div>
  );
}

