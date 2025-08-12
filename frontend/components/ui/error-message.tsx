"use client";

import { AlertCircle } from "lucide-react";
import clsx from "clsx";

export function ErrorMessage({
  children,
  className = "",
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <div
      role="alert"
      aria-live="polite"
      className={clsx("flex items-center gap-2 text-sm text-red-600", className)}
    >
      <AlertCircle className="h-4 w-4" aria-hidden="true" />
      <span>{children}</span>
    </div>
  );
}
