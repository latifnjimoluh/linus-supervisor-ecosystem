import React, { useState } from 'react';
import { sendMessage } from '../api/assistant';

export default function ChatbotWindow({ onClose }) {
  const [input, setInput] = useState('');
  const [messages, setMessages] = useState([]);
  const [loading, setLoading] = useState(false);

  const handleSend = async (e) => {
    e.preventDefault();
    if (!input.trim()) return;
    const text = input;
    setMessages((m) => [...m, { from: 'user', text }]);
    setInput('');
    setLoading(true);
    try {
      const { reply } = await sendMessage(text);
      setMessages((m) => [...m, { from: 'assistant', text: reply }]);
    } catch (err) {
      setMessages((m) => [
        ...m,
        { from: 'assistant', text: 'Erreur: ' + (err.message || '') },
      ]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 sm:inset-auto sm:bottom-20 sm:right-4 sm:w-80 sm:h-96 bg-white border shadow-lg flex flex-col rounded-md z-50">
      <div className="flex justify-between items-center p-2 border-b">
        <h2 className="font-semibold">Assistant IA</h2>
        <button onClick={onClose} className="text-gray-600 hover:text-gray-800">
          ×
        </button>
      </div>
      <div className="flex-1 overflow-y-auto p-2">
        {messages.map((m, i) => (
          <div key={i} className={`mb-2 ${m.from === 'user' ? 'text-right' : 'text-left'}`}>
            <span className="inline-block px-2 py-1 rounded bg-gray-100">{m.text}</span>
          </div>
        ))}
        {loading && (
          <div className="text-center text-sm text-gray-500">Chargement...</div>
        )}
      </div>
      <form onSubmit={handleSend} className="p-2 border-t flex gap-2">
        <input
          className="flex-1 border rounded p-1"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Votre question..."
        />
        <button
          type="submit"
          disabled={loading || !input.trim()}
          className="px-2 py-1 bg-blue-600 text-white rounded disabled:opacity-50"
        >
          Envoyer
        </button>
      </form>
    </div>
  );
}
