"use client"

import * as React from "react"
import { Bot, Copy, RefreshCw, Download, ChevronDown, Loader2 } from 'lucide-react'
import { motion, AnimatePresence } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible"
import { useToast } from "@/hooks/use-toast"
import { cn } from "@/lib/utils"

// Global cache shared across all AssistantAIBlock instances
const aiResponseCache = new Map<string, string>()

interface AssistantAIBlockProps {
  title: string
  context: string // The data/text to be analyzed by AI
  onAnalyze: (context: string) => Promise<string> // Function to call AI API
  initialOpen?: boolean
  className?: string
}

export function AssistantAIBlock({ title, context, onAnalyze, initialOpen = false, className }: AssistantAIBlockProps) {
  const [isOpen, setIsOpen] = React.useState(initialOpen)
  const [isLoading, setIsLoading] = React.useState(false)
  const [aiResponse, setAiResponse] = React.useState<string | null>(null)
  const { toast } = useToast()

  const handleAnalyze = async () => {
    setIsOpen(true) // Open the collapsible when analysis starts
    const cached = aiResponseCache.get(context)
    if (cached) {
      setAiResponse(cached)
      toast({
        title: "Réponse IA en cache",
        description: "Résultat fourni sans nouvelle requête.",
        variant: "info",
      })
      return
    }
    setIsLoading(true)
    try {
      const response = await onAnalyze(context)
      aiResponseCache.set(context, response)
      setAiResponse(response)
      toast({
        title: "Analyse IA terminée",
        description: "La réponse de l'IA est prête.",
        variant: "success",
      })
    } catch (error) {
      console.error("AI analysis failed:", error)
      setAiResponse("Service IA momentanément indisponible ou erreur lors de l'analyse.")
      toast({
        title: "Erreur IA",
        description: "Impossible de contacter le service IA.",
        variant: "destructive",
      })
    } finally {
      setIsLoading(false)
    }
  }

  const handleCopy = () => {
    if (aiResponse) {
      navigator.clipboard.writeText(aiResponse)
      toast({
        title: "Copié !",
        description: "La réponse de l'IA a été copiée dans le presse-papiers.",
        variant: "info",
      })
    }
  }

  const handleExport = () => {
    if (aiResponse) {
      const blob = new Blob([aiResponse], { type: "text/plain" })
      const url = URL.createObjectURL(blob)
      const a = document.createElement("a")
      a.href = url
      a.download = "ai_analysis.txt"
      document.body.appendChild(a)
      a.click()
      document.body.removeChild(a)
      URL.revokeObjectURL(url)
      toast({
        title: "Exporté !",
        description: "La réponse de l'IA a été exportée en .txt.",
        variant: "info",
      })
    }
  }

  return (
    <Card className={cn("rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40", className)}>
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle className="text-lg font-semibold flex items-center gap-2">
          <Bot className="h-5 w-5 text-primary" /> {title}
        </CardTitle>
        <Button
          onClick={handleAnalyze}
          disabled={isLoading || !context}
          className="rounded-xl"
        >
          {isLoading ? (
            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
          ) : (
            <Bot className="mr-2 h-4 w-4" />
          )}
          {isLoading ? "Analyse en cours..." : "Analyser avec l'IA"}
        </Button>
      </CardHeader>
      <CardContent>
        <Collapsible open={isOpen} onOpenChange={setIsOpen} className="space-y-2">
          <CollapsibleTrigger asChild>
            <Button variant="ghost" className="w-full justify-between rounded-xl">
              <span>{aiResponse ? "Voir l'analyse" : "Cliquez pour voir la réponse IA"}</span>
              <ChevronDown className="h-4 w-4 transition-transform duration-200" data-state={isOpen ? "open" : "closed"} />
            </Button>
          </CollapsibleTrigger>
          <CollapsibleContent>
            <AnimatePresence>
              {aiResponse && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: "auto" }}
                  exit={{ opacity: 0, height: 0 }}
                  transition={{ duration: 0.3, ease: "easeOut" }}
                  className="mt-4 p-4 border rounded-xl bg-muted/50 dark:bg-background/50 text-sm whitespace-pre-wrap"
                >
                  {aiResponse}
                  <div className="flex justify-end gap-2 mt-4">
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
  )
}
