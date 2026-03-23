"use client";

import * as React from "react";
import { X } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogClose,
} from "@/components/ui/dialog";
import { User } from "@/services/users";

interface UserDetailsDialogProps {
  user: User | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  roleLabel: string;
  roleDescription: string;
}

export function UserDetailsDialog({ user, open, onOpenChange, roleLabel, roleDescription }: UserDetailsDialogProps) {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="w-[95vw] max-w-lg sm:max-w-xl rounded-2xl p-6">
        {user && (
          <>
            <DialogHeader className="flex flex-row items-start justify-between">
              <div>
                <DialogTitle className="text-xl font-semibold break-words">
                  {user.first_name} {user.last_name}
                </DialogTitle>
                <DialogDescription className="break-words">
                  {user.email}
                </DialogDescription>
              </div>
              <DialogClose className="rounded-full p-1 hover:bg-muted">
                <X className="h-4 w-4" />
              </DialogClose>
            </DialogHeader>
            <div className="mt-4 space-y-3 text-sm">
              <div className="flex justify-between gap-3">
                <span className="text-muted-foreground">Rôle</span>
                <span className="font-medium text-right break-words">
                  {roleLabel}
                  {roleDescription ? ` - ${roleDescription}` : ""}
                </span>
              </div>
              <div className="flex justify-between gap-3">
                <span className="text-muted-foreground">Statut</span>
                <span className="font-medium">
                  {user.status === "actif" ? "Actif" : "Inactif"}
                </span>
              </div>
              <div className="flex justify-between gap-3">
                <span className="text-muted-foreground">Téléphone</span>
                <span className="font-medium break-words text-right">
                  {user.phone || "—"}
                </span>
              </div>
              <div className="flex justify-between gap-3">
                <span className="text-muted-foreground">Créé le</span>
                <span className="font-medium">
                  {user.created_at
                    ? new Date(user.created_at).toLocaleDateString("fr-FR")
                    : "—"}
                </span>
              </div>
              {user.last_login && (
                <div className="flex justify-between gap-3">
                  <span className="text-muted-foreground">Dernière connexion</span>
                  <span className="font-medium">
                    {new Date(user.last_login).toLocaleDateString("fr-FR")}
                  </span>
                </div>
              )}
            </div>
          </>
        )}
      </DialogContent>
    </Dialog>
  );
}

export default UserDetailsDialog;
