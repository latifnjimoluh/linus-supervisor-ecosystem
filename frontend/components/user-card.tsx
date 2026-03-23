"use client";

import * as React from "react";
import Link from "next/link";
import { Eye, Edit, Lock, CheckCircle, XCircle, Trash2, Loader2, Mail, MoreVertical } from "lucide-react";
import { motion } from "framer-motion";

import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from "@/components/ui/alert-dialog";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { User } from "@/services/users";

interface UserCardProps {
  user: User;
  roleLabel: string;
  onView: (id: number) => void;
  onAction: (action: string, userId: number, userEmail: string) => void;
  actionLoading: string | null;
  index: number;
}

export function UserCard({ user, roleLabel, onView, onAction, actionLoading, index }: UserCardProps) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3, delay: index * 0.05 }}
      className="rounded-2xl p-4 shadow-sm dark:ring-1 dark:ring-slate-700/40"
    >
      <div className="flex items-start justify-between gap-2">
        <div className="flex flex-1 items-start gap-4 min-w-0">
          <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-muted">
            <span className="text-sm font-medium">
              {(user.first_name?.[0] ?? "").toUpperCase()}
              {(user.last_name?.[0] ?? "").toUpperCase()}
            </span>
          </div>
          <div className="min-w-0 space-y-1">
            <h4 className="font-medium break-words">
              {user.first_name} {user.last_name}
            </h4>
            <div className="flex flex-wrap items-center gap-2">
              <Badge
                variant={user.status === "actif" ? "success" : "destructive"}
                className="inline-flex items-center px-2.5 py-1 text-xs rounded-md"
              >
                {user.status === "actif" ? "Actif" : "Inactif"}
              </Badge>
              <Badge
                variant="secondary"
                className="inline-flex items-center px-2.5 py-1 text-xs rounded-md"
              >
                {roleLabel}
              </Badge>
            </div>
            <span className="flex items-center gap-1 text-sm text-muted-foreground break-words">
              <Mail className="h-3 w-3" />
              {user.email}
            </span>
            <div className="text-xs text-muted-foreground space-x-4">
              <span>
                {user.created_at
                  ? `Créé le ${new Date(user.created_at).toLocaleDateString("fr-FR")}`
                  : "Date de création inconnue"}
              </span>
              {user.last_login && (
                <span>
                  Dernière connexion: {new Date(user.last_login).toLocaleDateString("fr-FR")}
                </span>
              )}
            </div>
          </div>
        </div>
        <div className="hidden sm:inline-flex items-center gap-2 flex-shrink-0">
          <Button
            variant="ghost"
            size="icon"
            className="h-8 w-8 rounded-full"
            onClick={() => onView(user.id)}
          >
            <Eye className="h-4 w-4" />
          </Button>
          <Button
            asChild
            variant="ghost"
            size="icon"
            className="h-8 w-8 rounded-full"
          >
            <Link href={`/users/${user.id}/edit`}>
              <Edit className="h-4 w-4" />
            </Link>
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="h-8 w-8 rounded-full"
            onClick={() => onAction("reset-password", user.id, user.email)}
            disabled={actionLoading === `reset-password-${user.id}`}
          >
            {actionLoading === `reset-password-${user.id}` ? (
              <Loader2 className="h-4 w-4 animate-spin" />
            ) : (
              <Lock className="h-4 w-4" />
            )}
          </Button>
          <Button
            variant="ghost"
            size="icon"
            className="h-8 w-8 rounded-full"
            onClick={() =>
              onAction(
                user.status === "actif" ? "deactivate" : "activate",
                user.id,
                user.email
              )
            }
            disabled={
              actionLoading ===
              `${user.status === "actif" ? "deactivate" : "activate"}-${user.id}`
            }
          >
            {actionLoading ===
            `${user.status === "actif" ? "deactivate" : "activate"}-${user.id}` ? (
              <Loader2 className="h-4 w-4 animate-spin" />
            ) : user.status === "actif" ? (
              <XCircle className="h-4 w-4" />
            ) : (
              <CheckCircle className="h-4 w-4" />
            )}
          </Button>
          <AlertDialog>
            <AlertDialogTrigger asChild>
              <Button
                variant="ghost"
                size="icon"
                className="h-8 w-8 rounded-full text-destructive hover:text-destructive"
              >
                <Trash2 className="h-4 w-4" />
              </Button>
            </AlertDialogTrigger>
            <AlertDialogContent>
              <AlertDialogHeader>
                <AlertDialogTitle>Supprimer l'utilisateur</AlertDialogTitle>
                <AlertDialogDescription>
                  ⚠️ Cette action est irréversible ! L'utilisateur "{user.first_name} {user.last_name}" ({user.email}) sera définitivement supprimé.
                </AlertDialogDescription>
              </AlertDialogHeader>
              <AlertDialogFooter>
                <AlertDialogCancel>Annuler</AlertDialogCancel>
                <AlertDialogAction
                  onClick={() => onAction("delete", user.id, user.email)}
                  className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
                >
                  Supprimer définitivement
                </AlertDialogAction>
              </AlertDialogFooter>
            </AlertDialogContent>
          </AlertDialog>
        </div>
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" size="icon" className="sm:hidden">
              <MoreVertical className="h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuItem onSelect={() => onView(user.id)}>Voir</DropdownMenuItem>
            <DropdownMenuItem asChild>
              <Link href={`/users/${user.id}/edit`}>Modifier</Link>
            </DropdownMenuItem>
            <DropdownMenuItem onSelect={() => onAction("reset-password", user.id, user.email)}>
              Réinit. mot de passe
            </DropdownMenuItem>
            <DropdownMenuItem
              onSelect={() =>
                onAction(
                  user.status === "actif" ? "deactivate" : "activate",
                  user.id,
                  user.email
                )
              }
            >
              {user.status === "actif" ? "Désactiver" : "Activer"}
            </DropdownMenuItem>
            <DropdownMenuItem
              onSelect={() => onAction("delete", user.id, user.email)}
              className="text-destructive focus:text-destructive"
            >
              Supprimer
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </motion.div>
  );
}

export default UserCard;
