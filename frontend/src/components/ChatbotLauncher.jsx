import React, { useState } from 'react';
import ChatbotWindow from './ChatbotWindow';

export default function ChatbotLauncher() {
  const [open, setOpen] = useState(false);
  return (
    <>
      <button
        className="fixed bottom-4 right-4 bg-blue-600 text-white rounded-full w-14 h-14 shadow-lg flex items-center justify-center animate-bounce z-40"
        onClick={() => setOpen(true)}
        aria-label="Ouvrir le chatbot"
      >
        🤖
      </button>
      {open && <ChatbotWindow onClose={() => setOpen(false)} />}
    </>
  );
}
