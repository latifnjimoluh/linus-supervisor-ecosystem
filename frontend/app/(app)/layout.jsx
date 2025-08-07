'use client';
import { useRouter } from 'next/navigation';
import { useEffect } from 'react';
import Layout from '@/components/Layout';

export default function AppLayout({ children }) {
  const router = useRouter();
  useEffect(() => {
    const token = localStorage.getItem('token');
    const expiry = localStorage.getItem('tokenExpiry');
    if (!token || !expiry || new Date(expiry) < new Date()) {
      localStorage.removeItem('token');
      localStorage.removeItem('tokenExpiry');
      router.replace('/login');
    }
  }, [router]);
  return <Layout>{children}</Layout>;
}
