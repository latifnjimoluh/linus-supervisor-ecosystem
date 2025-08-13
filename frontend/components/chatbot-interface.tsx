"use client"

import { useEffect, useRef, useState } from "react"
import { createPortal } from "react-dom"
import { Button } from "@/components/ui/button"
import { Textarea } from "@/components/ui/textarea"
import {
  X,
  Send,
  Bot,
  User,
  ImageIcon,
  Mic,
  Loader2,
  Square,
  Maximize2,
  Minimize2,
} from "lucide-react"
import { motion, AnimatePresence } from "framer-motion"
import { cn } from "@/lib/utils"
import { useChatStream } from "@/hooks/useChatStream"

interface Message {
  id: string
  type: "user" | "bot"
  content?: string
  timestamp: Date
  imageUrl?: string
  audioUrl?: string
  done?: boolean
}

interface ChatbotInterfaceProps {
  onClose: () => void
  isOverlay: boolean
  onToggleOverlay: (open: boolean) => void
}

export function ChatbotInterface({ onClose, isOverlay, onToggleOverlay }: ChatbotInterfaceProps) {
  const threadRef = useRef<string>(
    (typeof window !== "undefined" && localStorage.getItem("chatThread")) ||
      crypto.randomUUID()
  )

  const load = (): { messages: Message[]; truncated: boolean } => {
    if (typeof window !== "undefined") {
      const saved = localStorage.getItem(`chat:${threadRef.current}`)
      if (saved) {
        try {
          const parsed = JSON.parse(saved)
          if (Array.isArray(parsed)) {
            return { messages: parsed, truncated: false }
          }
          const msgs = parsed.messages || []
          const over = msgs.length > 200
          return {
            messages: over ? msgs.slice(msgs.length - 200) : msgs,
            truncated: parsed.truncated || over,
          }
        } catch {}
      }
    }
    return {
      messages: [
        {
          id: "1",
          type: "bot",
          content:
            "Bonjour ! Je suis votre assistant IA. Comment puis-je vous aider avec votre infrastructure ?",
          timestamp: new Date(),
        },
      ],
      truncated: false,
    }
  }

  const { messages: initialMessages, truncated: initialTruncated } = load()
  const [messages, setMessages] = useState<Message[]>(initialMessages)
  const [truncated, setTruncated] = useState(initialTruncated)
  const [input, setInput] = useState("")
  const [lastPrompt, setLastPrompt] = useState("")
  const [error, setError] = useState<string | null>(null)
  const imageInputRef = useRef<HTMLInputElement>(null)
  const audioInputRef = useRef<HTMLInputElement>(null)
  const textareaRef = useRef<HTMLTextAreaElement>(null)
  const scrollRef = useRef<HTMLDivElement>(null)
  const containerRef = useRef<HTMLDivElement>(null)
  const toggleRef = useRef<HTMLButtonElement>(null)
  const touchStartY = useRef<number | null>(null)
  const [mounted, setMounted] = useState(false)
  const { send, cancel, isLoading } = useChatStream(threadRef.current)
  const currentBotIdRef = useRef<string | null>(null)
  const [isNearBottom, setIsNearBottom] = useState(true)
  const [showNew, setShowNew] = useState(false)

  const sanitize = (text: string) => text.replace(/[<>]/g, "")

  useEffect(() => {
    if (typeof window !== "undefined") {
      localStorage.setItem("chatThread", threadRef.current)
      setMounted(true)
    }
  }, [])

  useEffect(() => {
    if (!mounted) return
    const app = document.getElementById("__next")
    if (isOverlay) {
      document.body.style.overflow = "hidden"
      app?.setAttribute("aria-hidden", "true")
      app?.setAttribute("inert", "")
    } else {
      document.body.style.overflow = ""
      app?.removeAttribute("aria-hidden")
      app?.removeAttribute("inert")
    }
  }, [isOverlay, mounted])

  useEffect(() => {
    if (!isOverlay) return
    const trap = (e: KeyboardEvent) => {
      if (e.key !== "Tab") return
      const el = containerRef.current
      if (!el) return
      const focusables = el.querySelectorAll<HTMLElement>(
        'button, [href], input, textarea, select, [tabindex]:not([tabindex="-1"])'
      )
      if (focusables.length === 0) return
      const first = focusables[0]
      const last = focusables[focusables.length - 1]
      if (e.shiftKey && document.activeElement === first) {
        e.preventDefault()
        last.focus()
      } else if (!e.shiftKey && document.activeElement === last) {
        e.preventDefault()
        first.focus()
      }
    }
    document.addEventListener("keydown", trap)
    return () => document.removeEventListener("keydown", trap)
  }, [isOverlay])

  useEffect(() => {
    if (isOverlay) textareaRef.current?.focus()
  }, [isOverlay])

  useEffect(() => {
    const handleKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        if (isOverlay) {
          onToggleOverlay(false)
          setTimeout(() => toggleRef.current?.focus(), 0)
        } else {
          onClose()
        }
      }
    }
    document.addEventListener("keydown", handleKey)
    return () => document.removeEventListener("keydown", handleKey)
  }, [isOverlay, onClose, onToggleOverlay])

  useEffect(() => {
    if (typeof window !== "undefined") {
      const payload = {
        messages,
        updatedAt: Date.now(),
        truncated,
      }
      localStorage.setItem(
        `chat:${threadRef.current}`,
        JSON.stringify(payload)
      )
    }
  }, [messages, truncated])

  useEffect(() => {
    const el = scrollRef.current
    if (!el) return
    const onScroll = () => {
      const near = el.scrollHeight - el.scrollTop - el.clientHeight < 80
      setIsNearBottom(near)
      if (near) setShowNew(false)
    }
    el.addEventListener("scroll", onScroll)
    return () => el.removeEventListener("scroll", onScroll)
  }, [])

  const scrollToBottom = () => {
    const el = scrollRef.current
    if (el) el.scrollTo({ top: el.scrollHeight, behavior: "smooth" })
  }

  useEffect(() => {
    scrollToBottom()
  }, [])

  const sendPrompt = (prompt: string) => {
    if (!prompt.trim()) return
    setError(null)

    const userMessage: Message = {
      id: Date.now().toString(),
      type: "user",
      content: sanitize(prompt),
      timestamp: new Date(),
    }

    const botId = (Date.now() + 1).toString()
    const botMessage: Message = {
      id: botId,
      type: "bot",
      content: "",
      timestamp: new Date(),
      done: false,
    }

    setMessages((prev) => {
      let next = [...prev, userMessage, botMessage]
      if (next.length > 200) {
        setTruncated(true)
        next = next.slice(next.length - 200)
      }
      return next
    })
    currentBotIdRef.current = botId
    setLastPrompt(prompt)
    setInput("")
    if (textareaRef.current) textareaRef.current.style.height = "auto"

    send(prompt, {
      onDelta: (token) => {
        setError(null)
        const safe = sanitize(token)
        setMessages((prev) =>
          prev.map((m) =>
            m.id === botId ? { ...m, content: (m.content || "") + safe } : m
          )
        )
        if (isNearBottom) {
          scrollToBottom()
        } else {
          setShowNew(true)
        }
      },
      onEnd: () => {
        setMessages((prev) =>
          prev.map((m) => (m.id === botId ? { ...m, done: true } : m))
        )
      },
      onError: (type) => {
        setMessages((prev) =>
          prev.map((m) => (m.id === botId ? { ...m, done: true } : m))
        )
        if (type === "quota") {
          setError("Quota dépassé – contactez un administrateur")
        } else {
          setError("Connexion interrompue – Réessayer")
        }
      },
    })
  }

  const handleSend = () => {
    if (isLoading || !input.trim()) return
    sendPrompt(input)
  }

  const handleRetry = () => {
    if (lastPrompt) sendPrompt(lastPrompt)
  }

  const handleImageUpload = (file: File) => {
    const imageMessage: Message = {
      id: Date.now().toString(),
      type: "user",
      imageUrl: URL.createObjectURL(file),
      timestamp: new Date(),
    }
    setMessages((prev) => {
      let next = [...prev, imageMessage]
      if (next.length > 200) {
        setTruncated(true)
        next = next.slice(next.length - 200)
      }
      return next
    })
  }

  const handleAudioUpload = (file: File) => {
    const audioMessage: Message = {
      id: Date.now().toString(),
      type: "user",
      audioUrl: URL.createObjectURL(file),
      timestamp: new Date(),
    }
    setMessages((prev) => {
      let next = [...prev, audioMessage]
      if (next.length > 200) {
        setTruncated(true)
        next = next.slice(next.length - 200)
      }
      return next
    })
  }

  useEffect(() => {
    if (isNearBottom) scrollToBottom()
  }, [messages])

  const handleToggleOverlay = () => {
    onToggleOverlay(!isOverlay)
    if (isOverlay) {
      setTimeout(() => toggleRef.current?.focus(), 0)
    }
  }

  const handleBackdropClick = () => {
    onToggleOverlay(false)
    setTimeout(() => toggleRef.current?.focus(), 0)
  }

  const onTouchStart = (e: React.TouchEvent) => {
    touchStartY.current = e.touches[0].clientY
  }
  const onTouchMove = (e: React.TouchEvent) => {
    if (touchStartY.current === null) return
    const diff = e.touches[0].clientY - touchStartY.current
    if (diff > 80) {
      onToggleOverlay(false)
      touchStartY.current = null
      setTimeout(() => toggleRef.current?.focus(), 0)
    }
  }

  if (!mounted) return null
  return createPortal(
    <>
      <AnimatePresence>
        {isOverlay && (
          <motion.div
            key="backdrop"
            className="fixed inset-0 bg-black/50 z-[120]"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.2 }}
            onClick={handleBackdropClick}
          />
        )}
      </AnimatePresence>

      <motion.div
        ref={containerRef}
        role="dialog"
        aria-modal={isOverlay ? "true" : undefined}
        aria-labelledby="chatbot-title"
        className={cn(
          "fixed flex flex-col bg-background border shadow-sm overflow-hidden",
          isOverlay
            ? "z-[130] inset-0 md:inset-auto md:top-1/2 md:left-1/2 md:-translate-x-1/2 md:-translate-y-1/2 md:w-[90%] md:h-[90%] md:rounded-2xl"
            : "z-[100] rounded-2xl"
        )}
        style={{
          ...(isOverlay
            ? { transformOrigin: "bottom right" }
            : {
                width: "min(420px, 96vw)",
                height: "min(70dvh, 640px)",
                bottom: `calc(1rem + env(safe-area-inset-bottom))`,
                right: `calc(1rem + env(safe-area-inset-right))`,
                transformOrigin: "bottom right",
              }),
        }}
        initial={{ opacity: 0, scale: 0.95 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={{ opacity: 0, scale: 0.95 }}
        transition={{ duration: 0.2 }}
        onTouchStart={isOverlay ? onTouchStart : undefined}
        onTouchMove={isOverlay ? onTouchMove : undefined}
      >
        <div className="flex items-center justify-between p-4 border-b">
          <div className="flex items-center gap-2">
            <div className="flex h-7 w-7 items-center justify-center rounded-full bg-primary/10">
              <Bot className="h-4 w-4 text-primary" />
            </div>
            <h3 id="chatbot-title" className="font-semibold">
              Assistant IA
            </h3>
          </div>
          <div className="flex items-center gap-1">
            <Button
              ref={toggleRef}
              variant="ghost"
              size="icon"
              onClick={handleToggleOverlay}
              aria-label={
                isOverlay ? "Réduire l’assistant" : "Agrandir l’assistant"
              }
            >
              {isOverlay ? (
                <Minimize2 className="h-4 w-4" />
              ) : (
                <Maximize2 className="h-4 w-4" />
              )}
            </Button>
            <Button
              variant="ghost"
              size="icon"
              onClick={isOverlay ? handleBackdropClick : onClose}
              aria-label={
                isOverlay ? "Réduire l’assistant" : "Fermer l’assistant"
              }
            >
              <X className="h-4 w-4" />
            </Button>
          </div>
        </div>

        {error && (
          <div className="bg-muted text-foreground flex items-center justify-between px-3 py-2 text-sm">
            <span>{error}</span>
            <button className="underline" onClick={handleRetry}>
              Réessayer
            </button>
          </div>
        )}

        <div
          ref={scrollRef}
          className="relative flex-1 overflow-y-auto p-4 space-y-4"
          aria-live="polite"
        >
          {truncated && (
            <div className="text-center text-xs text-muted-foreground">
              <button
                className="underline"
                onClick={() => {
                  /* eslint-disable-next-line no-alert */
                  alert("Historique complet indisponible")
                }}
              >
                Voir l’historique complet
              </button>
            </div>
          )}
          {messages.map((message) => (
            <div
              key={message.id}
              className={`flex w-full ${
                message.type === "user" ? "justify-end" : "justify-start"
              } px-1`}
            >
              {message.type === "bot" && (
                <div className="flex items-start gap-2 max-w-[80%]">
                  <div className="flex-shrink-0 h-7 w-7 rounded-full bg-primary/10 flex items-center justify-center">
                    <Bot className="h-4 w-4 text-primary" />
                  </div>
                  <div className="bg-accent text-accent-foreground px-4 py-2 rounded-2xl text-sm break-words whitespace-pre-wrap overflow-hidden">
                    {message.content}
                  </div>
                </div>
              )}

              {message.type === "user" && (
                <div className="relative bg-primary text-primary-foreground px-4 py-2 rounded-2xl max-w-[80%] text-sm break-words whitespace-pre-wrap pr-7 overflow-hidden">
                  <div className="absolute top-1 right-1 h-5 w-5 rounded-full bg-accent flex items-center justify-center shadow">
                    <User className="h-3.5 w-3.5 text-foreground" />
                  </div>

                  {message.imageUrl && (
                    <img
                      src={message.imageUrl || "/placeholder.svg"}
                      alt="Image envoyée"
                      loading="lazy"
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

          {showNew && (
            <button
              className="absolute bottom-4 left-1/2 -translate-x-1/2 bg-primary text-primary-foreground px-3 py-1 rounded-full text-xs shadow"
              onClick={() => {
                scrollToBottom()
                setShowNew(false)
              }}
            >
              Nouveaux messages
            </button>
          )}
        </div>

        <div className="p-4 border-t bg-background">
          <div className="flex gap-2 items-end">
            <input
              type="file"
              accept="image/*"
              ref={imageInputRef}
              onChange={(e) =>
                e.target.files && handleImageUpload(e.target.files[0])
              }
              className="hidden"
              aria-label="Télécharger une image"
            />
            <input
              type="file"
              accept="audio/*"
              ref={audioInputRef}
              onChange={(e) =>
                e.target.files && handleAudioUpload(e.target.files[0])
              }
              className="hidden"
              aria-label="Télécharger un audio"
            />
            <Button
              variant="ghost"
              size="icon"
              onClick={() => imageInputRef.current?.click()}
              aria-label="Ajouter une image"
            >
              <ImageIcon className="h-4 w-4" />
            </Button>
            <Button
              variant="ghost"
              size="icon"
              onClick={() => audioInputRef.current?.click()}
              aria-label="Ajouter un audio"
            >
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
              className="flex-1 min-h-[2.5rem] max-h-36 resize-none overflow-auto text-sm"
            />

            {isLoading && (
              <Button
                onClick={() => {
                  cancel()
                  const id = currentBotIdRef.current
                  if (id) {
                    setMessages((prev) =>
                      prev.map((m) => (m.id === id ? { ...m, done: true } : m))
                    )
                  }
                }}
                size="icon"
                variant="ghost"
                aria-label="Arrêter"
              >
                <Square className="h-4 w-4" />
              </Button>
            )}
            <Button
              onClick={handleSend}
              size="icon"
              aria-label="Envoyer"
              disabled={isLoading || !input.trim()}
            >
              {isLoading ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <Send className="h-4 w-4" />
              )}
            </Button>
          </div>
        </div>
      </motion.div>
    </>,
    document.body
  )
}

