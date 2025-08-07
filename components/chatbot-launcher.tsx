"use client"

import * as React from "react"
import { Bot, Send, X, Minimize2, MessageCircle, Sparkles, Image as ImageIcon, Paperclip, Mic } from 'lucide-react'
import { motion, AnimatePresence } from "framer-motion"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { ScrollArea } from "@/components/ui/scroll-area"
import { useToast } from "@/hooks/use-toast"
import { cn } from "@/lib/utils"
import { ChatbotModal } from "@/components/chatbot-modal"

interface Attachment {
  type: "image" | "file" | "audio"
  url: string
  name: string
}

interface ChatMessage {
  id: string
  type: "user" | "bot"
  content: string
  timestamp: Date
  attachment?: Attachment
}

interface ChatbotLauncherProps {
  className?: string
}

// Simulate AI chatbot responses
const simulateChatbotResponse = async (message: string): Promise<string> => {
  await new Promise(resolve => setTimeout(resolve, 1500))
  
  const responses = {
    "help": "🤖 Je peux vous aider avec :\n• Gestion des VMs\n• Analyse des logs\n• Configuration Proxmox\n• Scripts Terraform\n\nQue souhaitez-vous faire ?",
    "vm": "Pour les VMs, je peux vous aider à :\n• Créer une nouvelle VM\n• Diagnostiquer des problèmes\n• Optimiser les performances\n• Gérer les templates",
    "logs": "Pour les logs, je peux :\n• Analyser les erreurs récentes\n• Filtrer par niveau de criticité\n• Exporter des rapports\n• Identifier des patterns",
    "proxmox": "Configuration Proxmox :\n• Vérifier la connectivité API\n• Tester les tokens d'authentification\n• Valider les paramètres réseau\n• Diagnostiquer les erreurs",
    "default": "🤖 Je suis votre assistant LinuSupervisor ! Je peux vous aider avec la gestion de vos VMs, l'analyse des logs, et la configuration de votre environnement. Que puis-je faire pour vous ?"
  }
  
  const lowerMessage = message.toLowerCase()
  
  if (lowerMessage.includes("help") || lowerMessage.includes("aide")) {
    return responses.help
  } else if (lowerMessage.includes("vm") || lowerMessage.includes("machine")) {
    return responses.vm
  } else if (lowerMessage.includes("log") || lowerMessage.includes("erreur")) {
    return responses.logs
  } else if (lowerMessage.includes("proxmox") || lowerMessage.includes("config")) {
    return responses.proxmox
  } else {
    return responses.default
  }
}

