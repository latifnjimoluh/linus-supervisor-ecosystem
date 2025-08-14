"use client";

import { useRef, useState } from "react";
import { Send, X, Maximize2, Minimize2, Square } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { cn } from "@/lib/utils";
import useChatStore from "@/stores/useChatStore";
import { ErrorBanner } from "@/components/error-banner";
import { useErrors } from "@/hooks/use-errors";
import { askChatbotStream, ChatMessage } from "@/services/chatbot";

export function ChatPanel() {
  const {
    isOpen,
    isExpanded,
    close,
    toggleExpand,
    messages,
    addMessage,
    appendToMessage,
    setStatus,
    status,
  } = useChatStore();

  const [input, setInput] = useState<string>("");
  const endRef = useRef<HTMLDivElement | null>(null);
  const cancelRef = useRef<null | (() => void)>(null);
  const { setError, clearError } = useErrors();

  if (!isOpen) return null;

  const scrollToBottom = () => endRef.current?.scrollIntoView({ behavior: "smooth" });

  const handleStop = () => {
    cancelRef.current?.();
    cancelRef.current = null;
    setStatus("idle");
  };

  const handleSend = async () => {
    const trimmed = input.trim();
    if (!trimmed || status === "streaming") return;

    const userMessage: ChatMessage = {
      id: crypto.randomUUID(),
      role: "user",
      content: trimmed,
    };
    addMessage(userMessage);
    setInput("");

    const assistantId = crypto.randomUUID();
    addMessage({ id: assistantId, role: "assistant", content: "" });
    setStatus("streaming");

    try {
      const wireHistory = [...messages, userMessage].map((m) => ({
        role: m.role,
        content: m.content,
      }));

      cancelRef.current = await askChatbotStream(wireHistory, {
        onDelta: (piece) => {
          appendToMessage(assistantId, piece);
          scrollToBottom();
        },
        onDone: () => {
          setStatus("idle");
          cancelRef.current = null;
          clearError("chat");
        },
        onError: (err) => {
          setStatus("idle");
          cancelRef.current = null;
          const msg =
            (err as any)?.info ||
            (err as any)?.error ||
            (err as any)?.message ||
            "Erreur de streaming";
          appendToMessage(assistantId, `\n\n(Erreur: ${msg})`);
          setError("chat", msg);
        },
      });
    } catch (err: unknown) {
      setStatus("idle");
      setError("chat", (err as any)?.message || "Erreur inconnue");
    }
  };

  return (
    <div className={isExpanded ? "fixed inset-0 z-50 flex items-center justify-center p-4" : "fixed bottom-6 right-6 z-50"}>
      <div className={isExpanded ? "mx-auto w-[95vw] max-w-5xl h-[90vh] flex flex-col bg-background border rounded-lg shadow-lg overflow-hidden" : "w-[360px] max-w-[90vw] max-h-[70vh] flex flex-col bg-background border rounded-lg shadow-lg overflow-hidden"}>
        <div className="flex items-center justify-between border-b p-2">
          <span className="font-semibold text-sm">Chatbot</span>
          <div className="flex items-center gap-1">
            {status === "streaming" && (
              <Button variant="ghost" size="icon" onClick={handleStop}>
                <Square className="h-4 w-4" />
              </Button>
            )}
            <Button variant="ghost" size="icon" onClick={toggleExpand}>
              {isExpanded ? <Minimize2 className="h-4 w-4" /> : <Maximize2 className="h-4 w-4" />}
            </Button>
            <Button variant="ghost" size="icon" onClick={close}>
              <X className="h-4 w-4" />
            </Button>
          </div>
        </div>

        <ErrorBanner id="chat" />

        <div className="flex-1 overflow-y-auto p-4 space-y-3">
          {messages.map((m) => (
            <div key={m.id} className={cn("text-sm", m.role === "user" ? "text-right" : "text-left")}>
              <div className={cn("inline-block rounded-lg px-3 py-2 whitespace-pre-wrap", m.role === "user" ? "bg-primary text-primary-foreground" : "bg-muted")}>
                {m.content}
              </div>
            </div>
          ))}
          <div ref={endRef} />
        </div>

        <form onSubmit={(e) => { e.preventDefault(); void handleSend(); }} className="flex gap-2 border-t p-2">
          <Input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder={status === "streaming" ? "Réponse en cours..." : "Votre message..."}
            className="flex-1"
            disabled={status === "streaming"}
          />
          <Button type="submit" size="icon" disabled={status === "streaming" || !input.trim()}>
            <Send className="h-4 w-4" />
          </Button>
        </form>
      </div>
    </div>
  );
}

export default ChatPanel;
