'use client';
import NextLink from 'next/link';
import { useRouter, useParams as useNextParams } from 'next/navigation';

export function Link({ to, ...props }) {
  return <NextLink href={to} {...props} />;
}

export function useNavigate() {
  const router = useRouter();
  return (to) => {
    if (typeof to === 'number') {
      if (to === -1) router.back();
    } else {
      router.push(to);
    }
  };
}

export const useParams = useNextParams;
