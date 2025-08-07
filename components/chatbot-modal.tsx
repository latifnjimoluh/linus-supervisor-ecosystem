"use client"

import * as React from "react"
import { Bot, Send, X, Copy, RefreshCw, Sparkles } from 'lucide-react'
import { motion, AnimatePresence } from "framer-motion"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { ScrollArea } from "@/components/ui/scroll-area"
import { Badge } from "@/components/ui/badge"
import { useToast } from "@/hooks/use-toast"
import { cn } from "@/lib/utils"
import { Dialog, DialogContent } from "@/components/ui/dialog"
import { Avatar, AvatarFallback } from "@/components/ui/avatar" // Import Avatar components

interface ChatMessage {
  id: string
  type: "user" | "bot"
  content: string
  timestamp: Date
}

interface ChatbotModalProps {
  isOpen: boolean
  setIsOpen: (isOpen: boolean) => void
}

const simulateEnhancedChatbotResponse = async (message: string): Promise<string> => {
  await new Promise(resolve => setTimeout(resolve, 1500))
  const lowerMessage = message.toLowerCase()
  if (lowerMessage.includes("script")) {
    return `Bien sûr ! Voici un exemple de script de monitoring simple en Bash :

\`\`\`bash
#!/bin/bash
# Script de monitoring simple

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\$$[0-9.]*\$$%* id.*/\\1/" | awk '{print 100 - $1}')
MEM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
MEM_USED=$(free -m | awk '/^Mem:/{print $3}')
MEM_PERC=$((MEM_USED * 100 / MEM_TOTAL))

echo "--- Status Système ---"
echo "CPU: \${CPU_USAGE}%"
echo "Mémoire: \${MEM_USED}MB / \${MEM_TOTAL}MB (\${MEM_PERC}%)"
\`\`\`

Vous pouvez l'améliorer en ajoutant des vérifications de services ou d'espace disque.`
  }
  return `Je suis votre assistant LinuSupervisor ! Je peux vous aider avec la gestion de vos VMs, l'analyse des logs, et la configuration de votre environnement. Que puis-je faire pour vous ?`
}

const suggestedPrompts = [
  "Comment créer un script de monitoring ?",
  "Diagnostiquer une VM lente",
  "Analyser les logs d'erreur récents",
]

