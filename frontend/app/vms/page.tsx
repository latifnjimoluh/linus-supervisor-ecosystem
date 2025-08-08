"use client"

import * as React from "react"
import { Play, Square, Trash2, RefreshCcw, HardDrive } from "lucide-react"

import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card"
import { Table, TableHeader, TableRow, TableHead, TableBody, TableCell } from "@/components/ui/table"
import { Button } from "@/components/ui/button"
import { useToast } from "@/hooks/use-toast"
import { listVms, startVm, stopVm, deleteVm, convertVmToTemplate, type VmInfo } from "@/services/api"

export default function VmsPage() {
  const [vms, setVms] = React.useState<VmInfo[]>([])
  const { toast } = useToast()

  const fetchVms = React.useCallback(async () => {
    try {
      const data = await listVms()
      setVms(data.data || data || [])
    } catch (e: any) {
      toast({ title: "Erreur", description: e.message, variant: "destructive" })
    }
  }, [toast])

  React.useEffect(() => {
    fetchVms()
  }, [fetchVms])

  const handleStart = async (id: number) => {
    try {
      await startVm(id)
      toast({ title: "VM démarrée", variant: "success" })
      fetchVms()
    } catch (e: any) {
      toast({ title: "Erreur", description: e.message, variant: "destructive" })
    }
  }

  const handleStop = async (id: number) => {
    try {
      await stopVm(id)
      toast({ title: "VM arrêtée", variant: "success" })
      fetchVms()
    } catch (e: any) {
      toast({ title: "Erreur", description: e.message, variant: "destructive" })
    }
  }

  const handleDelete = async (vm_id: number, instance_id?: string) => {
    try {
      await deleteVm({ vm_id, instance_id: instance_id || "" })
      toast({ title: "VM supprimée", variant: "success" })
      fetchVms()
    } catch (e: any) {
      toast({ title: "Erreur", description: e.message, variant: "destructive" })
    }
  }

  const handleConvert = async (vm_id: number) => {
    try {
      await convertVmToTemplate(vm_id)
      toast({ title: "Conversion lancée", variant: "success" })
    } catch (e: any) {
      toast({ title: "Erreur", description: e.message, variant: "destructive" })
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-3">
        <HardDrive className="h-8 w-8 text-primary" />
        <h1 className="text-3xl font-bold">Machines virtuelles</h1>
      </div>
      <Card className="rounded-2xl">
        <CardHeader>
          <CardTitle>Liste des VMs</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>ID</TableHead>
                <TableHead>Nom</TableHead>
                <TableHead>Statut</TableHead>
                <TableHead className="w-48">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {vms.map((vm) => (
                <TableRow key={vm.vm_id}>
                  <TableCell>{vm.vm_id}</TableCell>
                  <TableCell>{vm.name || "-"}</TableCell>
                  <TableCell>{vm.status || "-"}</TableCell>
                  <TableCell className="space-x-1 text-right">
                    <Button variant="ghost" size="icon" onClick={() => handleStart(vm.vm_id)}>
                      <Play className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon" onClick={() => handleStop(vm.vm_id)}>
                      <Square className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon" onClick={() => handleConvert(vm.vm_id)}>
                      <RefreshCcw className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon" onClick={() => handleDelete(vm.vm_id, vm.instance_id)}>
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
              {!vms.length && (
                <TableRow>
                  <TableCell colSpan={4} className="text-center text-muted-foreground py-8">
                    Aucune VM trouvée.
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  )
}

