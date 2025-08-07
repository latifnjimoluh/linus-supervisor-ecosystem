"use client"

import * as React from "react"
import { Bot, Send, X, Minimize2, MessageCircle, Copy, RefreshCw, Sparkles, Code, FileText, Settings } from 'lucide-react'
import { motion, AnimatePresence } from "framer-motion"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { ScrollArea } from "@/components/ui/scroll-area"
import { Badge } from "@/components/ui/badge"
import { useToast } from "@/hooks/use-toast"
import { cn } from "@/lib/utils"

interface ChatMessage {
id: string
type: "user" | "bot"
content: string
timestamp: Date
isCode?: boolean
language?: string
}

interface ChatbotProps {
className?: string
}

// Enhanced AI responses with code examples and structured content
const simulateEnhancedChatbotResponse = async (message: string): Promise<string> => {
await new Promise(resolve => setTimeout(resolve, 1500))

const lowerMessage = message.toLowerCase()

if (lowerMessage.includes("script") || lowerMessage.includes("bash")) {
return `🔧 **Scripts et automatisation**

Voici comment créer un script de monitoring basique :

\`\`\`bash
#!/bin/bash
# Script de monitoring VM
VM_NAME="$1"
STATUS=$(qm status $VM_NAME)
echo "Status de $VM_NAME: $STATUS"

# Vérification des ressources
CPU_USAGE=$(qm monitor $VM_NAME info cpus)
MEMORY_USAGE=$(qm monitor $VM_NAME info memory)

echo "CPU: $CPU_USAGE%"
echo "Mémoire: $MEMORY_USAGE MB"
\`\`\`

**Actions disponibles :**
• Créer un nouveau script via l'éditeur
• Modifier un template existant
• Tester un script sur une VM

Voulez-vous que je vous aide à personnaliser ce script ?`
}

if (lowerMessage.includes("vm") || lowerMessage.includes("machine")) {
return `🖥️ **Gestion des VMs**

**Commandes utiles :**

| Action | Commande | Description |
|--------|----------|-------------|
| Lister | \`qm list\` | Affiche toutes les VMs |
| Démarrer | \`qm start 100\` | Démarre la VM ID 100 |
| Arrêter | \`qm stop 100\` | Arrête la VM ID 100 |
| Status | \`qm status 100\` | Vérifie l'état de la VM |

**Diagnostic rapide :**
1. Vérifiez l'état avec \`qm status\`
2. Consultez les logs : \`journalctl -u qemu-server@100\`
3. Testez la connectivité réseau

Quelle VM souhaitez-vous diagnostiquer ?`
}

if (lowerMessage.includes("log") || lowerMessage.includes("erreur")) {
return `📋 **Analyse des logs**

**Logs importants à surveiller :**

• **Système** : \`/var/log/syslog\`
• **Proxmox** : \`/var/log/pve/\`
• **VMs** : \`/var/log/qemu-server/\`

**Commandes d'analyse :**
\`\`\`bash
# Erreurs récentes
tail -f /var/log/syslog | grep ERROR

# Logs d'une VM spécifique
journalctl -u qemu-server@100 -f

# Analyse des performances
dmesg | grep -i error
\`\`\`

**Filtres utiles :**
• Niveau critique uniquement
• Dernières 24h
• Par VM spécifique

Quel type d'erreur recherchez-vous ?`
}

if (lowerMessage.includes("proxmox") || lowerMessage.includes("config")) {
return `⚙️ **Configuration Proxmox**

**Vérifications essentielles :**

✅ **Connectivité API**
\`\`\`bash
curl -k https://your-proxmox:8006/api2/json/version
\`\`\`

✅ **Test d'authentification**
\`\`\`bash
pvesh get /nodes
\`\`\`

✅ **Vérification des certificats**
\`\`\`bash
openssl s_client -connect your-proxmox:8006
\`\`\`

**Paramètres recommandés :**
• Token API plutôt que mot de passe
• Certificats SSL valides
• Firewall configuré correctement

Voulez-vous tester votre configuration actuelle ?`
}

if (lowerMessage.includes("terraform")) {
return `🏗️ **Terraform et Infrastructure**

**Structure recommandée :**
\`\`\`hcl
resource "proxmox_vm_qemu" "vm" {
name        = var.vm_name
target_node = var.target_node

cores   = var.cores
memory  = var.memory

disk {
storage = var.storage
size    = var.disk_size
type    = "scsi"
}

network {
model  = "virtio"
bridge = var.network_bridge
}
}
\`\`\`

**Variables importantes :**
• \`vm_name\` : Nom de la VM
• \`cores\` : Nombre de vCPUs
• \`memory\` : RAM en MB
• \`storage\` : Stockage Proxmox

Besoin d'aide pour configurer un template ?`
}

return `🤖 **Assistant LinuSupervisor**

Je peux vous aider avec :

**🖥️ Gestion des VMs**
• Création et configuration
• Diagnostic et dépannage
• Optimisation des performances

**📋 Analyse des logs**
• Filtrage et recherche
• Détection d'anomalies
• Rapports automatisés

**⚙️ Configuration**
• Paramètres Proxmox
• Scripts personnalisés
• Templates Terraform

**💡 Suggestions :**
• "Comment créer un script de monitoring ?"
• "Diagnostiquer une VM lente"
• "Configurer l'authentification Proxmox"

Que puis-je faire pour vous ?`
}

