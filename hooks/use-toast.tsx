"use client"

import * as React from "react"
import { useErrors } from "./use-errors"

type ToastVariant = "default" | "destructive" | "success" | "warning" | "info"

interface Toast {
  id: string
  title: string
  description?: string
  variant?: ToastVariant
  duration?: number
}

interface ToastContextType {
  toasts: Toast[]
  toast: (toast: Omit<Toast, 'id'>) => void
  dismiss: (id: string) => void
}

const ToastContext = React.createContext<ToastContextType | undefined>(undefined)

export function ToastProvider({ children }: { children: React.ReactNode }) {
  const [toasts, setToasts] = React.useState<Toast[]>([])
  const { setError } = useErrors()

  const toast = React.useCallback((newToast: Omit<Toast, 'id'>) => {
    if (newToast.variant === 'destructive') {
      const message = newToast.description ? `${newToast.title}: ${newToast.description}` : newToast.title
      setError('global', { message, detailsUrl: '/logs' })
      return
    }

    const id = Math.random().toString(36).substring(2, 9)
    const toastWithId = { id, ...newToast }

    setToasts(prev => [...prev, toastWithId])

    // Auto dismiss after duration
    const duration = newToast.duration || 5000
    setTimeout(() => {
      setToasts(prev => prev.filter(t => t.id !== id))
    }, duration)
  }, [setError])

  const dismiss = React.useCallback((id: string) => {
    setToasts(prev => prev.filter(t => t.id !== id))
  }, [])

  return (
    <ToastContext.Provider value={{ toasts, toast, dismiss }}>
      {children}
      <ToastContainer toasts={toasts} onDismiss={dismiss} />
    </ToastContext.Provider>
  )
}

export function useToast() {
  const context = React.useContext(ToastContext)
  if (!context) {
    throw new Error('useToast must be used within a ToastProvider')
  }
  return context
}

// Toast Container Component
function ToastContainer({ toasts, onDismiss }: { toasts: Toast[], onDismiss: (id: string) => void }) {
  if (toasts.length === 0) return null

  return (
    <div className="fixed bottom-4 right-4 z-50 space-y-2">
      {toasts.map((toast) => (
        <div
          key={toast.id}
          className={`
            p-4 rounded-xl shadow-lg border max-w-sm
            ${toast.variant === 'success' ? 'bg-success text-success-foreground border-success' : ''}
            ${toast.variant === 'destructive' ? 'bg-destructive text-destructive-foreground border-destructive' : ''}
            ${toast.variant === 'warning' ? 'bg-warning text-warning-foreground border-warning' : ''}
            ${toast.variant === 'info' ? 'bg-info text-info-foreground border-info' : ''}
            ${!toast.variant || toast.variant === 'default' ? 'bg-background text-foreground border-border' : ''}
          `}
        >
          <div className="flex justify-between items-start">
            <div>
              <div className="font-medium">{toast.title}</div>
              {toast.description && (
                <div className="text-sm opacity-90 mt-1">{toast.description}</div>
              )}
            </div>
            <button
              onClick={() => onDismiss(toast.id)}
              className="ml-2 opacity-70 hover:opacity-100"
            >
              ×
            </button>
          </div>
        </div>
      ))}
    </div>
  )
}
