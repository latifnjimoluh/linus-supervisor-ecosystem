"use client"

import * as React from "react"
import { Server, Plus, Cpu, MemoryStick, AlertTriangle, HardDrive, Network, FileJson, ChevronDown, ChevronUp, Copy, Check, X } from 'lucide-react'
import { useForm, Controller } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import * as z from "zod"
import { AnimatePresence, motion } from "framer-motion"
import { useRouter } from "next/navigation"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Switch } from "@/components/ui/switch"
import { Slider } from "@/components/ui/slider"
import { useToast } from "@/hooks/use-toast"
import { cn } from "@/lib/utils"
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover"
import { Command, CommandEmpty, CommandGroup, CommandInput, CommandItem } from "@/components/ui/command"
import { Checkbox } from "@/components/ui/checkbox"
import { runDeployment } from "@/services/terraform"
import { getGeneratedScripts, getServiceTypes, ScriptGroup } from "@/services/scripts"

// Schema de validation avec Zod
const deploymentSchema = z.object({
  vm_names: z.string().min(1, "Le nom de la VM est requis."),
  service_type: z.string().min(1, "Le type de service est requis."),
  zone: z.enum(["LAN", "DMZ", "WAN", "MGMT"]),
  script_refs: z.array(z.object({ type: z.enum(["script", "template"]), id: z.number() })).optional(),
  template_name: z.string().min(1, "Un template est requis."),
  memory_mb: z.number().min(512, "Minimum 512 Mo de RAM requis."),
  vcpu_cores: z.number().min(1, "Minimum 1 coeur requis."),
  vcpu_sockets: z.number().min(1, "Minimum 1 socket requis."),
  disk_size: z.number().min(10, "Minimum 10 Go de disque requis."),
  use_static_ip: z.boolean(),
  static_ip: z.string().optional(),
  gateway: z.string().optional(),
}).refine(data => !data.use_static_ip || (data.use_static_ip && data.static_ip), {
  message: "L'adresse IP est requise si l'IP statique est activée.",
  path: ["static_ip"],
});

type DeploymentFormData = z.infer<typeof deploymentSchema>;

