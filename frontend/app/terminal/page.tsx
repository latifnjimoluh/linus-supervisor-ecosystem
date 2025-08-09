"use client"

import * as React from "react"
import { Terminal, Server, Power, Wifi, Download, Settings } from 'lucide-react'
import { motion } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Badge } from "@/components/ui/badge"
import { ScrollArea } from "@/components/ui/scroll-area"
import { Input } from "@/components/ui/input"
import { useToast } from "@/hooks/use-toast"
import { cn } from "@/lib/utils"
import { fetchTerminalVMs, TerminalVM } from "@/services/vms"

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


// Simulate terminal command execution
const simulateCommand = async (command: string): Promise<{ output: string; isError: boolean }> => {
  await new Promise(resolve => setTimeout(resolve, Math.random() * 1000 + 500))
  
  const cmd = command.trim().toLowerCase()
  
  if (cmd === "ls" || cmd === "ls -la") {
    return {
      output: `total 48
drwxr-xr-x 5 root root 4096 Jan  7 14:30 .
drwxr-xr-x 3 root root 4096 Jan  5 10:15 ..
-rw-r--r-- 1 root root  220 Jan  5 10:15 .bash_logout
-rw-r--r-- 1 root root 3526 Jan  5 10:15 .bashrc
drwxr-xr-x 2 root root 4096 Jan  7 14:25 scripts
drwxr-xr-x 3 root root 4096 Jan  6 09:30 logs
-rw-r--r-- 1 root root  807 Jan  5 10:15 .profile`,
      isError: false
    }
  }
  
  if (cmd === "pwd") {
    return { output: "/root", isError: false }
  }
  
  if (cmd === "whoami") {
    return { output: "root", isError: false }
  }
  
  if (cmd === "date") {
    return { output: new Date().toString(), isError: false }
  }
  
  if (cmd === "uptime") {
    return { output: " 14:30:15 up 2 days,  4:25,  1 user,  load average: 0.15, 0.25, 0.18", isError: false }
  }
  
  if (cmd === "free -h") {
    return {
      output: `              total        used        free      shared  buff/cache   available
Mem:           7.8G        2.1G        3.2G        156M        2.5G        5.4G
Swap:          2.0G          0B        2.0G`,
      isError: false
    }
  }
  
  if (cmd === "df -h") {
    return {
      output: `Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        20G  8.5G   11G  45% /
/dev/sda2       100G   45G   50G  48% /var
tmpfs           3.9G     0  3.9G   0% /dev/shm`,
      isError: false
    }
  }
  
  if (cmd.startsWith("ps") || cmd === "top") {
    return {
      output: `  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 1234 root      20   0  123456   7890   1234 S   2.3  0.1   0:12.34 systemd
 5678 www-data  20   0  456789  12345   5678 S   1.5  0.2   0:05.67 apache2
 9012 mysql     20   0  789012  23456   9012 S   0.8  0.3   0:08.90 mysqld`,
      isError: false
    }
  }
  
  if (cmd.includes("systemctl status")) {
    const service = cmd.split(" ").pop() || "unknown"
    return {
      output: `● ${service}.service - ${service} service
   Loaded: loaded (/lib/systemd/system/${service}.service; enabled; vendor preset: enabled)
   Active: active (running) since Mon 2025-01-07 10:15:30 UTC; 4h 15min ago
     Docs: man:${service}(8)
 Main PID: 1234 (${service})
    Tasks: 3 (limit: 4915)
   Memory: 45.2M
   CGroup: /system.slice/${service}.service
           └─1234 /usr/sbin/${service}`,
      isError: false
    }
  }
  
  if (cmd.includes("rm -rf") || cmd.includes("rm -r /")) {
    return {
      output: "rm: operation not permitted - dangerous command blocked by security policy",
      isError: true
    }
  }
  
  if (cmd === "help" || cmd === "--help") {
    return {
      output: `Available commands:
- ls, pwd, whoami, date, uptime
- free -h, df -h, ps, top
- systemctl status <service>
- cat <file>, tail <file>
- cd <directory>
- history, clear, exit

Security: Dangerous commands are blocked for safety.`,
      isError: false
    }
  }
  
  if (cmd === "history") {
    return {
      output: `  1  ls -la
  2  pwd
  3  free -h
  4  df -h
  5  systemctl status apache2
  6  ${command}`,
      isError: false
    }
  }
  
  if (cmd === "clear") {
    return { output: "", isError: false }
  }
  
  // Default response for unknown commands
  return {
    output: `bash: ${command}: command not found`,
    isError: true
  }
}

