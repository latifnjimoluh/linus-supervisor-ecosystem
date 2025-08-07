import { useState } from 'react';
import { sendMessage } from '../api/assistant';

export default function Assistant() {
  const [input, setInput] = useState('');
  const [messages, setMessages] = useState([]);
  const [loading, setLoading] = useState(false);

  const handleSend = async (e) => {
    e.preventDefault();
    if (!input.trim()) return;
    const question = input;
    setMessages((m) => [...m, { from: 'user', text: question }]);
    setInput('');
    setLoading(true);
    try {
      const { reply } = await sendMessage(question);
      setMessages((m) => [...m, { from: 'assistant', text: reply }]);
    } catch (err) {
      setMessages((m) => [...m, { from: 'assistant', text: 'Erreur: ' + err.message }]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="p-4 max-w-2xl mx-auto">
      <h1 className="text-xl font-bold mb-4">Assistant IA</h1>
      <div className="border rounded p-2 h-96 overflow-y-auto mb-4 bg-white">
        {messages.map((m, idx) => (
          <div key={idx} className={`mb-2 ${m.from === 'user' ? 'text-right' : 'text-left'}`}>
            <span className="inline-block px-2 py-1 rounded bg-gray-100">{m.text}</span>
          </div>
        ))}
        {loading && <div className="text-center text-sm text-gray-500">Chargement...</div>}
      </div>
      <form onSubmit={handleSend} className="flex gap-2">
        <input
          className="flex-1 border p-2 rounded"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Posez votre question..."
        />
        <button
          className="bg-blue-600 text-white px-4 py-2 rounded disabled:opacity-50"
          disabled={loading || !input.trim()}
          type="submit"
        >
          Envoyer
        </button>
      </form>
    </div>
  );
}
