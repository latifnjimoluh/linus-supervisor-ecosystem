import React, { useState } from 'react';
import {
  analyzeScript,
  explainScript,
  explainVariables,
  summarizeLogs,
  bundleSuggestion,
  simulateScript,
} from '../api/ai';

export default function AiTools() {
  const [script, setScript] = useState('');
  const [template, setTemplate] = useState('');
  const [logs, setLogs] = useState('');
  const [needs, setNeeds] = useState('');
  const [analysis, setAnalysis] = useState('');
  const [explanation, setExplanation] = useState('');
  const [variables, setVariables] = useState('');
  const [summary, setSummary] = useState('');
  const [bundle, setBundle] = useState('');
  const [simulation, setSimulation] = useState('');
  const [error, setError] = useState('');

  const handle = async (fn, setter, arg) => {
    setError('');
    try {
      const res = await fn(arg);
      const data = res.data?.data || res.data;
      setter(data);
    } catch (err) {
      const message = err.response?.data?.message || 'Erreur requête';
      setError(message);
    }
  };

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Outils IA</h1>
      {error && <p className="text-red-500">{error}</p>}

      <section className="space-y-2">
        <h2 className="font-semibold">Analyse / Explication de script</h2>
        <textarea
          className="w-full border p-2 rounded"
          rows="4"
          value={script}
          onChange={(e) => setScript(e.target.value)}
          placeholder="#!/bin/bash..."
        />
        <div className="flex space-x-2">
          <button
            onClick={() => handle(analyzeScript, setAnalysis, script)}
            className="px-4 py-2 bg-blue-600 text-white rounded"
          >
            Analyser
          </button>
          <button
            onClick={() => handle(explainScript, setExplanation, script)}
            className="px-4 py-2 bg-blue-600 text-white rounded"
          >
            Expliquer
          </button>
          <button
            onClick={() => handle(simulateScript, setSimulation, script)}
            className="px-4 py-2 bg-blue-600 text-white rounded"
          >
            Simuler
          </button>
        </div>
        {analysis && (
          <pre className="whitespace-pre-wrap bg-white p-2 rounded border">{analysis}</pre>
        )}
        {explanation && (
          <pre className="whitespace-pre-wrap bg-white p-2 rounded border">{explanation}</pre>
        )}
        {simulation && (
          <pre className="whitespace-pre-wrap bg-white p-2 rounded border">{simulation}</pre>
        )}
      </section>

      <section className="space-y-2">
        <h2 className="font-semibold">Variables d'un template</h2>
        <textarea
          className="w-full border p-2 rounded"
          rows="4"
          value={template}
          onChange={(e) => setTemplate(e.target.value)}
          placeholder="Template avec variables"
        />
        <button
          onClick={() => handle(explainVariables, setVariables, template)}
          className="px-4 py-2 bg-blue-600 text-white rounded"
        >
          Expliquer les variables
        </button>
        {variables && (
          <pre className="whitespace-pre-wrap bg-white p-2 rounded border">{variables}</pre>
        )}
      </section>

      <section className="space-y-2">
        <h2 className="font-semibold">Résumé de logs</h2>
        <textarea
          className="w-full border p-2 rounded"
          rows="4"
          value={logs}
          onChange={(e) => setLogs(e.target.value)}
          placeholder="Logs à résumer"
        />
        <button
          onClick={() => handle(summarizeLogs, setSummary, logs)}
          className="px-4 py-2 bg-blue-600 text-white rounded"
        >
          Résumer
        </button>
        {summary && (
          <pre className="whitespace-pre-wrap bg-white p-2 rounded border">{summary}</pre>
        )}
      </section>

      <section className="space-y-2">
        <h2 className="font-semibold">Suggestion de bundle</h2>
        <input
          className="w-full border p-2 rounded"
          value={needs}
          onChange={(e) => setNeeds(e.target.value)}
          placeholder="Besoins"
        />
        <button
          onClick={() => handle(bundleSuggestion, setBundle, needs)}
          className="px-4 py-2 bg-blue-600 text-white rounded"
        >
          Suggérer
        </button>
        {bundle && (
          <pre className="whitespace-pre-wrap bg-white p-2 rounded border">{bundle}</pre>
        )}
      </section>
    </div>
  );
}

