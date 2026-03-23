import * as React from "react"

const CPU_KEY = "alert_threshold_cpu"
const RAM_KEY = "alert_threshold_ram"
const EVENT_NAME = "alert-thresholds-change"

function read(key: string, fallback: number) {
  if (typeof window === "undefined") return fallback
  const v = window.localStorage.getItem(key)
  return v ? Number(v) : fallback
}

export function useAlertThresholds() {
  const [cpu, setCpu] = React.useState(() => read(CPU_KEY, 10))
  const [ram, setRam] = React.useState(() => read(RAM_KEY, 10))

  React.useEffect(() => {
    const handler = () => {
      setCpu(read(CPU_KEY, 10))
      setRam(read(RAM_KEY, 10))
    }
    if (typeof window !== "undefined") {
      window.addEventListener(EVENT_NAME, handler)
      window.addEventListener("storage", handler)
    }
    return () => {
      if (typeof window !== "undefined") {
        window.removeEventListener(EVENT_NAME, handler)
        window.removeEventListener("storage", handler)
      }
    }
  }, [])

  const updateCpu = (v: number) => {
    setCpu(v)
    if (typeof window !== "undefined") {
      window.localStorage.setItem(CPU_KEY, String(v))
      window.dispatchEvent(new Event(EVENT_NAME))
    }
  }
  const updateRam = (v: number) => {
    setRam(v)
    if (typeof window !== "undefined") {
      window.localStorage.setItem(RAM_KEY, String(v))
      window.dispatchEvent(new Event(EVENT_NAME))
    }
  }

  return { cpu, ram, setCpu: updateCpu, setRam: updateRam }
}
