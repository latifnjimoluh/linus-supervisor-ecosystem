import { create } from "zustand";

export interface ChatMessage {
  id: string;
  role: "user" | "assistant";
  content: string;
}

interface ChatState {
  isOpen: boolean;
  isExpanded: boolean;
  status: "idle" | "loading";
  messages: ChatMessage[];
  open: () => void;
  close: () => void;
  toggleExpand: () => void;
  addMessage: (m: ChatMessage) => void;
  appendToMessage: (id: string, chunk: string) => void;
  setStatus: (s: "idle" | "loading") => void;
  clear: () => void;
}

export const useChatStore = create<ChatState>((set) => ({
  isOpen: false,
  isExpanded: false,
  status: "idle",
  messages: [],
  open: () => set({ isOpen: true }),
  close: () => set({ isOpen: false, isExpanded: false }),
  toggleExpand: () => set((s) => ({ isExpanded: !s.isExpanded })),
  addMessage: (m) => set((s) => ({ messages: [...s.messages, m] })),
  appendToMessage: (id, chunk) =>
    set((s) => ({
      messages: s.messages.map((m) =>
        m.id === id ? { ...m, content: m.content + chunk } : m
      ),
    })),
  setStatus: (status) => set({ status }),
  clear: () => set({ messages: [], status: "idle" }),
}));

export default useChatStore;
