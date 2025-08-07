"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { MessageCircle, X } from 'lucide-react'
import { ChatbotInterface } from "./chatbot-interface"
import { cn } from "@/lib/utils"

export function ChatbotLauncher() {
  const [isOpen, setIsOpen] = useState(false)

  return (
    <>
      {/* Chatbot Interface */}
      {isOpen && (
        <div className="fixed bottom-20 right-4 z-50 w-80 h-96 bg-card border border-border rounded-2xl shadow-lg">
          <ChatbotInterface onClose={() => setIsOpen(false)} />
        </div>
      )}

      {/* Floating Button */}
      <Button
        onClick={() => setIsOpen(!isOpen)}
        className={cn(
          "fixed bottom-4 right-4 z-50 h-14 w-14 rounded-full shadow-lg",
          "pulse-glow animate-bounce-slow",
          "hover:scale-110 transition-all duration-300"
        )}
        size="icon"
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
