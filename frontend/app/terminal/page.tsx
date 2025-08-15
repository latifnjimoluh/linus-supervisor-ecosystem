"use client";

import * as React from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { ScrollArea } from "@/components/ui/scroll-area";
import { fetchTerminalVMs, TerminalVM, testSshConnection } from "@/services/vms";
import { getAuthToken } from "@/services/api";
import { ErrorBanner } from "@/components/error-banner";
import { useErrors } from "@/hooks/use-errors";
import { Terminal as XTerm } from "xterm";
import "xterm/css/xterm.css";

export default function TerminalPage() {
  const [vms, setVms] = React.useState<TerminalVM[]>([]);
  const [selectedVm, setSelectedVm] = React.useState<string>("");
  const [sshUser, setSshUser] = React.useState("");
  const termRef = React.useRef<HTMLDivElement>(null);
  const term = React.useRef<XTerm>();
  const { setError, clearError } = useErrors();

  React.useEffect(() => {
    fetchTerminalVMs()
      .then(setVms)
      .catch(() => setError("terminal-fetch", { message: "Impossible de récupérer les VMs", detailsUrl: "/logs" }));
  }, [setError]);

  const connect = async () => {
    const vm = vms.find(v => v.id === selectedVm);
    if (!vm?.ip) {
      setError("terminal", { message: "La VM n'est pas disponible", detailsUrl: "/logs" });
      return;
    }
    if (!sshUser.trim()) {
      setError("terminal", { message: "Veuillez saisir l'utilisateur SSH.", detailsUrl: "/logs" });
      return;
    }

    const test = await testSshConnection({ vm_id: vm.id, ip: vm.ip, ssh_user: sshUser.trim() });
    if (!test.ok) {
      setError("terminal", { message: test.message || "Impossible d'établir la connexion SSH.", detailsUrl: "/logs" });
      return;
    }

    clearError("terminal");
    if (term.current) term.current.dispose();
    const t = new XTerm();
    t.open(termRef.current!);

    const token = getAuthToken();
    const base = (process.env.NEXT_PUBLIC_API_URL || "http://localhost:3000").replace(/^http/, "ws");
    const ws = new WebSocket(`${base}/terminal/ws?token=${token}&vm_id=${vm.id}&ssh_user=${sshUser.trim()}`);
    ws.onmessage = (e) => t.write(typeof e.data === "string" ? e.data : new TextDecoder().decode(e.data));
    ws.onclose = () => t.write("\r\n*** connexion fermée ***\r\n");
    t.onData((d) => ws.send(d));
    term.current = t;
  };

  return (
    <div className="flex flex-col p-4 gap-4 h-full">
      <ErrorBanner id="terminal-fetch" />
      <div className="flex gap-2 items-center">
        <Select value={selectedVm} onValueChange={setSelectedVm}>
          <SelectTrigger className="w-64">
            <SelectValue placeholder="Choisir une VM" />
          </SelectTrigger>
          <SelectContent>
            {vms.map(vm => (
              <SelectItem key={vm.id} value={vm.id}>{vm.name} {vm.ip ? `(${vm.ip})` : ""}</SelectItem>
            ))}
          </SelectContent>
        </Select>
        <Input placeholder="Utilisateur SSH" value={sshUser} onChange={(e) => setSshUser(e.target.value)} className="w-48" />
        <Button onClick={connect}>Ouvrir</Button>
      </div>
      <ScrollArea className="flex-1 border rounded">
        <div ref={termRef} className="h-[400px]"></div>
      </ScrollArea>
      <ErrorBanner id="terminal" />
    </div>
  );
}
