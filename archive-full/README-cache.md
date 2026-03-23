# Cache configuration

This project configures HTTP caching for static assets and API routes via `next.config.mjs` and uses a light in-memory caching hook (`useSWR`) for client-side data.

## HTTP headers
- `/_next/static/**`, `/_next/image/**`, `/fonts/**`, `/images/**`, `/icons/**`, `/favicons/**`:
  `Cache-Control: public, max-age=31536000, immutable`
- `/api/**`: `Cache-Control: private, no-store`

## Client cache
`useSWR` is implemented in `hooks/use-swr.ts` and stores responses in a simple memory map shared across components.

Modify caching strategies in `next.config.mjs` or `app/layout.tsx` as needed.
