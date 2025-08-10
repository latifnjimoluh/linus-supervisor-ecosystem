import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

export function formatBytes(bytes: number, decimals = 2) {
  if (!bytes) return '0 B'
  const k = 1024
  const dm = decimals < 0 ? 0 : decimals
  const sizes = ['B', 'KB', 'MB', 'GB', 'TB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  const value = bytes / Math.pow(k, i)
  return `${value.toFixed(dm)} ${sizes[i]}`
}

export function formatKB(kb: number, decimals = 2) {
  return formatBytes(kb * 1024, decimals)
}

export function formatPercent(value: number, decimals = 2) {
  if (value == null) return '0%'
  const num = Number(value)
  return `${num.toFixed(decimals)}%`
}

export function formatDate(value: string | null) {
  if (!value) return ''
  const date = new Date(value)
  return date.toLocaleString('fr-FR')
}
