import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";
import { BackButton } from "@/components/back-button";

// This page is mostly static; revalidate once per hour
export const revalidate = 3600;

export default function GuidePage() {
  return (
    <div className="space-y-6">
      <div className="flex items-center gap-4">
        <BackButton href="/dashboard" />
        <h1 className="text-3xl font-bold">Mode d'emploi</h1>
      </div>
      <p className="text-muted-foreground">
        Suivez ce guide interactif pour apprendre à utiliser l'assistant IA intégré.
      </p>
      <Accordion type="single" collapsible className="w-full">
        <AccordionItem value="step-1">
          <AccordionTrigger>Ouvrir le chat</AccordionTrigger>
          <AccordionContent>
            Cliquez sur le bouton circulaire en bas à droite de l'écran pour afficher la fenêtre de chat.
          </AccordionContent>
        </AccordionItem>
        <AccordionItem value="step-2">
          <AccordionTrigger>Envoyer un message</AccordionTrigger>
          <AccordionContent>
            Saisissez votre question dans le champ de saisie puis appuyez sur Entrée ou sur l'icône d'envoi.
          </AccordionContent>
        </AccordionItem>
        <AccordionItem value="step-3">
          <AccordionTrigger>Agrandir le panneau</AccordionTrigger>
          <AccordionContent>
            Utilisez l'icône d'agrandissement pour passer en mode plein écran et profiter d'un espace de conversation plus confortable.
          </AccordionContent>
        </AccordionItem>
        <AccordionItem value="step-4">
          <AccordionTrigger>Fermer ou réduire</AccordionTrigger>
          <AccordionContent>
            Cliquez sur la croix pour fermer le chat ou sur l'icône de réduction pour revenir au mode docké.
          </AccordionContent>
        </AccordionItem>
      </Accordion>
    </div>
  )
}
