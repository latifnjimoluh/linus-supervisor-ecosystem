"use client"

import * as React from "react"
import { Terminal as TerminalIcon, Server, Power, Wifi, Download, Settings } from 'lucide-react'
import { motion } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Badge } from "@/components/ui/badge"
import { ScrollArea } from "@/components/ui/scroll-area"
import { Input } from "@/components/ui/input"
import { useToast } from "@/hooks/use-toast"
import { cn } from "@/lib/utils"
import { fetchTerminalVMs, TerminalVM, testSshConnection, execSshCommand } from "@/services/vms"

interface TerminalSession {
  id: string
  vmId: string
  vmName: string
  vmIp: string
  sshUser: string
  connected: boolean
  lastActivity: Date
}

interface TerminalLine {
  id: string
  type: "command" | "output" | "error" | "system"
  content: string
  timestamp: Date
}

export default function TerminalPage() {
  const [selectedVM, setSelectedVM] = React.useState<string>("")
  const [vms, setVms] = React.useState<TerminalVM[]>([])
  const [search, setSearch] = React.useState("")
  const [debounced, setDebounced] = React.useState("")
  const [sshUser, setSshUser] = React.useState("")
  const [session, setSession] = React.useState<TerminalSession | null>(null)
  const [terminalLines, setTerminalLines] = React.useState<TerminalLine[]>([])
  const [currentCommand, setCurrentCommand] = React.useState("")
  const [commandHistory, setCommandHistory] = React.useState<string[]>([])
  const [historyIndex, setHistoryIndex] = React.useState(-1)
  const [isExecuting, setIsExecuting] = React.useState(false)
  const [isConnecting, setIsConnecting] = React.useState(false)
  const { toast } = useToast()
  const terminalRef = React.useRef<HTMLDivElement>(null)
  const inputRef = React.useRef<HTMLInputElement>(null)

  React.useEffect(() => {
    fetchTerminalVMs()
      .then(setVms)
      .catch((e) =>
        toast({
          title: "Erreur",
          description: "Impossible de récupérer les VMs",
          variant: "destructive",
        })
      )
  }, [toast])

  React.useEffect(() => {
    const t = setTimeout(() => setDebounced(search), 300)
    return () => clearTimeout(t)
  }, [search])

  const filteredVms = React.useMemo(() => {
    const term = debounced.toLowerCase().trim()
    if (!term) return vms
    return vms.filter(vm => {
      const haystack = `${vm.name} ${vm.ip ?? ""} ${(vm.tags ?? []).join(" ")}`.toLowerCase()
      return haystack.includes(term)
    })
  }, [vms, debounced])

  // Auto-scroll to bottom
  React.useEffect(() => {
    if (terminalRef.current) {
      terminalRef.current.scrollTop = terminalRef.current.scrollHeight
    }
  }, [terminalLines])

  // Focus input when session is active
  React.useEffect(() => {
    if (session?.connected && inputRef.current) {
      inputRef.current.focus()
    }
  }, [session?.connected])

  const connectToVM = async (vmId: string) => {
    const vm = vms.find(v => v.id === vmId)
    if (!vm) return

    if (vm.status !== "running" || !vm.ip) {
      toast({
        title: "VM non disponible",
        description: `La VM ${vm.name} n'est pas disponible`,
        variant: "destructive",
      })
      return
    }

    if (!sshUser.trim()) {
      toast({
        title: "Utilisateur SSH requis",
        description: "Veuillez saisir l'utilisateur SSH.",
        variant: "destructive",
      })
      return
    }

    try {
      setIsConnecting(true)

      // 🔐 Test de connexion réel via le backend
      const test = await testSshConnection({
        vm_id: vm.id,
        ip: vm.ip,
        ssh_user: sshUser.trim(),
      })

      if (!test.ok) {
        toast({
          title: "Connexion refusée",
          description: test.message || "Impossible d'établir la connexion SSH.",
          variant: "destructive",
        })
        setIsConnecting(false)
        return
      }

      const newSession: TerminalSession = {
        id: `session-${Date.now()}`,
        vmId: vm.id,
        vmName: vm.name,
        vmIp: vm.ip,
        sshUser: sshUser.trim(),
        connected: true,
        lastActivity: new Date()
      }

      setSession(newSession)
      setTerminalLines([
        {
          id: "welcome",
          type: "system",
          content: `🔒 Session SSH établie avec ${vm.name} (${vm.ip})`,
          timestamp: new Date()
        },
        {
          id: "security-notice",
          type: "system",
          content: "⚠️  Toutes vos actions sont enregistrées pour audit de sécurité",
          timestamp: new Date()
        },
        {
          id: "prompt-1",
          type: "system",
          content: `${sshUser.trim()}@${vm.name}:~$`,
          timestamp: new Date()
        }
      ])

      toast({
        title: "Connexion établie",
        description: `Terminal connecté à ${vm.name}`,
        variant: "success",
      })
    } catch (e: any) {
      toast({
        title: "Erreur de connexion",
        description: e?.response?.data?.message || e?.message || "Echec du test SSH.",
        variant: "destructive",
      })
    } finally {
      setIsConnecting(false)
    }
  }

  const disconnectSession = () => {
    setSession(null)
    setTerminalLines([])
    setCurrentCommand("")
    setCommandHistory([])
    setHistoryIndex(-1)
    
    toast({
      title: "Session fermée",
      description: "Terminal déconnecté",
      variant: "info",
    })
  }

  const executeCommand = async () => {
    if (!currentCommand.trim() || isExecuting || !session) return

    const cmd = currentCommand
    setIsExecuting(true)

    // Historique
    const newHistory = [...commandHistory, cmd]
    setCommandHistory(newHistory)
    setHistoryIndex(-1)

    // Ligne de commande
    const promptUser = `${session.sshUser}@${session.vmName}:~$`
    const commandLine: TerminalLine = {
      id: `cmd-${Date.now()}`,
      type: "command",
      content: `${promptUser} ${cmd}`,
      timestamp: new Date()
    }
    setTerminalLines(prev => [...prev, commandLine])
    setCurrentCommand("")

    try {
      // commandes locales
      if (cmd === "clear") {
        setTerminalLines([
          {
            id: "prompt-clear",
            type: "system",
            content: `${promptUser}`,
            timestamp: new Date()
          }
        ])
        setIsExecuting(false)
        return
      }
      if (cmd === "exit") {
        disconnectSession()
        setIsExecuting(false)
        return
      }

      // 🧠 Exécution réelle via backend
      const { stdout, stderr, code } = await execSshCommand({
        vm_id: session.vmId,
        ip: session.vmIp,
        ssh_user: session.sshUser,
        command: cmd,
      })

      // Sortie stdout
      if (stdout && stdout.trim().length > 0) {
        const outputLine: TerminalLine = {
          id: `out-${Date.now()}`,
          type: "output",
          content: stdout,
          timestamp: new Date()
        }
        setTerminalLines(prev => [...prev, outputLine])
      }

      // Sortie stderr
      if (stderr && stderr.trim().length > 0) {
        const errorLine: TerminalLine = {
          id: `err-${Date.now()}`,
          type: "error",
          content: stderr,
          timestamp: new Date()
        }
        setTerminalLines(prev => [...prev, errorLine])
      }

      // Nouveau prompt
      const promptLine: TerminalLine = {
        id: `prompt-${Date.now()}`,
        type: "system",
        content: `${promptUser}`,
        timestamp: new Date()
      }
      setTerminalLines(prev => [...prev, promptLine])
      } catch (e: any) {
        const errorLine: TerminalLine = {
          id: `err-${Date.now()}`,
          type: "error",
          content: e?.response?.data?.message || e?.message || "Échec exécution commande",
          timestamp: new Date()
        }
        setTerminalLines(prev => [...prev, errorLine])
      } finally {
        setIsExecuting(false)
        inputRef.current?.focus()
      }
  }

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === "Enter") {
      executeCommand()
    } else if (e.key === "ArrowUp") {
      e.preventDefault()
      if (commandHistory.length > 0) {
        const newIndex = historyIndex === -1 ? commandHistory.length - 1 : Math.max(0, historyIndex - 1)
        setHistoryIndex(newIndex)
        setCurrentCommand(commandHistory[newIndex])
      }
    } else if (e.key === "ArrowDown") {
      e.preventDefault()
      if (historyIndex !== -1) {
        const newIndex = historyIndex + 1
        if (newIndex >= commandHistory.length) {
          setHistoryIndex(-1)
          setCurrentCommand("")
        } else {
          setHistoryIndex(newIndex)
          setCurrentCommand(commandHistory[newIndex])
        }
      }
    }
  }

  const exportSession = () => {
    const sessionData = terminalLines.map(line => 
      `[${line.timestamp.toISOString()}] ${line.type.toUpperCase()}: ${line.content}`
    ).join('\n')

    const blob = new Blob([sessionData], { type: 'text/plain' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `terminal-session-${session?.vmName}-${new Date().toISOString().split('T')[0]}.txt`
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)

    toast({
      title: "Session exportée",
      description: "L'historique du terminal a été téléchargé",
      variant: "success",
    })
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-4xl font-semibold">Terminal distant sécurisé</h1>
          <p className="text-muted-foreground mt-1">
            Accès shell sécurisé aux machines virtuelles
          </p>
        </div>
        <div className="flex gap-3">
          {session && (
            <>
              <Button onClick={exportSession} variant="outline" className="rounded-xl">
                <Download className="mr-2 h-4 w-4" />
                Exporter session
              </Button>
              <Button onClick={disconnectSession} variant="destructive" className="rounded-xl">
                <Power className="mr-2 h-4 w-4" />
                Déconnecter
              </Button>
            </>
          )}
        </div>
      </div>

      {!session ? (
        // VM Selection
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader>
            <CardTitle className="text-lg flex items-center gap-2">
              <Server className="h-5 w-5" />
              Sélection de la machine virtuelle
            </CardTitle>
            <CardDescription>
              Choisissez une VM pour établir une connexion terminal sécurisée
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <Input
              placeholder="Rechercher..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="rounded-xl"
            />

            <Select value={selectedVM} onValueChange={setSelectedVM}>
              <SelectTrigger className="rounded-xl">
                <SelectValue placeholder="Sélectionnez une VM..." />
              </SelectTrigger>
              <SelectContent>
                {filteredVms.map((vm) => (
                  <SelectItem key={vm.id} value={vm.id} disabled={vm.status !== "running" || !vm.ip}>
                    <div className="flex items-center gap-2">
                      <div className={cn(
                        "w-2 h-2 rounded-full",
                        vm.status === "running" ? "bg-green-500" : "bg-red-500"
                      )} />
                      <span>{vm.name}</span>
                      {vm.ip && <span className="text-muted-foreground">({vm.ip})</span>}
                      <Badge variant={vm.status === "running" ? "success" : "destructive"} className="text-xs">
                        {vm.status}
                      </Badge>
                    </div>
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>

            <Input
              value={sshUser}
              onChange={(e) => setSshUser(e.target.value)}
              placeholder="Utilisateur SSH"
              className="rounded-xl"
            />

            <Button
              onClick={() => connectToVM(selectedVM)}
              disabled={!selectedVM || !sshUser || isConnecting}
              className="w-full rounded-xl"
            >
              <TerminalIcon className="mr-2 h-4 w-4" />
              {isConnecting ? "Connexion..." : "Se connecter en SSH"}
            </Button>

            <div className="text-sm text-muted-foreground bg-muted/50 p-4 rounded-xl">
              <div className="flex items-center gap-2 mb-2">
                <Settings className="h-4 w-4" />
                <strong>Informations de sécurité</strong>
              </div>
              <ul className="space-y-1 text-xs">
                <li>• Connexion SSH sécurisée avec authentification par clé</li>
                <li>• Toutes les commandes sont enregistrées pour audit</li>
                <li>• Les commandes sont exécutées côté serveur via un proxy sécurisé</li>
                <li>• Session automatiquement fermée après 30 minutes d'inactivité</li>
              </ul>
            </div>
          </CardContent>
        </Card>
      ) : (
        // Terminal Interface
        <Card className="rounded-2xl shadow-md dark:shadow-inner dark:ring-1 dark:ring-slate-700/40">
          <CardHeader className="pb-2">
            <div className="flex items-center justify-between">
              <CardTitle className="text-lg flex items-center gap-2">
                <TerminalIcon className="h-5 w-5" />
                {session.vmName}
                <Badge variant="success" className="text-xs">
                  <Wifi className="h-3 w-3 mr-1" />
                  Connecté
                </Badge>
              </CardTitle>
              <div className="flex items-center gap-2 text-sm text-muted-foreground">
                <span>{session.vmIp}</span>
                <span>•</span>
                <span>Session: {session.lastActivity.toLocaleTimeString("fr-FR")}</span>
              </div>
            </div>
          </CardHeader>
          <CardContent className="p-0">
            {/* Terminal Display */}
            <div className="bg-black text-green-400 font-mono text-sm h-[500px] flex flex-col">
              <ScrollArea className="flex-1 p-4" ref={terminalRef}>
                <div className="space-y-1">
                  {terminalLines.map((line) => (
                    <div key={line.id} className="flex">
                      <div className={cn(
                        "whitespace-pre-wrap break-all",
                        line.type === "command" && "text-white",
                        line.type === "output" && "text-green-400",
                        line.type === "error" && "text-red-400",
                        line.type === "system" && "text-yellow-400"
                      )}>
                        {line.content}
                      </div>
                    </div>
                  ))}
                  {isExecuting && (
                    <div className="flex items-center gap-2 text-yellow-400">
                      <div className="flex space-x-1">
                        <div className="w-1 h-1 bg-current rounded-full animate-bounce" style={{ animationDelay: "0ms" }} />
                        <div className="w-1 h-1 bg-current rounded-full animate-bounce" style={{ animationDelay: "150ms" }} />
                        <div className="w-1 h-1 bg-current rounded-full animate-bounce" style={{ animationDelay: "300ms" }} />
                      </div>
                      <span className="text-xs">Exécution en cours...</span>
                    </div>
                  )}
                </div>
              </ScrollArea>
              
              {/* Command Input */}
              <div className="border-t border-gray-700 p-4">
                <div className="flex items-center gap-2">
                  <span className="text-yellow-400">{session.sshUser}@{session.vmName}:~$</span>
                  <input
                    ref={inputRef}
                    type="text"
                    value={currentCommand}
                    onChange={(e) => setCurrentCommand(e.target.value)}
                    onKeyDown={handleKeyDown}
                    disabled={isExecuting}
                    className="flex-1 bg-transparent text-white outline-none font-mono"
                    placeholder="Tapez votre commande..."
                    autoComplete="off"
                  />
                  <div className="w-2 h-4 bg-green-400 animate-pulse" />
                </div>
                <div className="text-xs text-gray-500 mt-2">
                  Utilisez ↑/↓ pour l'historique • 'clear' pour nettoyer • 'exit' pour quitter
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  )
}