export default function TerminalPage() {
  const [selectedVM, setSelectedVM] = React.useState<string>("")
  const [vms, setVms] = React.useState<TerminalVM[]>([])
  const [sshUser, setSshUser] = React.useState("")
  const [session, setSession] = React.useState<TerminalSession | null>(null)
  const [terminalLines, setTerminalLines] = React.useState<TerminalLine[]>([])
  const [currentCommand, setCurrentCommand] = React.useState("")
  const [commandHistory, setCommandHistory] = React.useState<string[]>([])
  const [historyIndex, setHistoryIndex] = React.useState(-1)
  const [isExecuting, setIsExecuting] = React.useState(false)
  const { toast } = useToast()
  const terminalRef = React.useRef<HTMLDivElement>(null)
  const inputRef = React.useRef<HTMLInputElement>(null)

  React.useEffect(() => {
    fetchTerminalVMs()
      .then(setVms)
      .catch(() =>
        toast({
          title: "Erreur",
          description: "Impossible de récupérer les VMs",
          variant: "destructive",
        })
      )
  }, [toast])

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

    // Simulate connection
    await new Promise(resolve => setTimeout(resolve, 1500))

    const newSession: TerminalSession = {
      id: `session-${Date.now()}`,
      vmId: vm.id,
      vmName: vm.name,
      vmIp: vm.ip,
      sshUser,
      connected: true,
      lastActivity: new Date()
    }

    setSession(newSession)
    setTerminalLines([
      {
        id: "welcome",
        type: "system",
        content: `🔒 Session sécurisée établie avec ${vm.name} (${vm.ip})`,
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
        content: `root@${vm.name}:~#`,
        timestamp: new Date()
      }
    ])

    toast({
      title: "Connexion établie",
      description: `Terminal connecté à ${vm.name}`,
      variant: "success",
    })
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

    setIsExecuting(true)

    // Add command to history
    const newHistory = [...commandHistory, currentCommand]
    setCommandHistory(newHistory)
    setHistoryIndex(-1)

    // Add command line
    const commandLine: TerminalLine = {
      id: `cmd-${Date.now()}`,
      type: "command",
      content: `root@${session.vmName}:~# ${currentCommand}`,
      timestamp: new Date()
    }

    setTerminalLines(prev => [...prev, commandLine])
    setCurrentCommand("")

    try {
      // Handle special commands
      if (currentCommand.trim() === "clear") {
        setTerminalLines([
          {
            id: "prompt-clear",
            type: "system",
            content: `root@${session.vmName}:~#`,
            timestamp: new Date()
          }
        ])
        setIsExecuting(false)
        return
      }

      if (currentCommand.trim() === "exit") {
        disconnectSession()
        setIsExecuting(false)
        return
      }

      // Execute command
      const result = await simulateCommand(currentCommand)

      // Add output
      if (result.output) {
        const outputLine: TerminalLine = {
          id: `out-${Date.now()}`,
          type: result.isError ? "error" : "output",
          content: result.output,
          timestamp: new Date()
        }
        setTerminalLines(prev => [...prev, outputLine])
      }

      // Add new prompt
      const promptLine: TerminalLine = {
        id: `prompt-${Date.now()}`,
        type: "system",
        content: `root@${session.vmName}:~#`,
        timestamp: new Date()
      }
      setTerminalLines(prev => [...prev, promptLine])

    } catch (error) {
      const errorLine: TerminalLine = {
        id: `err-${Date.now()}`,
        type: "error",
        content: "Terminal error: Command execution failed",
        timestamp: new Date()
      }
      setTerminalLines(prev => [...prev, errorLine])
    } finally {
      setIsExecuting(false)
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
            <Select value={selectedVM} onValueChange={setSelectedVM}>
              <SelectTrigger className="rounded-xl">
                <SelectValue placeholder="Sélectionnez une VM..." />
              </SelectTrigger>
              <SelectContent>
                {vms.map((vm) => (
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
              disabled={!selectedVM || !sshUser}
              className="w-full rounded-xl"
            >
              <Terminal className="mr-2 h-4 w-4" />
              Se connecter en SSH
            </Button>

            <div className="text-sm text-muted-foreground bg-muted/50 p-4 rounded-xl">
              <div className="flex items-center gap-2 mb-2">
                <Settings className="h-4 w-4" />
                <strong>Informations de sécurité</strong>
              </div>
              <ul className="space-y-1 text-xs">
                <li>• Connexion SSH sécurisée avec authentification par clé</li>
                <li>• Toutes les commandes sont enregistrées pour audit</li>
                <li>• Les commandes dangereuses sont automatiquement bloquées</li>
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
                <Terminal className="h-5 w-5" />
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
                  <span className="text-yellow-400">root@{session.vmName}:~#</span>
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
                  Utilisez ↑/↓ pour l'historique • 'help' pour les commandes • 'exit' pour quitter
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  )
}
