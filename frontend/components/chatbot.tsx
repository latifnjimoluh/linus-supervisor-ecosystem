"use client";

import { useState } from "react";
import { MessageCircle, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { sendMessage } from "@/services/chat";

interface Msg { role: "user" | "assistant"; content: string }

export function Chatbot() {
  const initial = "Bonjour, je suis l'assistant Linusupervisor. Posez vos questions sur le projet.";
  const [open, setOpen] = useState(false);
  const [input, setInput] = useState("");
  const [messages, setMessages] = useState<Msg[]>([{ role: "assistant", content: initial }]);

  const handleSend = async () => {
    const text = input.trim();
    if (!text) return;
    setInput("");
    setMessages((m) => [...m, { role: "user", content: text }]);
    try {
      const reply = await sendMessage(text);
      const words = reply.split(/\s+/);
      setMessages((m) => [...m, { role: "assistant", content: "" }]);
      let index = 0;
      const interval = setInterval(() => {
        index++;
        setMessages((m) => {
          const copy = [...m];
          const last = copy[copy.length - 1];
          if (last.role === "assistant") {
            last.content = words.slice(0, index).join(" ");
          }
          return copy;
        });
        if (index >= words.length) clearInterval(interval);
      }, 200);
    } catch {
      setMessages((m) => [...m, { role: "assistant", content: "Erreur lors de la communication." }]);
    }
  };

  return open ? (
    <div className="fixed bottom-6 right-6 z-50 flex w-80 flex-col rounded-lg border bg-background p-4 shadow-lg">
      <div className="mb-2 flex items-center justify-between">
        <span className="text-sm font-semibold">Chatbot</span>
        <Button variant="ghost" size="icon" onClick={() => setOpen(false)} aria-label="Fermer">
          <X className="h-4 w-4" />
        </Button>
      </div>
      <div className="mb-2 flex-1 space-y-2 overflow-auto text-sm">
        {messages.map((m, i) => (
          <div key={i} className={`flex ${m.role === "user" ? "justify-end" : "justify-start"}`}>
            <div
              className={`max-w-[75%] rounded px-2 py-1 ${
                m.role === "user"
                  ? "bg-primary text-primary-foreground"
                  : "bg-muted text-muted-foreground"
              }`}
            >
              {m.content}
            </div>
          </div>
        ))}
      </div>
      <div className="flex gap-2">
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          className="flex-1 rounded border px-2 py-1 text-sm"
          placeholder="Votre message"
        />
        <Button size="sm" onClick={handleSend}>
          Envoyer
        </Button>
      </div>
    </div>
  ) : (
    <Button
      onClick={() => setOpen(true)}
      size="icon"
      aria-label="Ouvrir le chat"
      className="fixed bottom-6 right-6 z-50 h-12 w-12 rounded-full shadow-lg"
    >
      <MessageCircle className="h-5 w-5" />
    </Button>
  );
}

export default Chatbot;
