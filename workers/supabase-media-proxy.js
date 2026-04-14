/**
 * Cloudflare Worker — attach your custom domain (e.g. media.tips.fan) as a route to this Worker.
 * Forwards GET/HEAD to your Supabase project so public object URLs work at:
 *   https://<custom-domain>/storage/v1/object/public/media/<file>
 *
 * Setup:
 * 1. Replace SUPABASE_ORIGIN below with your project URL (same as SUPABASE_URL in index.html, no trailing slash).
 * 2. Create a Worker in Cloudflare, paste this file, deploy.
 * 3. Workers & Pages → your worker → Triggers → Custom Domains → add e.g. media.tips.fan (DNS proxied).
 * 4. In index.html set: const MEDIA_PUBLIC_BASE = 'https://media.tips.fan';
 *
 * Uploads from the app still POST directly to Supabase; only stored/sent links use MEDIA_PUBLIC_BASE.
 */
const SUPABASE_ORIGIN = 'https://khjoizstnjovgkjykgvu.supabase.co';

export default {
  async fetch(request) {
    const m = request.method;
    if (m !== 'GET' && m !== 'HEAD') {
      return new Response('Use Supabase URL for uploads', { status: 405 });
    }
    const u = new URL(request.url);
    const dest = new URL(SUPABASE_ORIGIN + u.pathname + u.search);
    const headers = new Headers(request.headers);
    headers.set('Host', new URL(SUPABASE_ORIGIN).host);
    return fetch(dest.toString(), {
      method: m,
      headers,
      redirect: 'follow'
    });
  }
};
