"use client"

import * as React from "react"
import Link from "next/link"
import {
  Server,
  Cpu,
  Network,
  FileJson,
  ChevronDown,
  ChevronUp,
  Copy,
  Check,
} from "lucide-react"
import { useForm, Controller } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import * as z from "zod"
import { AnimatePresence, motion } from "framer-motion"
import { useRouter } from "next/navigation"

import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { Switch } from "@/components/ui/switch"
import { Slider } from "@/components/ui/slider"
import { useToast } from "@/hooks/use-toast"
import { AssistantAIBlock } from "@/components/assistant-ai-block"
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover"
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
} from "@/components/ui/command"
import { Checkbox } from "@/components/ui/checkbox"
import { runDeployment } from "@/services/terraform"
import { getGeneratedScripts, getServiceTypes, ScriptGroup } from "@/services/scripts"
import { listProxmoxTemplates, ProxmoxVM } from "@/services/vms"
import {
  analyzeDeploymentConfig,
  checkDeploymentCapacity,
  fetchDeployment,
  fetchLastDeployment,
} from "@/services/deployments"
import { ErrorMessage } from "@/components/ui/error-message"

// -------------------- Helpers noms VM --------------------
const VM_NAME_REGEX = /^[a-z0-9.-]+$/

const sanitizeVmNames = (input: string): string[] => {
  return input
    .split(",")
    .map((n) =>
      n
        .trim()
        .toLowerCase()
        .replace(/\s+/g, "-")        // espaces -> tirets
        .replace(/[^a-z0-9.-]/g, "-") // tout le reste interdit -> tiret
        .replace(/-+/g, "-")          // compresser ---- -> -
        .replace(/^-+|-+$/g, "")      // trim des tirets
    )
    .filter(Boolean)
}

const allNamesValid = (input: string) => {
  const cleaned = sanitizeVmNames(input)
  return cleaned.length > 0 && cleaned.every((n) => VM_NAME_REGEX.test(n))
}

const clamp = (value: number, min: number, max: number) => {
  if (Number.isNaN(value)) return min
  return Math.min(Math.max(value, min), max)
}

// -------------------- Zod Schema --------------------
const deploymentSchema = z
  .object({
    vm_names: z
      .string()
      .min(1, "Le nom de la VM est requis.")
      .refine((val) => allNamesValid(val), {
        message:
          "Chaque nom doit utiliser uniquement lettres, chiffres, '.' ou '-' (les espaces seront remplacés par '-').",
      }),
    service_type: z.string().min(1, "Le type de service est requis."),
    zone: z.enum(["LAN", "DMZ", "WAN", "MGMT"]),
    script_refs: z
      .array(z.object({ type: z.enum(["script", "template"]), id: z.number() }))
      .optional(),
    template_name: z.string().min(1, "Un template est requis."),
    memory_mb: z.number().min(512, "Minimum 512 Mo de RAM requis."),
    vcpu_cores: z.number().min(1, "Minimum 1 coeur requis."),
    vcpu_sockets: z.number().min(1, "Minimum 1 socket requis."),
    disk_size: z.number().min(10, "Minimum 10 Go de disque requis."),
    use_static_ip: z.boolean(),
    static_ip: z.string().optional(),
    gateway: z.string().optional(),
  })
  .refine(
    (data) => !data.use_static_ip || (data.use_static_ip && data.static_ip),
    {
      message: "L'adresse IP est requise si l'IP statique est activée.",
      path: ["static_ip"],
    }
  )

type DeploymentFormData = z.infer<typeof deploymentSchema>

