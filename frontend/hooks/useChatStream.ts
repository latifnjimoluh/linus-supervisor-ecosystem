import { useCallback, useRef, useState } from "react";

interface Handlers {
  onDelta: (token: string) => void;
  onEnd?: () => void;
  onError?: (type?: string) => void;
}

export function useChatStream(threadId: string) {
  const abortRef = useRef<AbortController | null>(null);
  const retryRef = useRef(0);
  const [isLoading, setIsLoading] = useState(false);
  const bufferRef = useRef("");
  const flushTimeout = useRef<NodeJS.Timeout | null>(null);

  const flush = (handlers: Handlers) => {
    if (bufferRef.current) {
      handlers.onDelta(bufferRef.current);
      bufferRef.current = "";
    }
    if (flushTimeout.current) {
      clearTimeout(flushTimeout.current);
      flushTimeout.current = null;
    }
  };

  const send = useCallback(
    (message: string, handlers: Handlers) => {
      const start = () => {
        const url = `/api/chat/stream?threadId=${encodeURIComponent(threadId)}&message=${encodeURIComponent(message)}`;
        abortRef.current = new AbortController();
        setIsLoading(true);
        fetch(url, { signal: abortRef.current.signal, headers: { Accept: "text/event-stream" } })
          .then(async (res) => {
            if (!res.ok) {
              handlers.onError?.(res.status === 402 || res.status === 429 ? "quota" : undefined);
              throw new Error("bad_status");
            }
            const reader = res.body?.getReader();
            const decoder = new TextDecoder();
            if (!reader) throw new Error("no_reader");
            let sseBuffer = "";
            try {
              while (true) {
                const { value, done } = await reader.read();
                if (done) break;
                sseBuffer += decoder.decode(value, { stream: true });
                let idx;
                while ((idx = sseBuffer.indexOf("\n\n")) !== -1) {
                  const part = sseBuffer.slice(0, idx);
                  sseBuffer = sseBuffer.slice(idx + 2);
                  if (part.startsWith(":")) continue; // comment/keepalive
                  const dataMatch = part.match(/^data: *(.*)$/m);
                  if (!dataMatch) continue;
                  const data = dataMatch[1];
                  if (data === "[END]") {
                    flush(handlers);
                    handlers.onEnd?.();
                  } else {
                    bufferRef.current += data;
                    if (!flushTimeout.current) {
                      flushTimeout.current = setTimeout(() => flush(handlers), 75);
                    }
                  }
                }
              }
              flush(handlers);
            } catch (err: any) {
              if (err?.name !== "AbortError") {
                handlers.onError?.();
              }
            } finally {
              setIsLoading(false);
              retryRef.current = 0;
            }
          })
          .catch((err) => {
            if (err?.name === "AbortError") {
              setIsLoading(false);
              return;
            }
            handlers.onError?.();
            if (retryRef.current < 3) {
              const delay = [1000, 2000, 5000][retryRef.current++];
              setTimeout(start, delay);
            } else {
              setIsLoading(false);
            }
          });
      };

      start();
    },
    [threadId]
  );

  const cancel = useCallback(() => {
    abortRef.current?.abort();
    setIsLoading(false);
  }, []);

  return { send, cancel, isLoading };
}

