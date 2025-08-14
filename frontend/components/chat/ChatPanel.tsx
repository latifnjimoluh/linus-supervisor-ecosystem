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
    startStreamingMessage,
    setStatus,
    stopStream,
    status,
  } = useChatStore();

  const [input, setInput] = useState<string>("");
  const endRef = useRef<HTMLDivElement | null>(null);
  const cancelRef = useRef<null | (() => void)>(null);
  const { setError, clearError } = useErrors();

  if (!isOpen) return null;

  const scrollToBottom = () =>
    endRef.current?.scrollIntoView({ behavior: "smooth" });

  const handleStop = () => {
    cancelRef.current?.();
    cancelRef.current = null;
    stopStream(); // passe en idle + clear streamingMessageId
  };

  const handleSend = async () => {
    const trimmed = input.trim();
    if (!trimmed || status === "streaming") return;

    // 1) Ajoute le message utilisateur
    const userMessage: ChatMessage = {
      id: crypto.randomUUID(),
      role: "user",
      content: trimmed,
    };
    addMessage(userMessage);
    setInput("");

    // 2) Prépare le message assistant vide (stream)
    const assistantId = crypto.randomUUID();
    startStreamingMessage(assistantId);

    try {
      // 3) Historique minimal { role, content }
      const wireHistory = [...messages, userMessage].map((m) => ({
        role: m.role,
        content: m.content,
      }));

      // 4) Lance le SSE
      cancelRef.current = await askChatbotStream(wireHistory, {
        onDelta: (piece) => {
          appendToMessage(assistantId, piece);
          scrollToBottom();
        },
        onDone: () => {
          stopStream();
          cancelRef.current = null;
          try {
            clearError("chat");
          } catch {}
          scrollToBottom();
        },
        onError: (err) => {
          stopStream();
          cancelRef.current = null;
          const msg =
            (err as any)?.info ||
            (err as any)?.error ||
            (err as any)?.message ||
            "Erreur de streaming";
          appendToMessage(assistantId, `\n\n(Erreur: ${msg})`);
          setError("chat", msg);
          scrollToBottom();
        },
      });
    } catch (err: unknown) {
      stopStream();
      const message =
        (err as any)?.message ||
        (typeof err === "string" ? err : null) ||
        "Erreur inconnue";
      setError("chat", message);
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
          <span className="font-semibold text-sm">Chatbot</span>
          <div className="flex items-center gap-1">
            {status === "streaming" && (
              <Button
                variant="ghost"
                size="icon"
                onClick={handleStop}
                aria-label="Arrêter"
                title="Couper le flux"
              >
                <Square className="h-4 w-4" />
              </Button>
            )}
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
            <div
              key={m.id}
              className={cn("text-sm", m.role === "user" ? "text-right" : "text-left")}
            >
              <div
                className={cn(
                  "inline-block rounded-lg px-3 py-2 whitespace-pre-wrap",
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
            void handleSend();
          }}
          className="flex gap-2 border-t p-2"
        >
          <Input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder={status === "streaming" ? "Réponse en cours..." : "Votre message..."}
            className="flex-1"
            disabled={status === "streaming"}
            onKeyDown={(e) => {
              if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                void handleSend();
              }
            }}
          />
          <Button
            type="submit"
            size="icon"
            disabled={status === "streaming" || !input.trim()}
            aria-disabled={status === "streaming" || !input.trim()}
          >
            <Send className="h-4 w-4" />
          </Button>
        </form>
      </div>
    </div>
  );
}

export default ChatPanel;
