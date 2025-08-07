export interface TemplateField {
  name: string;
  label: string;
  type: 'text' | 'number' | 'password';
  required: boolean;
  default?: string | number;
}

export interface Template {
  id: number;
  name: string;
  description: string;
  category: string;
  service_type: string;
  type: 'script' | 'template';
  template_content: string;
  script_path: string;
  fields_schema?: {
    fields: TemplateField[];
  };
}

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || '';

function authHeader(token?: string) {
  return token ? { Authorization: `Bearer ${token}` } : {};
}

export async function listTemplates(token?: string): Promise<Template[]> {
  const res = await fetch(`${API_BASE_URL}/templates`, {
    headers: {
      ...authHeader(token),
    },
  });
  if (!res.ok) {
    throw new Error('Failed to fetch templates');
  }
  return res.json();
}

export async function getTemplate(id: number, token?: string): Promise<Template> {
  const res = await fetch(`${API_BASE_URL}/templates/${id}`, {
    headers: {
      ...authHeader(token),
    },
  });
  if (!res.ok) {
    throw new Error('Failed to fetch template');
  }
  return res.json();
}

export async function createTemplate(data: Partial<Template>, token: string): Promise<Template> {
  const res = await fetch(`${API_BASE_URL}/templates`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...authHeader(token),
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) {
    throw new Error('Failed to create template');
  }
  return res.json();
}

export async function updateTemplate(id: number, data: Partial<Template>, token: string): Promise<Template> {
  const res = await fetch(`${API_BASE_URL}/templates/${id}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
      ...authHeader(token),
    },
    body: JSON.stringify(data),
  });
  if (!res.ok) {
    throw new Error('Failed to update template');
  }
  return res.json();
}

export async function deleteTemplate(id: number, token: string): Promise<void> {
  const res = await fetch(`${API_BASE_URL}/templates/${id}`, {
    method: 'DELETE',
    headers: {
      ...authHeader(token),
    },
  });
  if (!res.ok) {
    throw new Error('Failed to delete template');
  }
}

export async function generateScript(
  payload: { template_id: number; config_data: Record<string, any> },
  token: string,
): Promise<{ script: string }> {
  const res = await fetch(`${API_BASE_URL}/templates/generate`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...authHeader(token),
    },
    body: JSON.stringify(payload),
  });
  if (!res.ok) {
    throw new Error('Failed to generate script');
  }
  return res.json();
}
