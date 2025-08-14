import * as React from "react"
import { getAlertThresholds, createAlertThresholds, updateAlertThresholds } from "@/services/settings"

export function useAlertThresholds() {
  const [cpu, setCpu] = React.useState(10)
  const [ram, setRam] = React.useState(10)
  const [exists, setExists] = React.useState(false)

  React.useEffect(() => {
    ;(async () => {
      const data = await getAlertThresholds()
      if (data) {
        setCpu(data.alert_cpu_threshold ?? 10)
        setRam(data.alert_ram_threshold ?? 10)
        setExists(true)
      }
    })()
  }, [])

  const save = async (cpuVal: number, ramVal: number) => {
    if (exists) {
      await updateAlertThresholds({ alert_cpu_threshold: cpuVal, alert_ram_threshold: ramVal })
    } else {
      await createAlertThresholds({ alert_cpu_threshold: cpuVal, alert_ram_threshold: ramVal })
      setExists(true)
    }
    setCpu(cpuVal)
    setRam(ramVal)
  }

  return { cpu, ram, save }
}
