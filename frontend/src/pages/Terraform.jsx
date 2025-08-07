import React, { useState } from 'react';
import { deploy } from '../api/terraform';

export default function Terraform() {
  const [form, setForm] = useState({
    vm_names: '',
    service_type: '',
    script_refs: '[]',
    template_name: '',
    memory_mb: 2048,
    vcpu_cores: 2,
    vcpu_sockets: 1,
    disk_size: '20G',
    use_static_ip: false,
  });
  const [result, setResult] = useState('');
  const [error, setError] = useState('');

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setForm({ ...form, [name]: type === 'checkbox' ? checked : value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    try {
      const payload = {
        ...form,
        vm_names: form.vm_names.split(',').map((v) => v.trim()).filter(Boolean),
        script_refs: JSON.parse(form.script_refs || '[]'),
        memory_mb: Number(form.memory_mb),
        vcpu_cores: Number(form.vcpu_cores),
        vcpu_sockets: Number(form.vcpu_sockets),
      };
      const res = await deploy(payload);
      const data = res.data?.data || res.data;
      setResult(JSON.stringify(data, null, 2));
    } catch (err) {
      const message = err.response?.data?.message || 'Erreur déploiement';
      setError(message);
    }
  };

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">Déploiement Terraform</h1>
      {error && <p className="text-red-500">{error}</p>}
      <form onSubmit={handleSubmit} className="space-y-2">
        <input
          className="w-full border p-2 rounded"
          name="vm_names"
          placeholder="Noms des VMs (séparés par des virgules)"
          value={form.vm_names}
          onChange={handleChange}
        />
        <input
          className="w-full border p-2 rounded"
          name="service_type"
          placeholder="Type de service"
          value={form.service_type}
          onChange={handleChange}
        />
        <textarea
          className="w-full border p-2 rounded"
          name="script_refs"
          rows="3"
          placeholder='Références de scripts (JSON)'
          value={form.script_refs}
          onChange={handleChange}
        />
        <input
          className="w-full border p-2 rounded"
          name="template_name"
          placeholder="Nom du template"
          value={form.template_name}
          onChange={handleChange}
        />
        <input
          className="w-full border p-2 rounded"
          name="memory_mb"
          type="number"
          placeholder="Mémoire (MB)"
          value={form.memory_mb}
          onChange={handleChange}
        />
        <input
          className="w-full border p-2 rounded"
          name="vcpu_cores"
          type="number"
          placeholder="vCPU Cores"
          value={form.vcpu_cores}
          onChange={handleChange}
        />
        <input
          className="w-full border p-2 rounded"
          name="vcpu_sockets"
          type="number"
          placeholder="vCPU Sockets"
          value={form.vcpu_sockets}
          onChange={handleChange}
        />
        <input
          className="w-full border p-2 rounded"
          name="disk_size"
          placeholder="Taille du disque"
          value={form.disk_size}
          onChange={handleChange}
        />
        <label className="flex items-center space-x-2">
          <input
            type="checkbox"
            name="use_static_ip"
            checked={form.use_static_ip}
            onChange={handleChange}
          />
          <span>Utiliser IP statique</span>
        </label>
        <button
          type="submit"
          className="px-4 py-2 bg-blue-600 text-white rounded"
        >
          Déployer
        </button>
      </form>
      {result && (
        <pre className="whitespace-pre-wrap bg-white p-2 rounded border">{result}</pre>
      )}
    </div>
  );
}

