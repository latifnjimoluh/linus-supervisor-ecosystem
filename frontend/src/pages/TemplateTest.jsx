import React, { useEffect, useState } from 'react';
import { useParams } from '../lib/router';
import { getTemplate, generateScript } from '../api/templates';

export default function TemplateTest() {
  const { id } = useParams();
  const [template, setTemplate] = useState(null);
  const [values, setValues] = useState({});
  const [format, setFormat] = useState('bash');
  const [script, setScript] = useState('');

  useEffect(() => {
    getTemplate(id)
      .then((res) => {
        const data = res.data?.data || res.data;
        setTemplate(data);
        const defaults = {};
        (data.fields_schema?.fields || []).forEach((f) => {
          defaults[f.key] = f.default || '';
        });
        setValues(defaults);
      })
      .catch(() => {});
  }, [id]);

  useEffect(() => {
    if (!template) return;
    generateScript({ template_id: id, variables: values, format })
      .then((res) => setScript(res.data?.script || ''))
      .catch(() => setScript(''));
  }, [template, values, format, id]);

  if (!template) return <p>Chargement...</p>;

  const renderField = (f) => {
    const val = values[f.key] ?? '';
    const common = {
      id: f.key,
      value: val,
      onChange: (e) =>
        setValues({ ...values, [f.key]: f.type === 'checkbox' ? e.target.checked : e.target.value })
    };
    switch (f.type) {
      case 'select':
        return (
          <select {...common} className="border p-1 rounded">
            {(f.options || []).map((o) => (
              <option key={o} value={o}>
                {o}
              </option>
            ))}
          </select>
        );
      case 'textarea':
        return <textarea {...common} className="border p-1 rounded" rows="3" />;
      case 'checkbox':
        return <input type="checkbox" checked={val} onChange={common.onChange} />;
      default:
        return <input {...common} type="text" className="border p-1 rounded" />;
    }
  };

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">Test du template: {template.name}</h1>
      <div className="space-y-2">
        {(template.fields_schema?.fields || []).map((f) => (
          <div key={f.key} className="flex flex-col">
            <label className="mb-1" htmlFor={f.key}>
              {f.name}
            </label>
            {renderField(f)}
          </div>
        ))}
      </div>

      <div className="flex space-x-2 items-center">
        <label>Format:</label>
        <select
          value={format}
          onChange={(e) => setFormat(e.target.value)}
          className="border p-1 rounded"
        >
          <option value="bash">Bash</option>
          <option value="ansible">Ansible</option>
        </select>
      </div>

      <pre className="bg-gray-100 p-2 rounded overflow-auto">{script}</pre>
    </div>
  );
}
