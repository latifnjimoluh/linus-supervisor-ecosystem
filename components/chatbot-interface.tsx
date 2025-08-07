"use client"

import { useEffect, useRef, useState } from "react"
import { Button } from "@/components/ui/button"
import { Textarea } from "@/components/ui/textarea"
import { ScrollArea } from "@/components/ui/scroll-area"
import { X, Send, Bot, User, Image as ImageIcon, Mic } from 'lucide-react'

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
      timestamp: new Date()
    }
  ])
  const [input, setInput] = useState("")

  const imageInputRef = useRef<HTMLInputElement>(null)
  const audioInputRef = useRef<HTMLInputElement>(null)
  const endRef = useRef<HTMLDivElement>(null)
  const textareaRef = useRef<HTMLTextAreaElement>(null)
  useEffect(() => {
    endRef.current?.scrollIntoView({ behavior: "smooth" })
  }, [messages])

  const handleSend = () => {
    if (!input.trim()) return

    const userMessage: Message = {
      id: Date.now().toString(),
      type: "user",
      content: input,
      timestamp: new Date()
    }

    setMessages(prev => [...prev, userMessage])
    setInput("")
    if (textareaRef.current) {
      textareaRef.current.style.height = "auto"
    }

    // Simulate AI response
    setTimeout(() => {
      const botMessage: Message = {
        id: (Date.now() + 1).toString(),
        type: "bot",
        content: "Je comprends votre question. Laissez-moi analyser vos données...",
        timestamp: new Date()
      }
      setMessages(prev => [...prev, botMessage])
    }, 1000)
  }

  const handleImageUpload = (file: File) => {
    const imageMessage: Message = {
      id: Date.now().toString(),
      type: "user",
      imageUrl: URL.createObjectURL(file),
      timestamp: new Date()
    }
    setMessages(prev => [...prev, imageMessage])
  }

  const handleAudioUpload = (file: File) => {
    const audioMessage: Message = {
      id: Date.now().toString(),
      type: "user",
      audioUrl: URL.createObjectURL(file),
      timestamp: new Date()
    }
    setMessages(prev => [...prev, audioMessage])
  }

  return (
    <div className="flex flex-col h-full">
      {/* Header */}
      <div className="flex items-center justify-between p-4 border-b border-border">
        <div className="flex items-center gap-2">
          <Bot className="h-5 w-5 text-primary" />
          <h3 className="font-semibold">Assistant IA</h3>
        </div>
        <Button variant="ghost" size="icon" onClick={onClose}>
          <X className="h-4 w-4" />
        </Button>
      </div>

      {/* Messages */}
      <ScrollArea className="flex-1 p-4">
        <div className="space-y-4">
          {messages.map((message) => (
            <div
              key={message.id}
              className={`flex gap-3 ${message.type === "user" ? "justify-end" : "justify-start"}`}
            >
              {message.type === "bot" && (
                <div className="h-8 w-8 rounded-full bg-primary/10 flex items-center justify-center">
                  <Bot className="h-4 w-4 text-primary" />
                </div>
              )}
              <div
                className={`max-w-[70%] rounded-xl p-3 text-sm break-words whitespace-pre-wrap ${
                  message.type === "user"
                    ? "bg-primary text-primary-foreground"
                    : "bg-accent text-accent-foreground"
                }`}
              >
                {message.imageUrl && (
                  <img
                    src={message.imageUrl}
                    alt="Image envoyée"
                    className="rounded-md mb-2 max-w-full h-auto"
                  />
                )}
                {message.audioUrl && (
                  <audio controls src={message.audioUrl} className="mb-2 max-w-full" />
                )}
                {message.content}
              </div>
              {message.type === "user" && (
                <div className="h-8 w-8 rounded-full bg-accent flex items-center justify-center">
                  <User className="h-4 w-4" />
                </div>
              )}
            </div>
          ))}
          <div ref={endRef} />
        </div>
      </ScrollArea>

      {/* Input */}
      <div className="p-4 border-t border-border">
        <div className="flex gap-2 items-center">
          <input
            type="file"
            accept="image/*"
            ref={imageInputRef}
            onChange={(e) => e.target.files && handleImageUpload(e.target.files[0])}
            className="hidden"
          />
          <input
            type="file"
            accept="audio/*"
            ref={audioInputRef}
            onChange={(e) => e.target.files && handleAudioUpload(e.target.files[0])}
            className="hidden"
          />
          <Button variant="ghost" size="icon" onClick={() => imageInputRef.current?.click()}>
            <ImageIcon className="h-4 w-4" />
          </Button>
          <Button variant="ghost" size="icon" onClick={() => audioInputRef.current?.click()}>
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
            placeholder="Posez votre question..."
            onKeyDown={(e) => {
              if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault()
                handleSend()
              }
            }}
            className="flex-1 h-10 min-h-0 max-h-40 resize-none overflow-auto text-sm break-words"
          />
          <Button onClick={handleSend} size="icon">
            <Send className="h-4 w-4" />
          </Button>
        </div>
      </div>
    </div>
  )
}
