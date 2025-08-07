import './globals.css';
import { ToastProvider } from '@/components/ToastProvider';

export const metadata = {
  title: 'Linusupervisor'
};

export default function RootLayout({ children }) {
  return (
    <html lang="fr">
      <body>
        <ToastProvider>{children}</ToastProvider>
      </body>
    </html>
  );
}
