import React from 'react';

export default function ConfirmModal({ open, title = 'Confirmation requise', message, onConfirm, onCancel, loading }) {
  if (!open) return null;
  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
      <div className="bg-white p-6 rounded shadow w-full max-w-sm">
        <h2 className="text-lg font-semibold mb-4">{title}</h2>
        <p className="mb-4">{message}</p>
        <div className="flex justify-end space-x-2">
          <button
            onClick={onCancel}
            className="px-4 py-2 rounded border"
            disabled={loading}
          >
            Annuler
          </button>
          <button
            onClick={onConfirm}
            className="px-4 py-2 rounded bg-red-600 text-white disabled:opacity-50"
            disabled={loading}
          >
            {loading ? '...' : 'Confirmer'}
          </button>
        </div>
      </div>
    </div>
  );
}
