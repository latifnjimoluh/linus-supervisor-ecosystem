import * as React from "react"
import { AlertTriangle } from "lucide-react"

import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"
import { Button } from "@/components/ui/button"
import { MonitoringVm } from "@/services/monitoring"

interface MonitoringAlertsProps {
  vms: MonitoringVm[]
}

export function MonitoringAlerts({ vms }: MonitoringAlertsProps) {
  const [alerts, setAlerts] = React.useState<Array<{ id: string; message: string }>>([])
  const lastNotified = React.useRef<Record<string, number>>({})

  React.useEffect(() => {
    const now = Date.now()
    const cooldown = 5 * 60 * 1000
    const newAlerts: Array<{ id: string; message: string }> = []
    vms.forEach((vm) => {
      vm.alerts?.forEach((a) => {
        const key = `${vm.id}-${a.type}`
        const last = lastNotified.current[key] || 0
        if (now - last > cooldown) {
          newAlerts.push({ id: key, message: `VM ${vm.name} dépasse ${a.threshold}% ${a.type} — test mode` })
          lastNotified.current[key] = now
        }
      })
    })
    if (newAlerts.length) setAlerts((prev) => [...prev, ...newAlerts])
  }, [vms])

  return (
    <>
      {alerts.map((a) => (
        <Alert key={a.id} variant="warning" className="flex items-start gap-3 rounded-2xl">
          <AlertTriangle className="h-4 w-4 mt-1" />
          <div className="flex-1">
            <AlertTitle>Alerte</AlertTitle>
            <AlertDescription>{a.message}</AlertDescription>
          </div>
          <Button
            size="icon"
            variant="ghost"
            className="h-4 w-4 mt-1"
            onClick={() => setAlerts((prev) => prev.filter((x) => x.id !== a.id))}
          >
            ×
          </Button>
        </Alert>
      ))}
    </>
  )
}
