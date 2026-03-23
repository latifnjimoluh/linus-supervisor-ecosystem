"use client";

import { useEffect, useRef, useState } from "react";
import { MessageCircle, X, Download, FileText } from "lucide-react";
import { Button } from "@/components/ui/button";
import { ChatMessage, createConversation, streamChatMessage, fetchConversation } from "@/services/chat";

export function Chatbot() {
  const [open, setOpen] = useState(false);
  const [input, setInput] = useState("");
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [conversationId, setConversationId] = useState<number | null>(null);
  const [isStreaming, setIsStreaming] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const abortRef = useRef<AbortController | null>(null);
  const [autoScroll, setAutoScroll] = useState(true);
  const [showNew, setShowNew] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    if (!open) return;
    const el = containerRef.current;
    if (!el) return;
    const focusable = el.querySelectorAll<HTMLElement>(
      'button, [href], input, textarea, select, [tabindex]:not([tabindex="-1"])'
    );
    focusable[0]?.focus();
    const handleKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') setOpen(false);
      if (e.key !== 'Tab') return;
      const first = focusable[0];
      const last = focusable[focusable.length - 1];
      if (e.shiftKey) {
        if (document.activeElement === first) {
          e.preventDefault();
          (last as HTMLElement).focus();
        }
      } else if (document.activeElement === last) {
        e.preventDefault();
        (first as HTMLElement).focus();
      }
    };
    el.addEventListener('keydown', handleKey);
    return () => el.removeEventListener('keydown', handleKey);
  }, [open]);

  useEffect(() => {
    const stored = typeof window !== 'undefined' ? localStorage.getItem('chat_conversation_id') : null;
    if (stored && !conversationId) {
      const id = parseInt(stored, 10);
      setConversationId(id);
      fetchConversation(id)
        .then((msgs) => setMessages(msgs))
        .catch(() => {});
    }
  }, [conversationId]);

  useEffect(() => {
    if (!error) return;
    const t = setTimeout(() => setError(""), 3000);
    return () => clearTimeout(t);
  }, [error]);

  const handleScroll = () => {
    const el = scrollRef.current;
    if (!el) return;
    const atBottom = el.scrollTop + el.clientHeight >= el.scrollHeight - 10;
    setAutoScroll(atBottom);
    if (atBottom) setShowNew(false);
  };

  useEffect(() => {
    if (autoScroll) {
      scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight });
    } else if (messages.length) {
      setShowNew(true);
    }
  }, [messages, autoScroll]);

  const scrollToBottom = () => {
    const el = scrollRef.current;
    if (el) {
      el.scrollTo({ top: el.scrollHeight, behavior: 'smooth' });
      setAutoScroll(true);
      setShowNew(false);
    }
  };

  const handleSend = async () => {
    const text = input.trim();
    if (!text || isStreaming) return;
    setInput("");
    setMessages((m) => [...m, { role: 'user', content: text }, { role: 'assistant', content: '' }]);
    setIsStreaming(true);

    const controller = new AbortController();
    abortRef.current = controller;

    try {
      let convId = conversationId;
      if (!convId) {
        convId = await createConversation();
        setConversationId(convId);
        if (typeof window !== 'undefined') {
          localStorage.setItem('chat_conversation_id', String(convId));
        }
      }
      await streamChatMessage(
        convId,
        text,
        (chunk) => {
          setMessages((m) => {
            const copy = [...m];
            const last = copy[copy.length - 1];
            if (last && last.role === 'assistant') {
              last.content += chunk;
            }
            return copy;
          });
        },
        controller.signal
      );
    } catch (err: any) {
      if (err.name !== 'AbortError') {
        const msg = err.message || 'Erreur lors de la communication.';
        setError(msg);
        setMessages((m) => {
          const copy = [...m];
          const last = copy[copy.length - 1];
          if (last && last.role === 'assistant') {
            last.content = msg;
          }
          return copy;
        });
      }
    } finally {
      setIsStreaming(false);
      abortRef.current = null;
    }
  };

  const handleStop = () => {
    abortRef.current?.abort();
  };

  const handleExport = (format: 'md' | 'txt') => {
    const last = [...messages].reverse().find((m) => m.role === 'assistant' && m.content);
    if (!last) return;
    const mime = format === 'md' ? 'text/markdown' : 'text/plain';
    const blob = new Blob([last.content], { type: mime });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `chatbot-response.${format}`;
    a.click();
    URL.revokeObjectURL(url);
  };

  const hasAssistant = messages.some((m) => m.role === 'assistant' && m.content);

  return open ? (
    <div
      ref={containerRef}
      className="fixed bottom-0 right-0 z-50 flex w-full max-w-sm flex-col rounded-t-lg border bg-background p-4 pb-[env(safe-area-inset-bottom)] shadow-lg sm:bottom-6 sm:right-6 sm:w-80 sm:rounded-lg"
    >
      <div className="mb-2 flex items-center justify-between">
        <span className="text-sm font-semibold">Chatbot</span>
        <Button variant="ghost" size="icon" onClick={() => setOpen(false)} aria-label="Fermer">
          <X className="h-4 w-4" />
        </Button>
      </div>
      {error && <div className="mb-2 text-sm text-red-600">{error}</div>}
      <div
        ref={scrollRef}
        onScroll={handleScroll}
        className="mb-2 flex-1 space-y-2 overflow-auto text-sm"
      >
        {messages.map((m, i) => (
          <div key={i} className={`flex ${m.role === 'user' ? 'justify-end' : 'justify-start'}`}>
            <div
              className={`max-w-[75%] rounded px-2 py-1 ${
                m.role === 'user'
                  ? 'bg-primary text-primary-foreground'
                  : 'bg-muted text-muted-foreground'
              }`}
            >
              {m.content}
            </div>
          </div>
        ))}
        {showNew && (
          <div className="sticky bottom-0 flex justify-center">
            <Button size="sm" variant="secondary" onClick={scrollToBottom}>
              Nouveaux messages
            </Button>
          </div>
        )}
      </div>
      <div className="sticky bottom-0 flex gap-2 bg-background pt-2">
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          className="flex-1 rounded border px-2 py-1 text-sm"
          placeholder="Votre message"
        />
        {isStreaming ? (
          <Button size="sm" variant="destructive" onClick={handleStop}>
            Stop
          </Button>
        ) : (
          <Button size="sm" onClick={handleSend} disabled={!input.trim()}>
            Envoyer
          </Button>
        )}
        {!isStreaming && hasAssistant && (
          <>
            <Button
              size="sm"
              variant="ghost"
              onClick={() => handleExport('md')}
              aria-label="Exporter en Markdown"
            >
              <Download className="h-4 w-4" />
            </Button>
            <Button
              size="sm"
              variant="ghost"
              onClick={() => handleExport('txt')}
              aria-label="Exporter en texte"
            >
              <FileText className="h-4 w-4" />
            </Button>
          </>
        )}
      </div>
    </div>
  ) : (
    <Button
      onClick={() => setOpen(true)}
      size="icon"
      aria-label="Ouvrir le chat"
      className="fixed bottom-6 right-6 z-50 h-12 w-12 rounded-full shadow-lg"
      style={{ marginBottom: 'env(safe-area-inset-bottom)' }}
    >
      <MessageCircle className="h-5 w-5" />
    </Button>
  );
}

export default Chatbot;
