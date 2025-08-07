"use client"

import { useState, useEffect } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Brain, TrendingUp, AlertTriangle, CheckCircle, Lightbulb, RefreshCw, Copy, Download, Minimize2, Maximize2, Loader2 } from 'lucide-react'
import { useToast } from "@/hooks/use-toast"

interface AIContextualBlockProps {
  context: string
  title: string
  description: string
  hasAnomalies?: boolean
  stats?: any
  element?: string // For script analysis, log content, etc.
}

interface AIInsight {
  type: "warning" | "success" | "suggestion" | "analysis"
  icon: any
  title: string
  message: string
  action: string
}

export function EnhancedAIContextualBlock({ 
  context, 
  title, 
  description, 
  hasAnomalies = false,
  stats,
  element 
}: AIContextualBlockProps) {
  const [insights, setInsights] = useState<AIInsight[]>([])
  const [isAnalyzing, setIsAnalyzing] = useState(false)
  const [aiResponse, setAiResponse] = useState("")
  const [isExpanded, setIsExpanded] = useState(false)
  const [isCollapsed, setIsCollapsed] = useState(false)
  const { toast } = useToast()

  // Generate contextual insights based on props
  useEffect(() => {
    generateInsights()
  }, [hasAnomalies, stats, element])

  const generateInsights = () => {
    const newInsights: AIInsight[] = []

    if (context === "dashboard" && stats) {
      if (stats.criticalAlerts > 0) {
        newInsights.push({
          type: "warning",
          icon: AlertTriangle,
          title: "Alertes critiques détectées",
          message: `${stats.criticalAlerts} alertes nécessitent une attention immédiate`,
          action: "Analyser"
        })
      }

      if (stats.avgCPU > 80) {
        newInsights.push({
          type: "warning",
          icon: TrendingUp,
          title: "Charge CPU élevée",
          message: `CPU moyen à ${stats.avgCPU}%, optimisation recommandée`,
          action: "Optimiser"
        })
      }

      if (stats.activeServices === stats.totalVMs) {
        newInsights.push({
          type: "success",
          icon: CheckCircle,
          title: "Infrastructure stable",
          message: "Tous les services fonctionnent normalement",
          action: "Détails"
        })
      }

      newInsights.push({
        type: "suggestion",
        icon: Lightbulb,
        title: "Suggestion d'optimisation",
        message: "Analyse des patterns d'usage pour réduire les coûts",
        action: "Voir"
      })
    }

    setInsights(newInsights)
  }

  const handleAnalyze = async (type?: string) => {
    setIsAnalyzing(true)
    setAiResponse("")

    try {
      // Simulate AI analysis
      await new Promise(resolve => setTimeout(resolve, 2000))
      
      let response = ""
      
      if (context === "dashboard") {
        response = `## Analyse de l'infrastructure

**État général :** ${hasAnomalies ? "⚠️ Attention requise" : "✅ Stable"}

**Points clés :**
- ${stats?.totalVMs} VMs actives avec ${stats?.activeServices} services
- CPU moyen à ${stats?.avgCPU}% ${stats?.avgCPU > 80 ? "(élevé)" : "(normal)"}
- ${stats?.criticalAlerts} alertes critiques en cours

**Recommandations :**
${stats?.avgCPU > 80 ? "- Considérer l'ajout de ressources CPU\n" : ""}${stats?.criticalAlerts > 0 ? "- Traiter les alertes critiques en priorité\n" : ""}- Planifier une maintenance préventive
- Optimiser les ressources sous-utilisées` }
      else if (context === "script") {
        response = `## Analyse du script

**Résumé :** Script d'initialisation détecté
**Complexité :** Moyenne
**Sécurité :** ✅ Aucun problème détecté

**Suggestions d'amélioration :**
- Ajouter une gestion d'erreur plus robuste
- Optimiser les boucles pour de meilleures performances
- Considérer l'ajout de logs détaillés`
      }

      setAiResponse(response)
      setIsExpanded(true)
      
    } catch (error) {
      toast({
        variant: "destructive",
        title: "Erreur IA",
        description: "Service IA momentanément indisponible"
      })
    } finally {
      setIsAnalyzing(false)
    }
  }

  const copyResponse = () => {
    navigator.clipboard.writeText(aiResponse)
    toast({
      variant: "success",
      title: "Copié",
      description: "Réponse copiée dans le presse-papiers"
    })
  }

  const exportResponse = () => {
    const blob = new Blob([aiResponse], { type: 'text/plain' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `ai-analysis-${context}-${Date.now()}.txt`
    a.click()
    URL.revokeObjectURL(url)
    
    toast({
      variant: "success",
      title: "Exporté",
      description: "Analyse exportée en fichier texte"
    })
  }

  if (isCollapsed) {
    return (
      <Button
        variant="outline"
        size="sm"
        onClick={() => setIsCollapsed(false)}
        className="fixed bottom-20 right-20 z-40"
      >
        <Brain className="h-4 w-4 mr-2" />
        Assistant IA
      </Button>
    )
  }

  return (
    <Card className="rounded-2xl shadow-md border-border/50">
      <CardHeader>
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Brain className="h-5 w-5 text-primary pulse-glow" />
            <CardTitle className="text-lg font-semibold">{title}</CardTitle>
          </div>
          <Button
            variant="ghost"
            size="sm"
            onClick={() => setIsCollapsed(true)}
          >
            <Minimize2 className="h-4 w-4" />
          </Button>
        </div>
        <CardDescription>{description}</CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        {/* Insights */}
        {insights.map((insight, index) => (
          <div key={index} className="flex items-start gap-3 p-3 rounded-xl bg-accent/20 border border-border/30">
            <insight.icon className={`h-4 w-4 mt-0.5 ${
              insight.type === "warning" ? "text-warning" :
              insight.type === "success" ? "text-success" :
              "text-primary"
            }`} />
            <div className="flex-1 space-y-1">
              <p className="text-sm font-medium">{insight.title}</p>
              <p className="text-xs text-muted-foreground">{insight.message}</p>
            </div>
            <Button 
              variant="ghost" 
              size="sm" 
              className="text-xs"
              onClick={() => handleAnalyze(insight.type)}
            >
              {insight.action}
            </Button>
          </div>
        ))}
        
        {/* AI Analysis Button */}
        <Button 
          onClick={() => handleAnalyze()}
          disabled={isAnalyzing}
          className="w-full"
          variant="outline"
        >
          {isAnalyzing ? (
            <>
              <Loader2 className="h-4 w-4 mr-2 animate-spin" />
              Analyse en cours...
            </>
          ) : (
            <>
              <Brain className="h-4 w-4 mr-2" />
              Analyser {context === "dashboard" ? "l'infrastructure" : "l'élément"}
            </>
          )}
        </Button>

        {/* AI Response */}
        {aiResponse && (
          <div className="space-y-3 border-t border-border/30 pt-4">
            <div className="flex items-center justify-between">
              <h4 className="text-sm font-medium flex items-center gap-2">
                <Brain className="h-4 w-4 text-primary" />
                Analyse IA
              </h4>
              <div className="flex gap-1">
                <Button variant="ghost" size="sm" onClick={copyResponse}>
                  <Copy className="h-3 w-3" />
                </Button>
                <Button variant="ghost" size="sm" onClick={exportResponse}>
                  <Download className="h-3 w-3" />
                </Button>
                <Button variant="ghost" size="sm" onClick={() => handleAnalyze()}>
                  <RefreshCw className="h-3 w-3" />
                </Button>
                <Button 
                  variant="ghost" 
                  size="sm" 
                  onClick={() => setIsExpanded(!isExpanded)}
                >
                  {isExpanded ? <Minimize2 className="h-3 w-3" /> : <Maximize2 className="h-3 w-3" />}
                </Button>
              </div>
            </div>
            
            <div className={`bg-muted/30 rounded-lg p-3 ${isExpanded ? 'max-h-96 overflow-y-auto' : 'max-h-32 overflow-hidden'}`}>
              <pre className="text-xs whitespace-pre-wrap text-muted-foreground">
                {aiResponse}
              </pre>
            </div>
          </div>
        )}
      </CardContent>
    </Card>
  )
}
