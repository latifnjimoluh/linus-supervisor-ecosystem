import { useEffect, useState } from "react";

type Fetcher<T> = (key: string) => Promise<T>;
interface SWRResult<T> {
  data: T | undefined;
  isLoading: boolean;
  mutate: () => Promise<void>;
}

const cache = new Map<string, unknown>();

export default function useSWR<T>(key: string | null, fetcher: Fetcher<T>): SWRResult<T> {
  const [data, setData] = useState<T | undefined>(key ? (cache.get(key) as T) : undefined);
  const [isLoading, setIsLoading] = useState(!cache.has(key ?? ""));

  const mutate = async () => {
    if (!key) return;
    setIsLoading(true);
    const value = await fetcher(key);
    cache.set(key, value);
    setData(value);
    setIsLoading(false);
  };

  useEffect(() => {
    if (key && !cache.has(key)) {
      mutate();
    }
  }, [key]);

  return { data, isLoading, mutate };
}