export function ChatbotModal({ isOpen, setIsOpen }: ChatbotModalProps) {
  const [messages, setMessages] = React.useState<ChatMessage[]>([])
  const [inputValue, setInputValue] = React.useState("")
  const [isLoading, setIsLoading] = React.useState(false)
  const { toast } = useToast()
  const scrollAreaRef = React.useRef<HTMLDivElement>(null)

  React.useEffect(() => {
    if (isOpen && messages.length === 0) {
      setMessages([
        {
          id: "welcome",
          type: "bot",
          content: "👋 Bonjour ! Je suis votre assistant LinuSupervisor. Comment puis-je vous aider aujourd'hui ?",
          timestamp: new Date()
        }
      ])
    }
  }, [isOpen, messages.length])

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

    try {
      const botResponse = await simulateEnhancedChatbotResponse(userMessage.content)
      const botMessage: ChatMessage = {
        id: (Date.now() + 1).toString(),
        type: "bot",
        content: botResponse,
        timestamp: new Date(),
      }
      setMessages(prev => [...prev, botMessage])
    } catch (error) {
      toast({ title: "Erreur du chatbot", variant: "destructive" })
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
    toast({ title: "Copié !", variant: "success" })
  }

  const clearHistory = () => {
    setMessages([])
    toast({ title: "Historique effacé", variant: "info" })
  }

  const renderMessageContent = (content: string) => {
    const codeBlockRegex = /```(\w+)?\n([\s\S]*?)```/g;
    const parts = content.split(codeBlockRegex);
  
    return parts.map((part, index) => {
      if (index % 3 === 2) { // This is the code content
        return (
          <pre key={index} className="bg-black/20 dark:bg-white/10 p-3 my-2 rounded-lg overflow-x-auto">
            <code className="text-xs font-mono">{part}</code>
          </pre>
        );
      } else if (index % 3 === 0) { // This is regular text
        return <span key={index}>{part}</span>;
      }
      return null; // This is the language part, ignore for now
    });
  };

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogContent className="p-0 border-0 w-[95vw] max-w-2xl h-[80vh] flex flex-col bg-background/80 backdrop-blur-sm">
        <Card className="h-full flex flex-col shadow-2xl border-0 bg-transparent">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 p-4 border-b">
            <CardTitle className="text-lg flex items-center gap-2">
              <Bot className="h-5 w-5 text-primary" />
              Assistant LinuSupervisor
              <Badge variant="secondary" className="text-xs">
                <Sparkles className="h-3 w-3 mr-1" />
                IA
              </Badge>
            </CardTitle>
            <div className="flex gap-1">
              <Button variant="ghost" size="icon" onClick={clearHistory} className="h-8 w-8" title="Effacer l'historique">
                <RefreshCw className="h-4 w-4" />
              </Button>
              <Button variant="ghost" size="icon" onClick={() => setIsOpen(false)} className="h-8 w-8">
                <X className="h-4 w-4" />
              </Button>
            </div>
          </CardHeader>
          
          <CardContent className="flex-1 p-0 flex flex-col overflow-hidden">
            <ScrollArea className="flex-1 p-4" ref={scrollAreaRef}>
              <div className="space-y-4">
                {messages.map((message) => (
                  <motion.div
                    key={message.id}
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    className={cn("flex items-end gap-2", message.type === "user" ? "justify-end" : "justify-start")}
                  >
                    {message.type === "bot" && <Avatar className="h-8 w-8"><AvatarFallback><Bot size={18}/></AvatarFallback></Avatar>}
                    <div className={cn("max-w-[85%] rounded-2xl px-4 py-3 text-sm relative group", message.type === "user" ? "bg-primary text-primary-foreground rounded-br-none" : "bg-muted text-foreground rounded-bl-none")}>
                      <div className="whitespace-pre-wrap">{renderMessageContent(message.content)}</div>
                      <div className="text-xs opacity-70 mt-1 text-right">
                        {message.timestamp.toLocaleTimeString("fr-FR", { hour: "2-digit", minute: "2-digit" })}
                      </div>
                      {message.type === "bot" && (
                        <Button variant="ghost" size="icon" onClick={() => copyMessage(message.content)} className="absolute top-0 right-0 h-6 w-6 opacity-0 group-hover:opacity-100 transition-opacity">
                          <Copy className="h-3 w-3" />
                        </Button>
                      )}
                    </div>
                     {message.type === "user" && <Avatar className="h-8 w-8"><AvatarFallback>U</AvatarFallback></Avatar>}
                  </motion.div>
                ))}
                {isLoading && (
                  <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="flex justify-start items-end gap-2">
                     <Avatar className="h-8 w-8"><AvatarFallback><Bot size={18}/></AvatarFallback></Avatar>
                    <div className="bg-muted text-foreground rounded-2xl px-4 py-3 text-sm border rounded-bl-none">
                      <div className="flex items-center gap-2">
                        <div className="w-2 h-2 bg-current rounded-full animate-bounce" style={{ animationDelay: "0ms" }} />
                        <div className="w-2 h-2 bg-current rounded-full animate-bounce" style={{ animationDelay: "150ms" }} />
                        <div className="w-2 h-2 bg-current rounded-full animate-bounce" style={{ animationDelay: "300ms" }} />
                      </div>
                    </div>
                  </motion.div>
                )}
              </div>
            </ScrollArea>

            {messages.length <= 1 && !isLoading && (
              <div className="px-4 pb-2 border-t pt-2">
                <div className="text-xs text-muted-foreground mb-2">💡 Suggestions :</div>
                <div className="flex flex-wrap gap-2">
                  {suggestedPrompts.map((prompt) => (
                    <Button key={prompt} variant="outline" size="sm" onClick={() => handleSendMessage(prompt)} className="text-xs h-auto py-1 px-2 rounded-full">
                      {prompt}
                    </Button>
                  ))}
                </div>
              </div>
            )}

            <div className="p-4 border-t bg-background/50">
              <div className="relative">
                <Input
                  value={inputValue}
                  onChange={(e) => setInputValue(e.target.value)}
                  onKeyPress={handleKeyPress}
                  placeholder="Posez votre question..."
                  disabled={isLoading}
                  className="pr-12 rounded-full"
                />
                <Button onClick={() => handleSendMessage()} disabled={!inputValue.trim() || isLoading} size="icon" className="absolute top-1/2 right-1 -translate-y-1/2 h-8 w-8 rounded-full">
                  <Send className="h-4 w-4" />
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      </DialogContent>
    </Dialog>
  )
}
