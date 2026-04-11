# Tips.fan Messages

Progressive Web App (PWA): SMS-style dashboard using Supabase and Twilio.

## Deploy on Vercel

1. Push this repository to GitHub.
2. In [Vercel](https://vercel.com), import the repo.
3. Framework preset: **Other** (static site). Root directory: project root. Build command: leave empty. Output: leave default (`.`).

Vercel serves `index.html` at `/`. The web app manifest and service worker enable install-to-home-screen and basic offline shell caching.

## After deploy

- In the Supabase dashboard, add your production URL under **Authentication → URL configuration** (Site URL and Redirect URLs) so sign-in works on the live domain.

## Local preview

Serve the folder with any static server, for example:

```bash
npx --yes serve .
```

Then open the printed URL (use `http://127.0.0.1:3000` so the service worker scope matches).

## PWA notes

- `manifest.webmanifest` defines name, theme, and icons.
- `sw.js` caches the app shell; API calls (Supabase, Twilio proxy) still require network access.