export default function DeployPage() {
  const { toast } = useToast();
  const router = useRouter();
  const [isSubmitting, setIsSubmitting] = React.useState(false);
  const [showTfvars, setShowTfvars] = React.useState(false);
  const [copied, setCopied] = React.useState(false);
  const [serviceTypes, setServiceTypes] = React.useState<string[]>([]);
  const [scriptGroups, setScriptGroups] = React.useState<ScriptGroup[]>([]);

  const { register, handleSubmit, control, watch, setValue, formState: { errors, isValid } } = useForm<DeploymentFormData>({
    resolver: zodResolver(deploymentSchema),
    mode: "onChange",
    defaultValues: {
      memory_mb: 2048,
      vcpu_cores: 2,
      vcpu_sockets: 1,
      disk_size: 20,
      use_static_ip: false,
      script_refs: [],
      zone: "LAN",
    },
  });

  const formData = watch();

  const scriptMap = React.useMemo(() => {
    const map = new Map<number, { name: string }>();
    scriptGroups.forEach(group => {
      group.scripts.forEach(s => {
        const name = s.script_path.split('/').pop() || `script_${s.id}`;
        map.set(s.id, { name });
      });
    });
    return map;
    }, [scriptGroups]);

  React.useEffect(() => {
    Promise.all([getServiceTypes(), getGeneratedScripts()]).then(([types, scripts]) => {
      setServiceTypes(types);
      setScriptGroups(scripts);
    });
  }, []);

  const onSubmit = async (data: DeploymentFormData) => {
    setIsSubmitting(true);
    toast({
      title: "Déploiement en cours...",
      description: `Lancement du déploiement pour ${data.vm_names}.`,
      variant: "info",
    });

    try {
      const payload = {
        vm_names: data.vm_names.split(",").map((n) => n.trim()),
        service_type: data.service_type,
        zone: data.zone,
        script_refs: data.script_refs,
        template_name: data.template_name,
        memory_mb: data.memory_mb,
        vcpu_cores: data.vcpu_cores,
        vcpu_sockets: data.vcpu_sockets,
        disk_size: `${data.disk_size}G`,
        use_static_ip: data.use_static_ip,
        ...(data.use_static_ip ? { static_ip: data.static_ip, gateway: data.gateway } : {}),
      };

      const res = await runDeployment(payload);

      toast({
        title: "Déploiement lancé !",
        description: "Vous allez être redirigé vers la page de suivi.",
        variant: "success",
      });

      router.push(`/deployments/${res.instance_id}`);
    } catch (err: any) {
      toast({
        title: "Erreur de déploiement",
        description: err?.response?.data?.message || err.message,
        variant: "destructive",
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  const generateTfvars = () => {
    const { vm_names, disk_size, script_refs, ...rest } = formData;
    return JSON.stringify({
      vm_names: vm_names?.split(',').map(name => name.trim()),
      disk_size: `${disk_size}G`,
      script_refs: script_refs?.map(ref => ({ type: ref.type, id: ref.id })),
      ...rest,
    }, null, 2);
  };

  const copyTfvars = () => {
    navigator.clipboard.writeText(generateTfvars());
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const aiContext = `Génération de configuration pour un service. Template: ${formData.template_name}, RAM: ${formData.memory_mb}MB, CPU: ${formData.vcpu_cores} coeurs. Service Type: ${formData.service_type}. Scripts: ${formData.script_refs?.map(s => scriptMap.get(s.id)?.name).join(', ') || 'None'}.`;

  return (
    <div className="space-y-6">
      <header>
        <h1 className="text-3xl md:text-4xl font-bold tracking-tight">Créer une Machine Virtuelle</h1>
        <p className="text-muted-foreground mt-2">
          Configurez et déployez vos VMs en quelques clics avec Terraform.
        </p>
      </header>

      <form onSubmit={handleSubmit(onSubmit)} className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Colonne principale du formulaire */}
        <div className="lg:col-span-2 space-y-8">
          <Card className="rounded-2xl shadow-sm">
            <CardHeader>
              <CardTitle className="flex items-center gap-2"><Server className="h-5 w-5" />Informations Générales</CardTitle>
            </CardHeader>
            <CardContent className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <Label htmlFor="vm_names">Nom(s) de la VM</Label>
                <Input id="vm_names" placeholder="web-server-01, db-server-01" {...register("vm_names")} />
                {errors.vm_names && <p className="text-sm text-destructive">{errors.vm_names.message}</p>}
              </div>
              <div className="space-y-2">
                <Label>Template de base</Label>
                <Input
                  id="template_name"
                  placeholder="ubuntu-template"
                  {...register("template_name")}
                />
                {errors.template_name && (
                  <p className="text-sm text-destructive">{errors.template_name.message}</p>
                )}
              </div>
              <div className="space-y-2">
                <Label>Type de Service</Label>
                <Controller
                  name="service_type"
                  control={control}
                  render={({ field }) => (
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <SelectTrigger><SelectValue placeholder="Sélectionner un type de service..." /></SelectTrigger>
                      <SelectContent>
                        {serviceTypes.map(type => <SelectItem key={type} value={type}>{type}</SelectItem>)}
                      </SelectContent>
                    </Select>
                  )}
                />
                {errors.service_type && <p className="text-sm text-destructive">{errors.service_type.message}</p>}
              </div>
              <div className="space-y-2">
                <Label>Zone</Label>
                <Controller
                  name="zone"
                  control={control}
                  render={({ field }) => (
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <SelectTrigger><SelectValue placeholder="Sélectionner une zone" /></SelectTrigger>
                      <SelectContent>
                        {["LAN", "DMZ", "WAN", "MGMT"].map(z => <SelectItem key={z} value={z}>{z}</SelectItem>)}
                      </SelectContent>
                    </Select>
                  )}
                />
                {errors.zone && <p className="text-sm text-destructive">{errors.zone.message}</p>}
              </div>
              <div className="space-y-2">
                <Label>Scripts à exécuter</Label>
                <Controller
                  name="script_refs"
                  control={control}
                  render={({ field }) => (
                    <Popover>
                      <PopoverTrigger asChild>
                        <Button variant="outline" className="w-full justify-between">
                          {field.value && field.value.length > 0
                            ? `${field.value.length} script(s) sélectionné(s)`
                            : "Sélectionner des scripts..."}
                          <ChevronDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                        </Button>
                      </PopoverTrigger>
                      <PopoverContent className="w-[--radix-popover-trigger-width] p-0">
                        <Command>
                          <CommandInput placeholder="Rechercher un script..." />
                          <CommandEmpty>Aucun script trouvé.</CommandEmpty>
                          {scriptGroups.map(group => (
                            <CommandGroup key={group.category} heading={group.category}>
                              {group.scripts.map(script => {
                                const name = script.script_path.split('/').pop() || `script_${script.id}`;
                                const isSelected = field.value?.some(s => s.id === script.id);
                                return (
                                  <CommandItem
                                    key={script.id}
                                    onSelect={() => {
                                      const newSelection = isSelected
                                        ? field.value?.filter(s => s.id !== script.id)
                                        : [...(field.value || []), { type: 'script', id: script.id }];
                                      setValue("script_refs", newSelection);
                                    }}
                                  >
                                    <Checkbox
                                      checked={isSelected}
                                      onCheckedChange={(checked) => {
                                        const newSelection = checked
                                          ? [...(field.value || []), { type: 'script', id: script.id }]
                                          : field.value?.filter(s => s.id !== script.id);
                                        setValue("script_refs", newSelection);
                                      }}
                                      className="mr-2"
                                    />
                                    {name}
                                  </CommandItem>
                                );
                              })}
                            </CommandGroup>
                          ))}
                        </Command>
                      </PopoverContent>
                    </Popover>
                  )}
                />
                {errors.script_refs && <p className="text-sm text-destructive">{errors.script_refs.message}</p>}
              </div>
            </CardContent>
          </Card>

          <Card className="rounded-2xl shadow-sm">
            <CardHeader>
              <CardTitle className="flex items-center gap-2"><Cpu className="h-5 w-5" />Spécifications Techniques</CardTitle>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6 items-center">
                <div className="space-y-2">
                  <Label>Mémoire (RAM)</Label>
                  <Controller
                    name="memory_mb"
                    control={control}
                    render={({ field }) => (
                      <>
                        <Slider defaultValue={[field.value]} min={512} max={16384} step={512} onValueChange={(v) => field.onChange(v[0])} />
                        <div className="text-sm text-muted-foreground text-center">{field.value} Mo</div>
                      </>
                    )}
                  />
                </div>
                <div className="space-y-2">
                  <Label>Disque</Label>
                  <Controller
                    name="disk_size"
                    control={control}
                    render={({ field }) => (
                      <>
                        <Slider defaultValue={[field.value]} min={10} max={500} step={10} onValueChange={(v) => field.onChange(v[0])} />
                        <div className="text-sm text-muted-foreground text-center">{field.value} Go</div>
                      </>
                    )}
                  />
                </div>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-2">
                  <Label>Coeurs vCPU</Label>
                  <Controller
                    name="vcpu_cores"
                    control={control}
                    render={({ field }) => (
                      <Select onValueChange={(v) => field.onChange(Number(v))} defaultValue={String(field.value)}>
                        <SelectTrigger><SelectValue /></SelectTrigger>
                        <SelectContent>{[1, 2, 4, 8, 16].map(c => <SelectItem key={c} value={String(c)}>{c} Coeur(s)</SelectItem>)}</SelectContent>
                      </Select>
                    )}
                  />
                </div>
                <div className="space-y-2">
                  <Label>Sockets vCPU</Label>
                  <Controller
                    name="vcpu_sockets"
                    control={control}
                    render={({ field }) => (
                      <Select onValueChange={(v) => field.onChange(Number(v))} defaultValue={String(field.value)}>
                        <SelectTrigger><SelectValue /></SelectTrigger>
                        <SelectContent>{[1, 2, 4].map(s => <SelectItem key={s} value={String(s)}>{s} Socket(s)</SelectItem>)}</SelectContent>
                      </Select>
                    )}
                  />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="rounded-2xl shadow-sm">
            <CardHeader>
              <CardTitle className="flex items-center gap-2"><Network className="h-5 w-5" />Configuration Réseau</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center space-x-2">
                <Controller name="use_static_ip" control={control} render={({ field }) => <Switch id="use_static_ip" checked={field.value} onCheckedChange={field.onChange} />} />
                <Label htmlFor="use_static_ip">Utiliser une IP statique</Label>
              </div>
              <AnimatePresence>
                {formData.use_static_ip && (
                  <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: "auto" }} exit={{ opacity: 0, height: 0 }} className="grid grid-cols-1 md:grid-cols-2 gap-6 pt-4 border-t">
                    <div className="space-y-2">
                      <Label htmlFor="static_ip">Adresse IP</Label>
                      <Input id="static_ip" placeholder="192.168.1.100" {...register("static_ip")} />
                      {errors.static_ip && <p className="text-sm text-destructive">{errors.static_ip.message}</p>}
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="gateway">Passerelle</Label>
                      <Input id="gateway" placeholder="192.168.1.1" {...register("gateway")} />
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </CardContent>
          </Card>
        </div>

        {/* Colonne latérale pour actions et aperçu */}
        <div className="lg:col-span-1 space-y-6">
          {/* Removed sticky positioning for better responsiveness */}
          <Card className="rounded-2xl shadow-sm">
            <CardHeader>
              <CardTitle>Actions</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <Button type="submit" className="w-full" disabled={!isValid || isSubmitting}>
                {isSubmitting ? "Déploiement en cours..." : "Lancer le déploiement"}
              </Button>
              <AssistantAIBlock
                title="Suggestion IA"
                context={aiContext}
                onAnalyze={async () => {
                  await new Promise((r) => setTimeout(r, 500));

                  const form = document.querySelector("form");
                  const fields = form ? form.querySelectorAll("input, select, textarea") : [];
                  const filled = Array.from(fields).filter((el) => {
                    if (el instanceof HTMLInputElement || el instanceof HTMLSelectElement || el instanceof HTMLTextAreaElement) {
                      return !!el.value;
                    }
                    return false;
                  });

                  const suggestions: string[] = [];
                  if (formData.memory_mb < 4096) {
                    suggestions.push("Envisagez au moins 4096Mo de RAM pour de meilleures performances.");
                  }
                  if (formData.vcpu_cores < 4) {
                    suggestions.push("4 coeurs CPU sont recommandés pour ce type de service.");
                  }
                  if (!formData.service_type) {
                    suggestions.push("Le type de service n'est pas défini.");
                  }

                  return `Le formulaire contient ${fields.length} champ(s), dont ${filled.length} rempli(s). ` +
                    `Configuration actuelle : ${formData.memory_mb}Mo de RAM, ${formData.vcpu_cores} coeur(s) CPU, disque ${formData.disk_size}Go.` +
                    (suggestions.length ? "\n\n" + suggestions.join(" ") : "\n\nLa configuration semble adéquate.");
                }}
              />
            </CardContent>
          </Card>

          <Card className="rounded-2xl shadow-sm">
            <CardHeader className="cursor-pointer" onClick={() => setShowTfvars(!showTfvars)}>
              <div className="flex justify-between items-center">
                <CardTitle className="flex items-center gap-2"><FileJson className="h-5 w-5" />Aperçu .tfvars.json</CardTitle>
                {showTfvars ? <ChevronUp /> : <ChevronDown />}
              </div>
            </CardHeader>
            <AnimatePresence>
              {showTfvars && (
                <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: "auto" }} exit={{ opacity: 0, height: 0 }}>
                  <CardContent>
                    <div className="relative bg-muted rounded-lg p-4">
                      <Button size="sm" variant="ghost" className="absolute top-2 right-2 h-7 w-7 p-0" onClick={copyTfvars}>
                        {copied ? <Check className="h-4 w-4 text-green-500" /> : <Copy className="h-4 w-4" />}
                      </Button>
                      <pre className="text-xs whitespace-pre-wrap overflow-auto max-h-60">
                        <code>{generateTfvars()}</code>
                      </pre>
                    </div>
                  </CardContent>
                </motion.div>
              )}
            </AnimatePresence>
          </Card>
        </div>
      </form>
    </div>
  );
}
