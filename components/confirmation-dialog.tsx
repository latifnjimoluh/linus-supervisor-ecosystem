"use client"

import * as React from "react"
import { AlertTriangle, Loader2 } from 'lucide-react'

import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { useToast } from "@/hooks/use-toast"

interface ConfirmationDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  title: string
  description: string
  confirmText?: string
  cancelText?: string
  variant?: "default" | "destructive"
  requireConfirmation?: boolean
  confirmationText?: string
  onConfirm: () => Promise<void> | void
  loading?: boolean
}

export function ConfirmationDialog({
  open,
  onOpenChange,
  title,
  description,
  confirmText = "Confirmer",
  cancelText = "Annuler",
  variant = "default",
  requireConfirmation = false,
  confirmationText = "CONFIRMER",
  onConfirm,
  loading = false
}: ConfirmationDialogProps) {
  const [confirmationInput, setConfirmationInput] = React.useState("")
  const { toast } = useToast()

  const handleConfirm = async () => {
    if (requireConfirmation && confirmationInput !== confirmationText) {
      toast({
        title: "Confirmation incorrecte",
        description: `Veuillez saisir "${confirmationText}" pour confirmer`,
        variant: "destructive",
      })
      return
    }

    try {
      await onConfirm()
      onOpenChange(false)
      setConfirmationInput("")
    } catch (error) {
      console.error("Confirmation action failed:", error)
      toast({
        title: "Erreur",
        description: "Une erreur est survenue lors de l'exécution de l'action",
        variant: "destructive",
      })
    }
  }

  const isConfirmDisabled = loading || (requireConfirmation && confirmationInput !== confirmationText)

  return (
    <AlertDialog open={open} onOpenChange={onOpenChange}>
      <AlertDialogContent>
        <AlertDialogHeader>
          <AlertDialogTitle className="flex items-center gap-2">
            <AlertTriangle className={`h-5 w-5 ${variant === 'destructive' ? 'text-destructive' : 'text-warning'}`} />
            {title}
          </AlertDialogTitle>
          <AlertDialogDescription className="text-left">
            {description}
          </AlertDialogDescription>
        </AlertDialogHeader>

        {requireConfirmation && (
          <div className="space-y-2">
            <Label htmlFor="confirmation">
              Pour confirmer, saisissez <strong>{confirmationText}</strong> :
            </Label>
            <Input
              id="confirmation"
              value={confirmationInput}
              onChange={(e) => setConfirmationInput(e.target.value)}
              placeholder={confirmationText}
              disabled={loading}
            />
          </div>
        )}

        <AlertDialogFooter>
          <AlertDialogCancel disabled={loading}>
            {cancelText}
          </AlertDialogCancel>
          <AlertDialogAction
            onClick={handleConfirm}
            disabled={isConfirmDisabled}
            className={variant === 'destructive' ? 'bg-destructive text-destructive-foreground hover:bg-destructive/90' : ''}
          >
            {loading ? (
              <Loader2 className="mr-2 h-4 w-4 animate-spin" />
            ) : null}
            {confirmText}
          </AlertDialogAction>
        </AlertDialogFooter>
      </AlertDialogContent>
    </AlertDialog>
  )
}
