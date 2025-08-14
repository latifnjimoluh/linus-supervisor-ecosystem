"use client";

import * as React from "react";
import { Bot, Copy, Download, RefreshCw, ChevronDown, Loader2 } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";

import { Button } from "@/components/ui/button";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible";
import { ErrorBanner } from "@/components/error-banner";
import { useToast } from "@/hooks/use-toast";
import { useErrors } from "@/hooks/use-errors";
import { cn } from "@/lib/utils";

const aiResponseCache = new Map<string, string>();

interface AssistantAIBlockProps {
  title: string;
  context: string;
  onAnalyze: (context: string) => Promise<string>;
  initialOpen?: boolean;
  className?: string;
}

export function AssistantAIBlock({
  title,
  context,
  onAnalyze,
  initialOpen = false,
  className,
}: AssistantAIBlockProps) {
  const [isOpen, setIsOpen] = React.useState(initialOpen);
  const [isLoading, setIsLoading] = React.useState(false);
  const [aiResponse, setAiResponse] = React.useState<string | null>(null);
  const { toast } = useToast();
  const { setError, clearError } = useErrors();
  const errorId = React.useMemo(() => `assistant-ai-${context}`, [context]);

  React.useEffect(() => {
    if (aiResponse) setIsOpen(true);
  }, [aiResponse]);

  const handleAnalyze = async () => {
    setIsOpen(true);
    clearError(errorId);
    const cached = aiResponseCache.get(context);
    if (cached) {
      setAiResponse(cached);
      toast({ title: "Réponse IA en cache", variant: "success" });
      return;
    }
    setIsLoading(true);
    try {
      const response = await onAnalyze(context);
      aiResponseCache.set(context, response);
      setAiResponse(response);
      toast({ title: "Analyse IA terminée", variant: "success" });
    } catch {
      setError(errorId, { message: "Service IA momentanément indisponible." });
    } finally {
      setIsLoading(false);
    }
  };

  const handleCopy = () => {
    if (!aiResponse) return;
    navigator.clipboard.writeText(aiResponse);
    toast({ title: "Réponse copiée", variant: "success" });
  };

  const handleExport = () => {
    if (!aiResponse) return;
    const blob = new Blob([aiResponse], { type: "text/plain" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "ai_analysis.txt";
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
    toast({ title: "Analyse exportée", variant: "success" });
  };

  return (
    <Card
      className={cn(
        "rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40",
        className,
      )}
    >
      <CardHeader className="p-5 flex flex-row items-center justify-between space-y-0">
        <CardTitle className="flex items-center gap-2 text-lg font-semibold">
          <Bot className="h-5 w-5 text-primary" /> {title}
        </CardTitle>
        <Button onClick={handleAnalyze} disabled={isLoading || !context} className="rounded-xl">
          {isLoading ? (
            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
          ) : (
            <Bot className="mr-2 h-4 w-4" />
          )}
          {isLoading ? "Analyse en cours..." : "Analyser avec l'IA"}
        </Button>
      </CardHeader>
      <CardContent className="p-5">
        <ErrorBanner id={errorId} />
        <Collapsible open={isOpen} onOpenChange={setIsOpen} className="space-y-2">
          <CollapsibleTrigger asChild>
            <Button variant="ghost" className="w-full justify-between rounded-xl">
              <span>{isOpen ? "Masquer l'analyse" : "Voir l'analyse"}</span>
              <ChevronDown
                className="h-4 w-4 transition-transform duration-200"
                data-state={isOpen ? "open" : "closed"}
              />
            </Button>
          </CollapsibleTrigger>
          <CollapsibleContent>
            <AnimatePresence>
              {isLoading && !aiResponse && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: "auto" }}
                  exit={{ opacity: 0, height: 0 }}
                  transition={{ duration: 0.3, ease: "easeOut" }}
                  className="mt-4 text-sm"
                >
                  Analyse en cours...
                </motion.div>
              )}
              {aiResponse && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: "auto" }}
                  exit={{ opacity: 0, height: 0 }}
                  transition={{ duration: 0.3, ease: "easeOut" }}
                  className="mt-4 max-h-[60vh] overflow-auto whitespace-pre-wrap rounded-xl border bg-muted/50 p-4 text-sm dark:bg-background/50"
                >
                  {aiResponse}
                  <div className="mt-4 flex justify-end gap-2">
                    <Button variant="ghost" size="sm" onClick={handleCopy} className="rounded-xl">
                      <Copy className="mr-2 h-4 w-4" /> Copier
                    </Button>
                    <Button variant="ghost" size="sm" onClick={handleAnalyze} className="rounded-xl">
                      <RefreshCw className="mr-2 h-4 w-4" /> Reformuler
                    </Button>
                    <Button variant="ghost" size="sm" onClick={handleExport} className="rounded-xl">
                      <Download className="mr-2 h-4 w-4" /> Exporter
                    </Button>
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </CollapsibleContent>
        </Collapsible>
      </CardContent>
    </Card>
  );
}

export default AssistantAIBlock;
