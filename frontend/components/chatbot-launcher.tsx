"use client"

import { useEffect, useRef, useState } from "react"
import { Button } from "@/components/ui/button"
import { MessageCircle, X } from "lucide-react"
import { ChatbotInterface } from "./chatbot-interface"
import { cn } from "@/lib/utils"

export function ChatbotLauncher() {
  const [isOpen, setIsOpen] = useState(false)
  const [isOverlay, setIsOverlay] = useState(false)
  const launcherRef = useRef<HTMLButtonElement>(null)

  useEffect(() => {
    if (!isOverlay && launcherRef.current) {
      launcherRef.current.focus()
    }
  }, [isOverlay])

  return (
    <>
      {isOpen && (
        <ChatbotInterface
          onClose={() => {
            setIsOpen(false)
            setIsOverlay(false)
          }}
          isOverlay={isOverlay}
          onToggleOverlay={setIsOverlay}
        />
      )}

      <Button
        ref={launcherRef}
        onClick={() => setIsOpen(!isOpen)}
        className={cn(
          "fixed z-[110] h-14 w-14 rounded-full shadow-lg",
          "pulse-glow animate-bounce-slow",
          "hover:scale-110 transition-all duration-300"
        )}
        style={{
          bottom: `calc(1rem + env(safe-area-inset-bottom))`,
          right: `calc(1rem + env(safe-area-inset-right))`,
        }}
        size="icon"
        aria-label={isOpen ? "Fermer l'assistant" : "Ouvrir l'assistant"}
      >
        {isOpen ? (
          <X className="h-6 w-6" />
        ) : (
          <MessageCircle className="h-6 w-6" />
        )}
      </Button>
    </>
  )
}
