import React from "react"

export interface PanelError {
  message: string
  detailsUrl?: string
}

interface ErrorContextType {
  errors: Record<string, PanelError | undefined>
  setError: (id: string, error: PanelError) => void
  clearError: (id: string) => void
}

const ErrorContext = React.createContext<ErrorContextType | undefined>(undefined)

export function ErrorProvider({ children }: { children: React.ReactNode }) {
  const [errors, setErrors] = React.useState<Record<string, PanelError | undefined>>({})

  const setError = React.useCallback((id: string, error: PanelError) => {
    setErrors(prev => ({ ...prev, [id]: error }))
  }, [])

  const clearError = React.useCallback((id: string) => {
    setErrors(prev => {
      const next = { ...prev }
      delete next[id]
      return next
    })
  }, [])

  const value = React.useMemo(() => ({ errors, setError, clearError }), [errors, setError, clearError])

  return <ErrorContext.Provider value={value}>{children}</ErrorContext.Provider>
}

export function useErrors() {
  const ctx = React.useContext(ErrorContext)
  if (!ctx) throw new Error("useErrors must be used within ErrorProvider")
  return ctx
}
