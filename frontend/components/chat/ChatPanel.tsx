"use client";

import { useState, useRef } from "react";
import { Send, X, Maximize2, Minimize2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { cn } from "@/lib/utils";
import useChatStore from "@/stores/useChatStore";
import { streamChat } from "@/lib/chat/api";
import { ErrorBanner } from "@/components/error-banner";
import { useErrors } from "@/hooks/use-errors";

export function ChatPanel() {
  const {
    isOpen,
    isExpanded,
    close,
    toggleExpand,
    messages,
    addMessage,
    appendToMessage,
    status,
    setStatus,
  } = useChatStore();
  const [input, setInput] = useState("");
  const endRef = useRef<HTMLDivElement>(null);
  const { setError, clearError } = useErrors();

  if (!isOpen) return null;

  const scrollToBottom = () => endRef.current?.scrollIntoView({ behavior: "smooth" });

  const handleSend = async () => {
    if (!input.trim()) return;
    clearError("chat");
    const user = { id: crypto.randomUUID(), role: "user" as const, content: input.trim() };
    const assistantId = crypto.randomUUID();
    addMessage(user);
    addMessage({ id: assistantId, role: "assistant", content: "" });
    setInput("");
    setStatus("loading");
    scrollToBottom();
    try {
      await streamChat(user.content, (token) => {
        appendToMessage(assistantId, token);
        scrollToBottom();
      });
    } catch {
      setError("chat", { message: "Service de chat indisponible." });
    } finally {
      setStatus("idle");
    }
  };

  const container = isExpanded
    ? "fixed inset-0 z-50 flex items-center justify-center p-4"
    : "fixed bottom-6 right-6 z-50";
  const panel = isExpanded
    ? "mx-auto w-[95vw] max-w-5xl h-[90vh] flex flex-col bg-background border rounded-lg shadow-lg overflow-hidden"
    : "w-[360px] max-w-[90vw] max-h-[70vh] flex flex-col bg-background border rounded-lg shadow-lg overflow-hidden";

  return (
    <div className={container}>
      <div className={panel}>
        <div className="flex items-center justify-between border-b p-2">
          <span className="font-semibold text-sm">Assistant IA</span>
          <div className="flex items-center gap-1">
            <Button
              variant="ghost"
              size="icon"
              onClick={toggleExpand}
              aria-label={isExpanded ? "Réduire" : "Agrandir"}
            >
              {isExpanded ? (
                <Minimize2 className="h-4 w-4" />
              ) : (
                <Maximize2 className="h-4 w-4" />
              )}
            </Button>
            <Button variant="ghost" size="icon" onClick={close} aria-label="Fermer">
              <X className="h-4 w-4" />
            </Button>
          </div>
        </div>
        <ErrorBanner id="chat" />
        <div className="flex-1 overflow-y-auto p-4 space-y-3">
          {messages.map((m) => (
            <div key={m.id} className={cn("text-sm", m.role === "user" ? "text-right" : "text-left")}>\
              <div
                className={cn(
                  "inline-block rounded-lg px-3 py-2",
                  m.role === "user" ? "bg-primary text-primary-foreground" : "bg-muted"
                )}
              >
                {m.content}
              </div>
            </div>
          ))}
          <div ref={endRef} />
        </div>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            handleSend();
          }}
          className="flex gap-2 border-t p-2"
        >
          <Input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Votre message..."
            className="flex-1"
          />
          <Button type="submit" size="icon" disabled={status === "loading" || !input.trim()}>
            <Send className="h-4 w-4" />
          </Button>
        </form>
      </div>
    </div>
  );
}

export default ChatPanel;
