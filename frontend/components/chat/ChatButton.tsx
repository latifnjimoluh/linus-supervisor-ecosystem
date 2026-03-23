"use client";

import { MessageCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import useChatStore from "@/stores/useChatStore";

export function ChatButton() {
  const open = useChatStore((s) => s.open);
  const isOpen = useChatStore((s) => s.isOpen);
  if (isOpen) return null;
  return (
    <Button
      onClick={open}
      size="icon"
      aria-label="Ouvrir le chat"
      className="fixed bottom-6 right-6 z-50 h-12 w-12 rounded-full shadow-lg"
    >
      <MessageCircle className="h-5 w-5" />
    </Button>
  );
}

export default ChatButton;