// -------------------- Page --------------------
export default function DeployPage() {
  const { toast } = useToast()
  const router = useRouter()
  const [isSubmitting, setIsSubmitting] = React.useState(false)
  const [showTfvars, setShowTfvars] = React.useState(false)
  const [copied, setCopied] = React.useState(false)
  const [serviceTypes, setServiceTypes] = React.useState<string[]>([])
  const [scriptGroups, setScriptGroups] = React.useState<ScriptGroup[]>([])
  const [templates, setTemplates] = React.useState<ProxmoxVM[]>([])
  const [capacityInfo, setCapacityInfo] = React.useState<
    | {
        disk: { available: number; requested: number; fits: boolean; suggested: number }
        memory: { available: number; requested: number; fits: boolean; suggested: number }
        cpu: { available: number; requested: number; fits: boolean; suggested: number }
      }
    | null
  >(null)
  const [diskMin, setDiskMin] = React.useState(10)
  const [diskMax, setDiskMax] = React.useState(500)
  const [memMax, setMemMax] = React.useState(16384)
  const [last, setLast] = React.useState<null | { instance_id: string; status: string }>(null)

  const {
    register,
    handleSubmit,
    control,
    watch,
    setValue,
    getValues,
    formState: { errors, isValid },
  } = useForm<DeploymentFormData>({
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
  })

  const formData = watch()

  // scripts map pour l'Aide IA
  const scriptMap = React.useMemo(() => {
    const map = new Map<number, { name: string }>()
    scriptGroups.forEach((group) => {
      group.scripts.forEach((s) => {
        const name = s.script_path.split("/").pop() || `script_${s.id}`
        map.set(s.id, { name })
      })
    })
    return map
  }, [scriptGroups])

  React.useEffect(() => {
    Promise.all([getServiceTypes(), getGeneratedScripts(), listProxmoxTemplates()]).then(
      ([types, scripts, tmpl]) => {
        setServiceTypes(types)
        setScriptGroups(scripts)
        setTemplates(tmpl)
      }
    )
  }, [])

  React.useEffect(() => {
    const load = async () => {
      try {
        const id = typeof window !== "undefined" ? localStorage.getItem("last_instance_id") : null
        if (id) {
          const dep = await fetchDeployment(id)
          setLast({ instance_id: id, status: dep.status })
        } else {
          const dep = await fetchLastDeployment()
          localStorage.setItem("last_instance_id", dep.instance_id)
          setLast({ instance_id: dep.instance_id, status: dep.status })
        }
      } catch {
        /* aucun déploiement */
      }
    }
    load()
  }, [])

  React.useEffect(() => {
    if (!last) return
    if (["success", "failed"].includes(last.status)) return
    const interval = setInterval(async () => {
      try {
        const dep = await fetchDeployment(last.instance_id)
        setLast({ instance_id: last.instance_id, status: dep.status })
      } catch {}
    }, 5000)
    return () => clearInterval(interval)
  }, [last])

  React.useEffect(() => {
    const tmpl = templates.find((t) => t.name === formData.template_name)
    const min = tmpl ? Math.max(Math.floor((tmpl.maxdisk || 0) / 1024 ** 3), 10) : 10
    setDiskMin(min)
    const current = getValues("disk_size")
    if (current < min) {
      setValue("disk_size", min, { shouldValidate: true })
    }
  }, [templates, formData.template_name, getValues, setValue])

  React.useEffect(() => {
    if (capacityInfo) {
      const maxDisk = Math.max(capacityInfo.disk.available, diskMin)
      setDiskMax(maxDisk)
      const d = getValues("disk_size")
      const clampedDisk = clamp(d, diskMin, maxDisk)
      if (clampedDisk !== d) {
        setValue("disk_size", clampedDisk, { shouldValidate: true })
      }

      const maxMem = Math.max(capacityInfo.memory.available, 512)
      setMemMax(maxMem)
      const m = getValues("memory_mb")
      const clampedMem = clamp(m, 512, maxMem)
      if (clampedMem !== m) {
        setValue("memory_mb", clampedMem, { shouldValidate: true })
      }
    }
  }, [capacityInfo, diskMin, getValues, setValue])

  React.useEffect(() => {
    checkDeploymentCapacity(
      formData.disk_size,
      formData.memory_mb,
      formData.vcpu_cores * formData.vcpu_sockets
    )
      .then((info) => {
        setCapacityInfo(info)
        if (!info.disk.fits) {
          setValue("disk_size", info.disk.suggested, { shouldValidate: true })
          toast({
            title: "Espace insuffisant",
            description: `Taille ajustée à ${info.disk.suggested} Go (disponible ${info.disk.available} Go)` ,
            variant: "destructive",
          })
        }
        if (!info.memory.fits) {
          setValue("memory_mb", info.memory.suggested, { shouldValidate: true })
          toast({
            title: "RAM insuffisante",
            description: `RAM ajustée à ${info.memory.suggested} Mo (disponible ${info.memory.available} Mo)`,
            variant: "destructive",
          })
        }
        if (!info.cpu.fits) {
          setValue("vcpu_cores", info.cpu.suggested, { shouldValidate: true })
          setValue("vcpu_sockets", 1, { shouldValidate: true })
          toast({
            title: "CPU insuffisant",
            description: `CPU ajusté à ${info.cpu.suggested} coeurs disponibles`,
            variant: "destructive",
          })
        }
      })
      .catch(() => setCapacityInfo(null))
  }, [
    formData.disk_size,
    formData.memory_mb,
    formData.vcpu_cores,
    formData.vcpu_sockets,
  ])

  // Sanitize à la sortie du champ
  const applySanitizeOnBlur = () => {
    const raw = getValues("vm_names") || ""
    const cleaned = sanitizeVmNames(raw).join(", ")
    if (cleaned && cleaned !== raw) {
      setValue("vm_names", cleaned, { shouldValidate: true })
      toast({
        title: "Noms normalisés",
        description: `Les noms ont été ajustés: ${cleaned}`,
      })
    }
  }

  const onSubmit = async (data: DeploymentFormData) => {
    if (
      !capacityInfo ||
      !capacityInfo.disk.fits ||
      !capacityInfo.memory.fits ||
      !capacityInfo.cpu.fits
    ) {
      toast({
        title: "Capacité insuffisante",
        description: "Veuillez ajuster les ressources avant de déployer.",
        variant: "destructive",
      })
      return
    }

    setIsSubmitting(true)
    toast({
      title: "Déploiement en cours...",
      description: `Lancement du déploiement pour ${data.vm_names}.`,
      variant: "info",
    })

    try {
      const cleaned = sanitizeVmNames(data.vm_names)
      const joinedClean = cleaned.join(", ")
      if (joinedClean !== data.vm_names) {
        toast({
          title: "Noms normalisés",
          description: `Les noms ont été ajustés: ${joinedClean}`,
        })
      }

      const payload = {
        vm_names: cleaned,
        service_type: data.service_type,
        zone: data.zone,
        script_refs: data.script_refs,
        template_name: data.template_name,
        memory_mb: data.memory_mb,
        vcpu_cores: data.vcpu_cores,
        vcpu_sockets: data.vcpu_sockets,
        disk_size: `${data.disk_size}G`,
        use_static_ip: data.use_static_ip,
        ...(data.use_static_ip
          ? { static_ip: data.static_ip, gateway: data.gateway }
          : {}),
      }

      const res = await runDeployment(payload)

      toast({
        title: "Déploiement lancé !",
        description: "Vous allez être redirigé vers la page de suivi.",
        variant: "success",
      })

      if (typeof window !== "undefined") {
        localStorage.setItem("last_instance_id", res.instance_id)
      }
      router.push(`/deployments/${res.instance_id}`)
    } catch (err: any) {
      toast({
        title: "Erreur de déploiement",
        description: err?.response?.data?.message || err.message,
        variant: "destructive",
      })
    } finally {
      setIsSubmitting(false)
    }
  }

  const generateTfvars = () => {
    const { vm_names, disk_size, script_refs, ...rest } = formData
    const cleaned = sanitizeVmNames(vm_names || "")
    return JSON.stringify(
      {
        vm_names: cleaned,
        disk_size: `${disk_size}G`,
        script_refs: script_refs?.map((ref: any) => ({
          type: ref.type,
          id: ref.id,
        })),
        ...rest,
      },
      null,
      2
    )
  }

  const copyTfvars = () => {
    navigator.clipboard.writeText(generateTfvars())
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  const aiContext = `Génération de configuration pour un service. Template: ${
    formData.template_name
  }, RAM: ${formData.memory_mb}MB, CPU: ${
    formData.vcpu_cores
  } coeurs, Disque: ${formData.disk_size}Go. Service Type: ${formData.service_type}. Scripts: ${
    formData.script_refs?.map((s: any) => scriptMap.get(s.id)?.name).join(", ") ||
    "None"
  }.`

  return (
    <div className="flex h-full flex-col overflow-hidden">
      <header className="sticky top-0 z-10 bg-background pb-4">
        <div className="flex flex-wrap items-center justify-between gap-4">
          <div>
            <h1 className="text-3xl md:text-4xl font-bold tracking-tight">
              Créer une Machine Virtuelle
            </h1>
            <p className="text-muted-foreground mt-2">
              Configurez et déployez vos VMs en quelques clics avec Terraform.
            </p>
          </div>
          {last && (
            <Link href={`/deployments/${last.instance_id}`}>
              <Button variant="outline" className="flex items-center gap-2">
                Reprendre dernier déploiement
                {(last.status === "success") ? (
                  <Badge variant="success">Terminé</Badge>
                ) : last.status === "failed" ? (
                  <Badge variant="destructive">Échec</Badge>
                ) : (
                  <span className="flex items-center gap-1 text-sm text-muted-foreground">
                    <span className="h-2 w-2 rounded-full bg-orange-500 animate-pulse" /> En cours…
                  </span>
                )}
              </Button>
            </Link>
          )}
        </div>
      </header>

      <div className="flex-1 overflow-auto mt-6">
        {/* Grille responsive renforcée */}
        <form
          onSubmit={handleSubmit(onSubmit)}
          className="grid grid-cols-1 lg:grid-cols-3 gap-6 lg:gap-8 items-start"
        >
        {/* Colonne principale du formulaire */}
        <div className="lg:col-span-2 space-y-8 min-w-0">
          <Card className="rounded-2xl shadow-sm overflow-hidden">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Server className="h-5 w-5" />
                Informations Générales
              </CardTitle>
            </CardHeader>
            <CardContent className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="space-y-2">
                <Label htmlFor="vm_names">Nom(s) de la VM</Label>
                <Input
                  id="vm_names"
                  placeholder="web-server-01, db-server-01"
                  {...register("vm_names")}
                  onBlur={applySanitizeOnBlur}
                />
                <p className="text-xs text-muted-foreground">
                  Caractères autorisés : a–z, 0–9, « - », « . ». Les espaces et
                  caractères spéciaux seront remplacés automatiquement.
                </p>
                {errors.vm_names && (
                  <ErrorMessage>{errors.vm_names.message}</ErrorMessage>
                )}
              </div>

              <div className="space-y-2">
                <Label>Template de base</Label>
                <Controller
                  name="template_name"
                  control={control}
                  render={({ field }) => (
                    <Select onValueChange={field.onChange} value={field.value}>
                      <SelectTrigger>
                        <SelectValue placeholder="Sélectionner un template" />
                      </SelectTrigger>
                      <SelectContent className="min-w-[12rem] max-h-60">
                        {templates.map((t) => (
                          <SelectItem key={t.vmid} value={t.name}>
                            {t.name}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  )}
                />
                {errors.template_name && (
                  <ErrorMessage>{errors.template_name.message}</ErrorMessage>
                )}
              </div>

              <div className="space-y-2">
                <Label>Type de Service</Label>
                <Controller
                  name="service_type"
                  control={control}
                  render={({ field }) => (
                    <Select
                      onValueChange={field.onChange}
                      defaultValue={field.value}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Sélectionner un type de service..." />
                      </SelectTrigger>
                      <SelectContent className="min-w-[12rem]">
                        {serviceTypes.map((type) => (
                          <SelectItem key={type} value={type}>
                            {type}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  )}
                />
                {errors.service_type && (
                  <ErrorMessage>{errors.service_type.message}</ErrorMessage>
                )}
              </div>

              <div className="space-y-2">
                <Label>Zone</Label>
                <Controller
                  name="zone"
                  control={control}
                  render={({ field }) => (
                    <Select
                      onValueChange={field.onChange}
                      defaultValue={field.value}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Sélectionner une zone" />
                      </SelectTrigger>
                      <SelectContent className="min-w-[12rem]">
                        {["LAN", "DMZ", "WAN", "MGMT"].map((z) => (
                          <SelectItem key={z} value={z}>
                            {z}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  )}
                />
                {errors.zone && (
                  <ErrorMessage>{errors.zone.message}</ErrorMessage>
                )}
              </div>

              <div className="space-y-2 md:col-span-2">
                <Label>Scripts à exécuter</Label>
                <Controller
                  name="script_refs"
                  control={control}
                  render={({ field }) => (
                    <Popover>
                      <PopoverTrigger asChild>
                        <Button
                          variant="outline"
                          className="w-full justify-between"
                        >
                          {field.value && field.value.length > 0
                            ? `${field.value.length} script(s) sélectionné(s)`
                            : "Sélectionner des scripts..."}
                          <ChevronDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />
                        </Button>
                      </PopoverTrigger>
                      <PopoverContent
                        align="start"
                        sideOffset={8}
                        className="w-[min(36rem,90vw)] p-0"
                      >
                        <Command>
                          <CommandInput placeholder="Rechercher un script..." />
                          <CommandEmpty>Aucun script trouvé.</CommandEmpty>
                          {scriptGroups.map((group) => (
                            <CommandGroup
                              key={group.category}
                              heading={group.category}
                            >
                              {group.scripts.map((script) => {
                                const name =
                                  script.script_path.split("/").pop() ||
                                  `script_${script.id}`
                                const isSelected = field.value?.some(
                                  (s) => s.id === script.id
                                )
                                return (
                                  <CommandItem
                                    key={script.id}
                                    onSelect={() => {
                                      const newSelection = isSelected
                                        ? field.value?.filter(
                                            (s) => s.id !== script.id
                                          )
                                        : [
                                            ...(field.value || []),
                                            { type: "script", id: script.id },
                                          ]
                                      setValue("script_refs", newSelection, {
                                        shouldValidate: true,
                                      })
                                    }}
                                  >
                                    <Checkbox
                                      checked={isSelected}
                                      onCheckedChange={(checked) => {
                                        const newSelection = checked
                                          ? [
                                              ...(field.value || []),
                                              {
                                                type: "script",
                                                id: script.id,
                                              },
                                            ]
                                          : field.value?.filter(
                                              (s) => s.id !== script.id
                                            )
                                        setValue("script_refs", newSelection, {
                                          shouldValidate: true,
                                        })
                                      }}
                                      className="mr-2"
                                    />
                                    {name}
                                  </CommandItem>
                                )
                              })}
                            </CommandGroup>
                          ))}
                        </Command>
                      </PopoverContent>
                    </Popover>
                  )}
                />
                {errors.script_refs && (
                  <ErrorMessage>{errors.script_refs.message}</ErrorMessage>
                )}
              </div>
            </CardContent>
          </Card>

          <Card className="rounded-2xl shadow-sm overflow-hidden">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Cpu className="h-5 w-5" />
                Spécifications Techniques
              </CardTitle>
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
                        <div className="flex items-center gap-2">
                          <Input
                            type="number"
                            className="w-24"
                            value={field.value}
                            min={512}
                            max={memMax}
                            step={512}
                            onChange={(e) => {
                              const val = Math.round(Number(e.target.value) / 512) * 512
                              field.onChange(clamp(val, 512, memMax))
                            }}
                          />
                          <Slider
                            value={[field.value]}
                            min={512}
                            max={memMax}
                            step={512}
                            onValueChange={(v) => field.onChange(v[0])}
                          />
                        </div>
                        <div className="text-sm text-muted-foreground text-center">
                          {field.value} Mo
                        </div>
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
                        <div className="flex items-center gap-2">
                          <Input
                            type="number"
                            className="w-24"
                            value={field.value}
                            min={diskMin}
                            max={diskMax}
                            step={10}
                            onChange={(e) => {
                              const val = Math.round(Number(e.target.value) / 10) * 10
                              field.onChange(clamp(val, diskMin, diskMax))
                            }}
                          />
                          <Slider
                            value={[field.value]}
                            min={diskMin}
                            max={diskMax}
                            step={10}
                            onValueChange={(v) => field.onChange(v[0])}
                          />
                        </div>
                        <div className="text-sm text-muted-foreground text-center">
                          {field.value} Go
                        </div>
                        {capacityInfo && (
                          <p className="text-xs text-muted-foreground text-center mt-1">
                            Espace disponible : {capacityInfo.disk.available} Go – Taille demandée : {capacityInfo.disk.requested} Go
                          </p>
                        )}
                        {capacityInfo && !capacityInfo.disk.fits && (
                          <ErrorMessage className="flex-wrap justify-center mt-1">
                            <span>Espace insuffisant.</span>
                            <Button
                              variant="link"
                              type="button"
                              onClick={() => setValue('disk_size', capacityInfo.disk.suggested)}
                              className="px-1"
                            >
                              Utiliser {capacityInfo.disk.suggested} Go
                            </Button>
                          </ErrorMessage>
                        )}
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
                      <Select
                        onValueChange={(v) => field.onChange(Number(v))}
                        defaultValue={String(field.value)}
                      >
                        <SelectTrigger>
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          {[1, 2, 4, 8, 16].map((c) => (
                            <SelectItem key={c} value={String(c)}>
                              {c} Coeur(s)
                            </SelectItem>
                          ))}
                        </SelectContent>
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
                      <Select
                        onValueChange={(v) => field.onChange(Number(v))}
                        defaultValue={String(field.value)}
                      >
                        <SelectTrigger>
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          {[1, 2, 4].map((s) => (
                            <SelectItem key={s} value={String(s)}>
                              {s} Socket(s)
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    )}
                  />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="rounded-2xl shadow-sm overflow-hidden">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Network className="h-5 w-5" />
                Configuration Réseau
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center space-x-2">
                <Controller
                  name="use_static_ip"
                  control={control}
                  render={({ field }) => (
                    <Switch
                      id="use_static_ip"
                      checked={field.value}
                      onCheckedChange={field.onChange}
                    />
                  )}
                />
                <Label htmlFor="use_static_ip">Utiliser une IP statique</Label>
              </div>
              <AnimatePresence>
                {formData.use_static_ip && (
                  <motion.div
                    initial={{ opacity: 0, height: 0 }}
                    animate={{ opacity: 1, height: "auto" }}
                    exit={{ opacity: 0, height: 0 }}
                    className="grid grid-cols-1 md:grid-cols-2 gap-6 pt-4 border-t"
                  >
                    <div className="space-y-2">
                      <Label htmlFor="static_ip">Adresse IP</Label>
                      <Input
                        id="static_ip"
                        placeholder="192.168.1.100"
                        {...register("static_ip")}
                      />
                      {errors.static_ip && (
                        <ErrorMessage>{errors.static_ip.message}</ErrorMessage>
                      )}
                    </div>
                    <div className="space-y-2">
                      <Label htmlFor="gateway">Passerelle</Label>
                      <Input
                        id="gateway"
                        placeholder="192.168.1.1"
                        {...register("gateway")}
                      />
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </CardContent>
          </Card>
        </div>

        {/* Colonne latérale */}
        <div className="lg:col-span-1 space-y-6 min-w-0 lg:sticky lg:top-0">
          <Card className="rounded-2xl shadow-sm overflow-hidden">
            <CardHeader>
              <CardTitle>Actions</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <Button
                type="submit"
                className="w-full"
                disabled={
                  !isValid ||
                  isSubmitting ||
                  (capacityInfo &&
                    (!capacityInfo.disk.fits ||
                      !capacityInfo.memory.fits ||
                      !capacityInfo.cpu.fits))
                }
              >
                {isSubmitting ? "Déploiement en cours..." : "Lancer le déploiement"}
              </Button>

              <div className="min-w-0">
                <AssistantAIBlock
                  title="Suggestion IA"
                  context={aiContext}
                  onAnalyze={async () => {
                    const config = {
                      vm_names: sanitizeVmNames(formData.vm_names || ""),
                      template_name: formData.template_name,
                      service_type: formData.service_type,
                      memory_mb: formData.memory_mb,
                      vcpu_cores: formData.vcpu_cores,
                      vcpu_sockets: formData.vcpu_sockets,
                      disk_size: formData.disk_size,
                      scripts:
                        formData.script_refs?.map((s: any) => scriptMap.get(s.id)?.name) || [],
                    }
                    const { analysis } = await analyzeDeploymentConfig(config)
                    return analysis
                  }}
                />
              </div>
            </CardContent>
          </Card>

          <Card className="rounded-2xl shadow-sm overflow-hidden">
            <CardHeader
              className="cursor-pointer"
              onClick={() => setShowTfvars(!showTfvars)}
            >
              <div className="flex justify-between items-center">
                <CardTitle className="flex items-center gap-2">
                  <FileJson className="h-5 w-5" />
                  Aperçu .tfvars.json
                </CardTitle>
                {showTfvars ? <ChevronUp /> : <ChevronDown />}
              </div>
            </CardHeader>
            <AnimatePresence>
              {showTfvars && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: "auto" }}
                  exit={{ opacity: 0, height: 0 }}
                >
                  <CardContent>
                    <div className="relative bg-muted rounded-lg p-4">
                      <Button
                        size="sm"
                        variant="ghost"
                        className="absolute top-2 right-2 h-7 w-7 p-0"
                        onClick={copyTfvars}
                      >
                        {copied ? (
                          <Check className="h-4 w-4 text-green-500" />
                        ) : (
                          <Copy className="h-4 w-4" />
                        )}
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
  </div>
  )
}
