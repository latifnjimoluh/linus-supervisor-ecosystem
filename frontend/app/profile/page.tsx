"use client";

import { useEffect, useState } from "react";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import useAuth from "@/hooks/useAuth";
import { getUserProfile, updateUserProfile } from "@/services/api";
import { useToast } from "@/hooks/use-toast";
import { useErrors } from "@/hooks/use-errors";
import { ErrorBanner } from "@/components/error-banner";

export default function ProfilePage() {
  useAuth("/profile");
  const { toast } = useToast();
  const { setError, clearError } = useErrors();
  const [isLoading, setIsLoading] = useState(true);
  const [userId, setUserId] = useState<number | null>(null);
  const [formData, setFormData] = useState({ first_name: "", last_name: "", email: "" });

  useEffect(() => {
    const fetchProfile = async () => {
      try {
        const data = await getUserProfile();
        setUserId(data.id);
        setFormData({
          first_name: data.first_name || "",
          last_name: data.last_name || "",
          email: data.email || "",
        });
      } catch (err: any) {
        setError("profile", { message: err.message || "Impossible de récupérer le profil." });
      } finally {
        setIsLoading(false);
      }
    };
    fetchProfile();
  }, [toast]);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFormData({ ...formData, [e.target.id]: e.target.value });
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!userId) return;
    try {
      await updateUserProfile(userId, formData);
      clearError("profile");
      toast({ title: "Succès", description: "Profil mis à jour.", variant: "success" });
    } catch (err: any) {
      setError("profile", { message: err.message || "Échec de la mise à jour." });
    }
  };

  if (isLoading) {
    return <div className="p-4">Chargement...</div>;
  }

  return (
    <div className="space-y-6">
      <ErrorBanner id="profile" />
      <div>
        <h1 className="text-3xl font-bold tracking-tight">Mon Profil</h1>
        <p className="text-muted-foreground">Mettez à jour les informations de votre profil personnel.</p>
      </div>
      <Card>
        <CardHeader>
          <CardTitle>Informations du Profil</CardTitle>
          <CardDescription>Modifiez les détails de votre compte.</CardDescription>
        </CardHeader>
        <form onSubmit={handleSubmit}>
          <CardContent className="space-y-4">
            <div className="flex items-center gap-4">
              <Avatar className="h-20 w-20">
                <AvatarImage src="/placeholder-user.jpg" alt="Avatar utilisateur" />
                <AvatarFallback>LS</AvatarFallback>
              </Avatar>
            </div>
            <div className="space-y-2">
              <Label htmlFor="first_name">Prénom</Label>
              <Input id="first_name" value={formData.first_name} onChange={handleChange} />
            </div>
            <div className="space-y-2">
              <Label htmlFor="last_name">Nom</Label>
              <Input id="last_name" value={formData.last_name} onChange={handleChange} />
            </div>
            <div className="space-y-2">
              <Label htmlFor="email">Adresse e-mail</Label>
              <Input id="email" type="email" value={formData.email} onChange={handleChange} />
            </div>
          </CardContent>
          <CardFooter className="border-t px-6 py-4 justify-end gap-2">
            <Button type="submit">Sauvegarder</Button>
          </CardFooter>
        </form>
      </Card>
    </div>
  );
}