export function ChatbotLauncher({ className }: ChatbotLauncherProps) {
  const [isOpen, setIsOpen] = React.useState(false)
  const [isMinimized, setIsMinimized] = React.useState(false)
  const [messages, setMessages] = React.useState<ChatMessage[]>([])
  const [inputValue, setInputValue] = React.useState("")
  const [isLoading, setIsLoading] = React.useState(false)
  const { toast } = useToast()
  const scrollAreaRef = React.useRef<HTMLDivElement>(null)
  const [isModalOpen, setIsModalOpen] = React.useState(false)
  const fileInputRef = React.useRef<HTMLInputElement>(null)
  const imageInputRef = React.useRef<HTMLInputElement>(null)
  const [isRecording, setIsRecording] = React.useState(false)
  const mediaRecorderRef = React.useRef<MediaRecorder | null>(null)
  const recordingChunks = React.useRef<Blob[]>([])

  // Auto-scroll to bottom when new messages arrive
  React.useEffect(() => {
    if (scrollAreaRef.current) {
      scrollAreaRef.current.scrollTop = scrollAreaRef.current.scrollHeight
    }
  }, [messages])

  const handleSendMessage = async () => {
    if (!inputValue.trim() || isLoading) return

    const userMessage: ChatMessage = {
      id: Date.now().toString(),
      type: "user",
      content: inputValue.trim(),
      timestamp: new Date()
    }

    setMessages(prev => [...prev, userMessage])
    setInputValue("")
    setIsLoading(true)

    try {
      const botResponse = await simulateChatbotResponse(userMessage.content)
      
      const botMessage: ChatMessage = {
        id: (Date.now() + 1).toString(),
        type: "bot",
        content: botResponse,
        timestamp: new Date()
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

  const handleFileChange = (
    e: React.ChangeEvent<HTMLInputElement>,
    type: "file" | "image"
  ) => {
    const file = e.target.files?.[0]
    if (!file) return
    const url = URL.createObjectURL(file)
    const userMessage: ChatMessage = {
      id: Date.now().toString(),
      type: "user",
      content: "",
      timestamp: new Date(),
      attachment: { type, url, name: file.name }
    }
    setMessages(prev => [...prev, userMessage])
    e.target.value = ""
  }

  const handleToggleRecording = async () => {
    if (isRecording) {
      mediaRecorderRef.current?.stop()
      setIsRecording(false)
    } else {
      try {
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
        const recorder = new MediaRecorder(stream)
        mediaRecorderRef.current = recorder
        recordingChunks.current = []
        recorder.ondataavailable = (event) => {
          if (event.data.size > 0) {
            recordingChunks.current.push(event.data)
          }
        }
        recorder.onstop = () => {
          const blob = new Blob(recordingChunks.current, { type: 'audio/webm' })
          const url = URL.createObjectURL(blob)
          const userMessage: ChatMessage = {
            id: Date.now().toString(),
            type: 'user',
            content: '',
            timestamp: new Date(),
            attachment: { type: 'audio', url, name: 'enregistrement.webm' }
          }
          setMessages(prev => [...prev, userMessage])
        }
        recorder.start()
        setIsRecording(true)
      } catch (error) {
        console.error('Audio recording error:', error)
      }
    }
  }

  const openChat = () => {
    setIsOpen(true)
    setIsMinimized(false)
    
    // Add welcome message if first time opening
    if (messages.length === 0) {
      const welcomeMessage: ChatMessage = {
        id: "welcome",
        type: "bot",
        content: "👋 Bonjour ! Je suis votre assistant LinuSupervisor. Comment puis-je vous aider aujourd'hui ?",
        timestamp: new Date()
      }
      setMessages([welcomeMessage])
    }
  }

  return (
    <>
      {/* Floating Launcher Button */}
      <AnimatePresence>
        {!isModalOpen && !isOpen && ( // Only show launcher if modal and chat window are closed
          <motion.div
            initial={{ scale: 0, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0, opacity: 0 }}
            className={cn("fixed bottom-6 right-6 z-50", className)}
          >
            <Button
              onClick={openChat} // Changed to open the chat window directly
              size="lg"
              className="h-16 w-16 rounded-full shadow-lg hover:shadow-xl transition-all duration-300 bg-primary hover:bg-primary/90 relative overflow-hidden group"
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
                <Bot className="h-7 w-7 transition-transform duration-300 group-hover:scale-110" />
                <motion.div
                  animate={{ scale: [1, 1.2, 1], opacity: [0.5, 1, 0.5] }}
                  transition={{ duration: 2, repeat: Infinity }}
                  className="absolute -top-1 -right-1 h-3 w-3 bg-green-400 rounded-full border-2 border-primary"
                />
              </motion.div>
            </Button>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Chat Window */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, scale: 0.8, y: 20 }}
            animate={{ opacity: 1, scale: 1, y: 0 }}
            exit={{ opacity: 0, scale: 0.8, y: 20 }}
            className="fixed bottom-6 right-6 z-50 w-96 h-[500px]"
          >
            <Card className="h-full flex flex-col shadow-2xl border-2">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2 bg-primary text-primary-foreground rounded-t-lg">
                <CardTitle className="text-lg flex items-center gap-2">
                  <Bot className="h-5 w-5" />
                  Assistant LinuSupervisor
                </CardTitle>
                <div className="flex gap-1">
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
                    <CardContent className="flex-1 p-0 flex flex-col">
                      {/* Messages Area */}
                      <ScrollArea className="flex-1 p-4 overflow-y-auto" ref={scrollAreaRef}>
                        <div className="space-y-4">
                          {messages.map((message) => (
                            <div
                              key={message.id}
                              className={cn(
                                "flex",
                                message.type === "user" ? "justify-end" : "justify-start"
                              )}
                            >
                              <div
                                className={cn(
                                  "max-w-[80%] rounded-2xl px-4 py-2 text-sm break-words",
                                  message.type === "user"
                                    ? "bg-primary text-primary-foreground"
                                    : "bg-muted text-foreground",
                                )}
                              >
                                {message.attachment ? (
                                  message.attachment.type === "image" ? (
                                    <img
                                      src={message.attachment.url}
                                      alt={message.attachment.name}
                                      className="rounded-md max-w-full"
                                    />
                                  ) : message.attachment.type === "audio" ? (
                                    <audio controls src={message.attachment.url} className="w-full" />
                                  ) : (
                                    <a
                                      href={message.attachment.url}
                                      download={message.attachment.name}
                                      className="underline"
                                    >
                                      {message.attachment.name}
                                    </a>
                                  )
                                ) : (
                                  <div className="whitespace-pre-wrap break-words">{message.content}</div>
                                )}
                                <div className="text-xs opacity-70 mt-1">
                                  {message.timestamp.toLocaleTimeString("fr-FR", {
                                    hour: "2-digit",
                                    minute: "2-digit"
                                  })}
                                </div>
                              </div>
                            </div>
                          ))}
                          
                          {isLoading && (
                            <div className="flex justify-start">
                              <div className="bg-muted text-foreground rounded-2xl px-4 py-2 text-sm">
                                <div className="flex items-center gap-2">
                                  <div className="flex space-x-1">
                                    <div className="w-2 h-2 bg-current rounded-full animate-bounce" style={{ animationDelay: "0ms" }} />
                                    <div className="w-2 h-2 bg-current rounded-full animate-bounce" style={{ animationDelay: "150ms" }} />
                                    <div className="w-2 h-2 bg-current rounded-full animate-bounce" style={{ animationDelay: "300ms" }} />
                                  </div>
                                  <span className="text-xs opacity-70">Assistant en train d'écrire...</span>
                                </div>
                              </div>
                            </div>
                          )}
                        </div>
                      </ScrollArea>

                      {/* Input Area */}
                      <div className="p-4 border-t">
                        <div className="flex gap-2 items-end">
                          <input
                            type="file"
                            accept="image/*"
                            ref={imageInputRef}
                            className="hidden"
                            onChange={(e) => handleFileChange(e, "image")}
                          />
                          <input
                            type="file"
                            ref={fileInputRef}
                            className="hidden"
                            onChange={(e) => handleFileChange(e, "file")}
                          />
                          <Button
                            type="button"
                            variant="ghost"
                            size="icon"
                            onClick={() => imageInputRef.current?.click()}
                          >
                            <ImageIcon className="h-4 w-4" />
                          </Button>
                          <Button
                            type="button"
                            variant="ghost"
                            size="icon"
                            onClick={() => fileInputRef.current?.click()}
                          >
                            <Paperclip className="h-4 w-4" />
                          </Button>
                          <Button
                            type="button"
                            variant={isRecording ? "destructive" : "ghost"}
                            size="icon"
                            onClick={handleToggleRecording}
                          >
                            <Mic className="h-4 w-4" />
                          </Button>
                          <Input
                            value={inputValue}
                            onChange={(e) => setInputValue(e.target.value)}
                            onKeyPress={handleKeyPress}
                            placeholder="Tapez votre message..."
                            disabled={isLoading}
                            className="flex-1"
                          />
                          <Button
                            onClick={handleSendMessage}
                            disabled={!inputValue.trim() || isLoading}
                            size="sm"
                            className="px-3"
                          >
                            <Send className="h-4 w-4" />
                          </Button>
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

      {/* The ChatbotModal is now separate and can be triggered by other means if needed */}
      <ChatbotModal isOpen={isModalOpen} setIsOpen={setIsModalOpen} />
    </>
  )
}