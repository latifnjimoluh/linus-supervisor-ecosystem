export interface Action {
  id: string;
  type: string;
  label: string;
  payload?: any;
}

export interface ChatMessage {
  role: 'user' | 'assistant';
  content: string;
  actions?: Action[];
}

export interface Evidence {
  source: string;
  score: number;
  preview: string;
}