const suggestedPrompts = [
"Comment créer un script de monitoring ?",
"Diagnostiquer une VM qui ne démarre pas",
"Configurer l'authentification Proxmox",
"Analyser les logs d'erreur récents",
"Optimiser les performances d'une VM",
"Créer un template Terraform"
]

export function EnhancedChatbot({ className }: ChatbotProps) {
const [isOpen, setIsOpen] = React.useState(false)
const [isMinimized, setIsMinimized] = React.useState(false)
const [messages, setMessages] = React.useState<ChatMessage[]>([])
const [inputValue, setInputValue] = React.useState("")
const [isLoading, setIsLoading] = React.useState(false)
const [showSuggestions, setShowSuggestions] = React.useState(true)
const { toast } = useToast()
const scrollAreaRef = React.useRef<HTMLDivElement>(null)

// Auto-scroll to bottom when new messages arrive
React.useEffect(() => {
if (scrollAreaRef.current) {
  scrollAreaRef.current.scrollTop = scrollAreaRef.current.scrollHeight
}
}, [messages])

const handleSendMessage = async (messageText?: string) => {
const textToSend = messageText || inputValue
if (!textToSend.trim() || isLoading) return

const userMessage: ChatMessage = {
  id: Date.now().toString(),
  type: "user",
  content: textToSend.trim(),
  timestamp: new Date()
}

setMessages(prev => [...prev, userMessage])
setInputValue("")
setIsLoading(true)
setShowSuggestions(false)

try {
  const botResponse = await simulateEnhancedChatbotResponse(userMessage.content)
  
  const botMessage: ChatMessage = {
    id: (Date.now() + 1).toString(),
    type: "bot",
    content: botResponse,
    timestamp: new Date(),
    isCode: botResponse.includes("\`\`\`"),
    language: botResponse.includes("\`\`\`bash") ? "bash" : botResponse.includes("\`\`\`hcl") ? "hcl" : undefined
  }

  setMessages(prev => [...prev, botMessage])
} catch (error) {
  console.error("Chatbot error:", error)
  toast({
    title: "Erreur du chatbot",
    description: "Assistant momentanément indisponible",
    variant: "destructive",
  })
} finally {
  setIsLoading(false)
}
}

const handleKeyPress = (e: React.KeyboardEvent) => {
if (e.key === 'Enter' && !e.shiftKey) {
  e.preventDefault()
  handleSendMessage()
}
}

const copyMessage = (content: string) => {
navigator.clipboard.writeText(content)
toast({
  title: "Copié !",
  description: "Message copié dans le presse-papiers",
  variant: "success",
})
}

const clearHistory = () => {
setMessages([])
setShowSuggestions(true)
toast({
  title: "Historique effacé",
  description: "La conversation a été réinitialisée",
  variant: "info",
})
}

const openChat = () => {
setIsOpen(true)
setIsMinimized(false)

// Add welcome message if first time opening
if (messages.length === 0) {
  const welcomeMessage: ChatMessage = {
    id: "welcome",
    type: "bot",
    content: "👋 **Bonjour !** Je suis votre assistant LinuSupervisor.\n\nJe peux vous aider avec la gestion de vos VMs, l'analyse des logs, et la configuration de votre environnement Proxmox.\n\n💡 **Astuce :** Cliquez sur une suggestion ci-dessous ou posez-moi directement votre question !",
    timestamp: new Date()
  }
  setMessages([welcomeMessage])
}
}

const renderMessage = (message: ChatMessage) => {
const isMarkdown = message.content.includes('**') || message.content.includes('\`\`\`') || message.content.includes('|')

return (
  <div
    key={message.id}
    className={cn(
      "flex mb-4",
      message.type === "user" ? "justify-end" : "justify-start"
    )}
  >
    <div
      className={cn(
        "max-w-[85%] rounded-2xl px-4 py-3 text-sm relative group",
        message.type === "user"
          ? "bg-primary text-primary-foreground"
          : "bg-muted text-foreground border"
      )}
    >
      {isMarkdown ? (
        <div className="prose prose-sm max-w-none dark:prose-invert">
          <div 
            className="whitespace-pre-wrap"
            dangerouslySetInnerHTML={{
              __html: message.content
                .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
                .replace(/\`\`\`(\w+)?\n([\s\S]*?)\`\`\`/g, '<pre class="bg-black/10 dark:bg-white/10 p-3 rounded-lg overflow-x-auto"><code class="text-xs">$2</code></pre>')
                .replace(/`([^`]+)`/g, '<code class="bg-black/10 dark:bg-white/10 px-1 py-0.5 rounded text-xs">$1</code>')
                .replace(/\n/g, '<br>')
                .replace(/\|(.*?)\|/g, (match, content) => {
                  const cells = content.split('|').map((cell: string) => cell.trim())
                  return `<div class="inline-flex gap-2 bg-black/5 dark:bg-white/5 px-2 py-1 rounded text-xs">${cells.join(' • ')}</div>`
                })
            }}
          />
        </div>
      ) : (
        <div className="whitespace-pre-wrap">{message.content}</div>
      )}
      
      <div className="flex items-center justify-between mt-2 text-xs opacity-70">
        <span>
          {message.timestamp.toLocaleTimeString("fr-FR", {
            hour: "2-digit",
            minute: "2-digit"
          })}
        </span>
        {message.type === "bot" && (
          <Button
            variant="ghost"
            size="sm"
            onClick={() => copyMessage(message.content)}
            className="opacity-0 group-hover:opacity-100 transition-opacity h-6 w-6 p-0"
          >
            <Copy className="h-3 w-3" />
          </Button>
        )}
      </div>
    </div>
  </div>
)
}

return (
<>
  {/* Floating Launcher Button */}
  <AnimatePresence>
    {!isOpen && (
      <motion.div
        initial={{ scale: 0, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        exit={{ scale: 0, opacity: 0 }}
        className={cn("fixed bottom-6 right-6 z-50", className)}
      >
        <Button
          onClick={openChat}
          size="lg"
          className="h-16 w-16 rounded-full shadow-lg hover:shadow-xl transition-all duration-300 bg-primary hover:bg-primary/90 relative overflow-hidden"
        >
          <motion.div
            animate={{ 
              rotate: [0, 10, -10, 0],
              scale: [1, 1.1, 1]
            }}
            transition={{ 
              duration: 3,
              repeat: Infinity,
              repeatType: "reverse"
            }}
            className="relative"
          >
            <Bot className="h-7 w-7" />
            <motion.div
              animate={{ scale: [1, 1.2, 1], opacity: [0.5, 1, 0.5] }}
              transition={{ duration: 2, repeat: Infinity }}
              className="absolute -top-1 -right-1 h-3 w-3 bg-green-400 rounded-full"
            />
          </motion.div>
        </Button>
      </motion.div>
    )}
  </AnimatePresence>

  {/* Enhanced Chat Window */}
  <AnimatePresence>
    {isOpen && (
      <motion.div
        initial={{ opacity: 0, scale: 0.8, y: 20 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        exit={{ opacity: 0, scale: 0.8, y: 20 }}
        className="fixed bottom-6 right-6 z-50 w-[420px] h-[600px]"
      >
        <Card className="h-full flex flex-col shadow-2xl border-2 bg-background/95 backdrop-blur-sm">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-3 bg-gradient-to-r from-primary to-primary/80 text-primary-foreground rounded-t-lg">
            <CardTitle className="text-lg flex items-center gap-2">
              <Bot className="h-5 w-5" />
              Assistant LinuSupervisor
              <Badge variant="secondary" className="text-xs bg-white/20 text-white">
                <Sparkles className="h-3 w-3 mr-1" />
                IA
              </Badge>
            </CardTitle>
            <div className="flex gap-1">
              <Button
                variant="ghost"
                size="sm"
                onClick={clearHistory}
                className="h-8 w-8 p-0 hover:bg-primary-foreground/20"
                title="Effacer l'historique"
              >
                <RefreshCw className="h-4 w-4" />
              </Button>
              <Button
                variant="ghost"
                size="sm"
                onClick={() => setIsMinimized(!isMinimized)}
                className="h-8 w-8 p-0 hover:bg-primary-foreground/20"
              >
                <Minimize2 className="h-4 w-4" />
              </Button>
              <Button
                variant="ghost"
                size="sm"
                onClick={() => setIsOpen(false)}
                className="h-8 w-8 p-0 hover:bg-primary-foreground/20"
              >
                <X className="h-4 w-4" />
              </Button>
            </div>
          </CardHeader>

          <AnimatePresence>
            {!isMinimized && (
              <motion.div
                initial={{ height: 0, opacity: 0 }}
                animate={{ height: "auto", opacity: 1 }}
                exit={{ height: 0, opacity: 0 }}
                className="flex flex-col flex-1"
              >
                <CardContent className="flex-1 p-0 flex flex-col overflow-hidden">
                  {/* Messages Area */}
                  <ScrollArea className="flex-1 p-4" ref={scrollAreaRef}>
                    <div className="space-y-1">
                      {messages.map(renderMessage)}
                      
                      {isLoading && (
                        <div className="flex justify-start mb-4">
                          <div className="bg-muted text-foreground rounded-2xl px-4 py-3 text-sm border">
                            <div className="flex items-center gap-3">
                              <div className="flex space-x-1">
                                <div className="w-2 h-2 bg-current rounded-full animate-bounce" style={{ animationDelay: "0ms" }} />
                                <div className="w-2 h-2 bg-current rounded-full animate-bounce" style={{ animationDelay: "150ms" }} />
                                <div className="w-2 h-2 bg-current rounded-full animate-bounce" style={{ animationDelay: "300ms" }} />
                              </div>
                              <span className="text-xs opacity-70">Assistant en train d'analyser...</span>
                            </div>
                          </div>
                        </div>
                      )}
                    </div>
                  </ScrollArea>

                  {/* Suggestions */}
                  {showSuggestions && messages.length <= 1 && (
                    <div className="px-4 pb-2">
                      <div className="text-xs text-muted-foreground mb-2">💡 Suggestions :</div>
                      <div className="flex flex-wrap gap-2">
                        {suggestedPrompts.slice(0, 3).map((prompt, index) => (
                          <Button
                            key={index}
                            variant="outline"
                            size="sm"
                            onClick={() => handleSendMessage(prompt)}
                            className="text-xs h-7 px-2 rounded-full"
                            disabled={isLoading}
                          >
                            {prompt}
                          </Button>
                        ))}
                      </div>
                    </div>
                  )}

                  {/* Input Area */}
                  <div className="p-4 border-t bg-muted/30">
                    <div className="flex gap-2">
                      <Input
                        value={inputValue}
                        onChange={(e) => setInputValue(e.target.value)}
                        onKeyPress={handleKeyPress}
                        placeholder="Posez votre question..."
                        disabled={isLoading}
                        className="flex-1 rounded-full"
                      />
                      <Button
                        onClick={() => handleSendMessage()}
                        disabled={!inputValue.trim() || isLoading}
                        size="sm"
                        className="px-4 rounded-full"
                      >
                        <Send className="h-4 w-4" />
                      </Button>
                    </div>
                    <div className="text-xs text-muted-foreground mt-2 text-center">
                      🔒 Session sécurisée • Toutes les interactions sont enregistrées
                    </div>
                  </div>
                </CardContent>
              </motion.div>
            )}
          </AnimatePresence>
        </Card>
      </motion.div>
    )}
  </AnimatePresence>
</>
)
}
