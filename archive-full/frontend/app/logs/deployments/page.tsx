"use client";

import * as React from "react";
import { Search, ArrowUpDown, Loader2, Eye, Download, Clipboard } from "lucide-react";

import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { useErrors } from "@/hooks/use-errors";
import { ErrorBanner } from "@/components/error-banner";
import { listDeploymentLogs, DeploymentLog } from "@/services/logs";
import { api } from "@/services/api";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip";
import { cn } from "@/lib/utils";

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

  // --- Viewer state
  const [viewerOpen, setViewerOpen] = React.useState(false);
  const [viewerLoading, setViewerLoading] = React.useState(false);
  const [viewerError, setViewerError] = React.useState<string | null>(null);
  const [viewerText, setViewerText] = React.useState("");
  const [viewerFilename, setViewerFilename] = React.useState<string | undefined>(undefined);

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
  }, [search, sort, order, page, limit, clearError, setError]);

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

  // --- Helpers to parse filename from Content-Disposition
  const extractFilename = (contentDisposition?: string | null) => {
    if (!contentDisposition) return undefined;
    const match = /filename\*?=(?:UTF-8'')?["']?([^"';\n]+)["']?/i.exec(contentDisposition);
    if (match?.[1]) return decodeURIComponent(match[1]);
    return undefined;
  };

  // --- View (preview in dialog)
  const handleView = async (dep: DeploymentLog) => {
    setViewerOpen(true);
    setViewerLoading(true);
    setViewerError(null);
    setViewerText("");
    setViewerFilename(undefined);

    try {
      // ↳ endpoint attendu côté backend (à ajouter si besoin) :
      // GET /logs/deployments/:id/download -> renvoie le fichier du log (text/plain)
      const res = await api.get(`/logs/deployments/${dep.id}/download`, {
        responseType: "blob",
        validateStatus: () => true, // gère proprement 4xx/5xx
      });

      if (res.status >= 400) {
        throw new Error(
          `Impossible de récupérer le log (HTTP ${res.status}). Assure-toi que la route /logs/deployments/:id/download existe côté backend.`
        );
      }

      const blob = res.data as Blob;
      const text = await blob.text();
      const fname = extractFilename(res.headers["content-disposition"] as string | undefined);
      setViewerText(text || "(fichier vide)");
      setViewerFilename(fname || `deployment-log-${dep.id}.txt`);
    } catch (e: any) {
      setViewerError(e?.message || "Erreur lors du chargement du log.");
    } finally {
      setViewerLoading(false);
    }
  };

  // --- Download (save as)
  const handleDownload = async (dep: DeploymentLog) => {
    try {
      const res = await api.get(`/logs/deployments/${dep.id}/download`, {
        responseType: "blob",
        validateStatus: () => true,
      });
      if (res.status >= 400) {
        throw new Error(
          `Téléchargement impossible (HTTP ${res.status}). Vérifie la route /logs/deployments/:id/download côté backend.`
        );
      }
      const blob = res.data as Blob;
      const fname =
        extractFilename(res.headers["content-disposition"] as string | undefined) ||
        `deployment-log-${dep.id}.txt`;
      const url = URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = fname;
      document.body.appendChild(a);
      a.click();
      a.remove();
      URL.revokeObjectURL(url);
    } catch (e: any) {
      setError("deployment-logs", {
        message: e?.message || "Échec du téléchargement du log.",
      });
    }
  };

  const handleCopyContent = async () => {
    try {
      await navigator.clipboard.writeText(viewerText || "");
    } catch {
      // ignore
    }
  };

  return (
    <TooltipProvider delayDuration={100}>
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
            <Button variant="outline" size="icon" onClick={handleOrderToggle} title="Inverser l'ordre">
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
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {loading ? (
                  <TableRow>
                    <TableCell colSpan={5} className="text-center">
                      <Loader2 className="h-4 w-4 animate-spin mx-auto" />
                    </TableCell>
                  </TableRow>
                ) : logs.length === 0 ? (
                  <TableRow>
                    <TableCell colSpan={5} className="text-center text-muted-foreground">
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
                      <TableCell>
                        <div className="flex items-center justify-end gap-2">
                          <Tooltip>
                            <TooltipTrigger asChild>
                              <Button
                                variant="outline"
                                size="sm"
                                onClick={() => handleView(log)}
                              >
                                <Eye className="h-4 w-4 mr-1" />
                                Voir
                              </Button>
                            </TooltipTrigger>
                            <TooltipContent>Prévisualiser le fichier de log</TooltipContent>
                          </Tooltip>

                          <Tooltip>
                            <TooltipTrigger asChild>
                              <Button
                                variant="ghost"
                                size="sm"
                                onClick={() => handleDownload(log)}
                              >
                                <Download className="h-4 w-4" />
                              </Button>
                            </TooltipTrigger>
                            <TooltipContent>Télécharger</TooltipContent>
                          </Tooltip>
                        </div>
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

        {/* Viewer Dialog */}
        <Dialog open={viewerOpen} onOpenChange={setViewerOpen}>
          <DialogContent className="max-w-4xl">
            <DialogHeader>
              <DialogTitle className="flex items-center justify-between gap-2">
                <span className="truncate">{viewerFilename ?? "Log de déploiement"}</span>
                <div className="flex items-center gap-2">
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={handleCopyContent}
                    disabled={viewerLoading || !!viewerError || !viewerText}
                    className="whitespace-nowrap"
                  >
                    <Clipboard className="h-4 w-4 mr-1" />
                    Copier
                  </Button>
                </div>
              </DialogTitle>
            </DialogHeader>

            <div
              className={cn(
                "rounded-md border bg-muted/40 p-3 h-[60vh] overflow-auto text-sm",
                "font-mono whitespace-pre-wrap"
              )}
            >
              {viewerLoading ? (
                <div className="w-full h-full flex items-center justify-center">
                  <Loader2 className="h-5 w-5 animate-spin" />
                </div>
              ) : viewerError ? (
                <div className="text-destructive">{viewerError}</div>
              ) : (
                <pre className="whitespace-pre-wrap break-words">{viewerText}</pre>
              )}
            </div>
          </DialogContent>
        </Dialog>
      </div>
    </TooltipProvider>
  );
}
