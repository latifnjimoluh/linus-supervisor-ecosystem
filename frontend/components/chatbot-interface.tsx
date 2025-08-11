"use client"

import { useEffect, useRef, useState } from "react"
import { Button } from "@/components/ui/button"
import { Textarea } from "@/components/ui/textarea"
import { ScrollArea } from "@/components/ui/scroll-area"
import { X, Send, Bot, User, ImageIcon, Mic } from 'lucide-react'
import { askChatbotStream } from "@/services/chatbot"

interface Message {
  id: string
  type: "user" | "bot"
  content?: string
  timestamp: Date
  imageUrl?: string
  audioUrl?: string
}

interface ChatbotInterfaceProps {
  onClose: () => void
}

export function ChatbotInterface({ onClose }: ChatbotInterfaceProps) {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: "1",
      type: "bot",
      content: "Bonjour ! Je suis votre assistant IA. Comment puis-je vous aider avec votre infrastructure ?",
      timestamp: new Date(),
    },
  ])
  const [input, setInput] = useState("")
  const [isLoading, setIsLoading] = useState(false)

  const imageInputRef = useRef<HTMLInputElement>(null)
  const audioInputRef = useRef<HTMLInputElement>(null)
  const endRef = useRef<HTMLDivElement>(null)
  const textareaRef = useRef<HTMLTextAreaElement>(null)

  useEffect(() => {
    endRef.current?.scrollIntoView({ behavior: "smooth" })
  }, [messages])

  const handleSend = async () => {
    if (!input.trim() || isLoading) return

    const userMessage: Message = {
      id: Date.now().toString(),
      type: "user",
      content: input,
      timestamp: new Date(),
    }

    const botId = (Date.now() + 1).toString()
    const botMessage: Message = {
      id: botId,
      type: "bot",
      content: "",
      timestamp: new Date(),
    }
    setMessages((prev) => [...prev, userMessage, botMessage])
    setInput("")
    if (textareaRef.current) {
      textareaRef.current.style.height = "auto"
    }

    try {
      setIsLoading(true)
      const history = [...messages, userMessage].map((m) => ({
        role: m.type === "bot" ? "assistant" : "user",
        content: m.content || "",
      }))
      await askChatbotStream(history, (token) => {
        setMessages((prev) =>
          prev.map((m) =>
            m.id === botId ? { ...m, content: (m.content || "") + token } : m
          )
        )
      })
    } catch (err) {
      setMessages((prev) =>
        prev.map((m) =>
          m.id === botId
            ? { ...m, content: "Erreur lors de la réponse du chatbot." }
            : m
        )
      )
    } finally {
      setIsLoading(false)
    }
  }

  const handleImageUpload = (file: File) => {
    const imageMessage: Message = {
      id: Date.now().toString(),
      type: "user",
      imageUrl: URL.createObjectURL(file),
      timestamp: new Date(),
    }
    setMessages((prev) => [...prev, imageMessage])
  }

  const handleAudioUpload = (file: File) => {
    const audioMessage: Message = {
      id: Date.now().toString(),
      type: "user",
      audioUrl: URL.createObjectURL(file),
      timestamp: new Date(),
    }
    setMessages((prev) => [...prev, audioMessage])
  }

  return (
    <div className="flex w-full justify-center">
      {/* Strict frame to ensure conversation stays inside */}
      <div className="w-full max-w-[640px] h-[80vh] flex flex-col rounded-xl border bg-background shadow-sm overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between p-4 border-b">
          <div className="flex items-center gap-2">
            <div className="flex h-7 w-7 items-center justify-center rounded-full bg-primary/10">
              <Bot className="h-4 w-4 text-primary" />
            </div>
            <h3 className="font-semibold">Assistant IA</h3>
          </div>
          <Button variant="ghost" size="icon" onClick={onClose} aria-label="Fermer l’assistant">
            <X className="h-4 w-4" />
          </Button>
        </div>

        {/* Messages area with hard height and scrolling */}
        <div className="flex-1 min-h-0">
          <ScrollArea className="h-full p-4">
            <div className="space-y-4">
              {messages.map((message) => (
                <div
                  key={message.id}
                  className={`flex w-full ${message.type === "user" ? "justify-end" : "justify-start"} px-1`}
                >
                  {message.type === "bot" && (
                    <div className="flex items-start gap-2 max-w-[80%]">
                      <div className="flex-shrink-0 h-7 w-7 rounded-full bg-primary/10 flex items-center justify-center">
                        <Bot className="h-4 w-4 text-primary" />
                      </div>
                      <div className="bg-accent text-accent-foreground px-4 py-2 rounded-2xl text-sm break-words break-all whitespace-pre-wrap overflow-hidden">
                        {message.content}
                      </div>
                    </div>
                  )}

                  {message.type === "user" && (
                    <div className="relative bg-primary text-primary-foreground px-4 py-2 rounded-2xl max-w-[80%] text-sm break-words break-all whitespace-pre-wrap pr-7 overflow-hidden">
                      <div className="absolute top-1 right-1 h-5 w-5 rounded-full bg-accent flex items-center justify-center shadow">
                        <User className="h-3.5 w-3.5 text-foreground" />
                      </div>

                      {message.imageUrl && (
                        <img
                          src={message.imageUrl || "/placeholder.svg"}
                          alt="Image envoyée"
                          className="rounded-md mb-2 max-w-full max-h-64 object-contain"
                        />
                      )}
                      {message.audioUrl && (
                        <audio controls src={message.audioUrl} className="mb-2 max-w-full" />
                      )}
                      {message.content}
                    </div>
                  )}
                </div>
              ))}
              <div ref={endRef} />
            </div>
          </ScrollArea>
        </div>

        {/* Composer */}
        <div className="p-4 border-t">
          <div className="flex gap-2 items-center">
            <input
              type="file"
              accept="image/*"
              ref={imageInputRef}
              onChange={(e) => e.target.files && handleImageUpload(e.target.files[0])}
              className="hidden"
              aria-label="Télécharger une image"
            />
            <input
              type="file"
              accept="audio/*"
              ref={audioInputRef}
              onChange={(e) => e.target.files && handleAudioUpload(e.target.files[0])}
              className="hidden"
              aria-label="Télécharger un audio"
            />
            <Button variant="ghost" size="icon" onClick={() => imageInputRef.current?.click()} aria-label="Ajouter une image">
              <ImageIcon className="h-4 w-4" />
            </Button>
            <Button variant="ghost" size="icon" onClick={() => audioInputRef.current?.click()} aria-label="Ajouter un audio">
              <Mic className="h-4 w-4" />
            </Button>

            <Textarea
              ref={textareaRef}
              rows={1}
              value={input}
              onChange={(e) => {
                setInput(e.target.value)
                if (textareaRef.current) {
                  textareaRef.current.style.height = "auto"
                  textareaRef.current.style.height = `${textareaRef.current.scrollHeight}px`
                }
              }}
              placeholder="Posez votre question…"
              title="Champ de message"
              onKeyDown={(e) => {
                if (e.key === "Enter" && !e.shiftKey) {
                  e.preventDefault()
                  handleSend()
                }
              }}
              className="flex-1 h-10 min-h-0 max-h-40 resize-none overflow-auto text-sm"
            />
            <Button onClick={handleSend} size="icon" aria-label="Envoyer" disabled={isLoading}>
              <Send className="h-4 w-4" />
            </Button>
          </div>
        </div>
      </div>
    </div>
  )
}
