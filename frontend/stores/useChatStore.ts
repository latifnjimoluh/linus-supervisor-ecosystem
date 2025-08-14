// stores/useChatStore.ts
import { create } from "zustand";

export interface ChatMessage {
  id: string;
  role: "user" | "assistant";
  content: string;
}

type ChatStatus = "idle" | "loading" | "streaming";

interface ChatState {
  isOpen: boolean;
  isExpanded: boolean;
  status: ChatStatus;
  /** ID du message assistant en cours de remplissage (stream) */
  streamingMessageId?: string;
  messages: ChatMessage[];

  // UI
  open: () => void;
  close: () => void;
  toggleExpand: () => void;

  // Messages
  addMessage: (m: ChatMessage) => void;
  /** Prépare un message assistant vide et le marque comme “en streaming” */
  startStreamingMessage: (id: string) => void;
  /** Ajoute un morceau de texte à un message existant */
  appendToMessage: (id: string, chunk: string) => void;

  // Statuts
  setStatus: (s: ChatStatus) => void;
  /** Passe en idle et nettoie l’ID de stream courant */
  stopStream: () => void;

  // Reset
  clear: () => void;
}

export const useChatStore = create<ChatState>((set) => ({
  isOpen: false,
  isExpanded: false,
  status: "idle",
  streamingMessageId: undefined,
  messages: [],

  open: () => set({ isOpen: true }),
  close: () => set({ isOpen: false, isExpanded: false }),

  toggleExpand: () => set((s) => ({ isExpanded: !s.isExpanded })),

  addMessage: (m) => set((s) => ({ messages: [...s.messages, m] })),

  startStreamingMessage: (id) =>
    set((s) => ({
      streamingMessageId: id,
      status: "streaming",
      messages: [...s.messages, { id, role: "assistant", content: "" }],
    })),

  appendToMessage: (id, chunk) =>
    set((s) => ({
      messages: s.messages.map((m) =>
        m.id === id ? { ...m, content: m.content + chunk } : m
      ),
    })),

  setStatus: (status) => set({ status }),

  stopStream: () =>
    set(() => ({
      status: "idle",
      streamingMessageId: undefined,
    })),

  clear: () =>
    set({
      messages: [],
      status: "idle",
      streamingMessageId: undefined,
    }),
}));

export default useChatStore;
