# Oljeporträtt – Jenny Hülphers

Portföljsida för beställningsporträtt i olja. Sidan är en enda statisk `index.html` som publiceras på Netlify.

## Filer

| Fil | Syfte |
|---|---|
| `index.html` | Hela sidan (HTML, CSS och JavaScript) |
| `logotyp.png`, `jenny.jpg`, `bakgrund.jpg` | Bilder (redan komprimerade) |
| `robots.txt`, `sitemap.xml` | Sökmotoroptimering |
| `netlify.toml` | Publicerar rotmappen och funktionerna i `netlify/functions` |
| `netlify/functions/verify-turnstile.js` | Kontrollerar Cloudflare Turnstile för kontaktformuläret |
| `supabase-admin-security.sql` | Rättigheter så att bara administratören kan ändra verk |
| `supabase-artworks-kind-order.sql` | Kolumnerna `kind` och `sort_order` i tabellen `artworks` |

## Tjänster

- **Netlify** – hosting, kontaktformulär (Netlify Forms) och funktionen för Turnstile. Miljövariabeln `TURNSTILE_SECRET_KEY` måste vara satt.
- **Supabase** – databas (`artworks`), bildlagring (bucket `paintings`) och inloggning med e-postlänk för administratören.
- **Cloudflare Turnstile** – captcha. Sidans domän måste vara tillagd i Turnstile-widgeten.

## Publicera

Pusha till `main` på GitHub. Netlify bygger och publicerar automatiskt.

## Administration

Klicka på punkten i sidfoten för att logga in. Där kan verk läggas till, redigeras, tas bort och sorteras. Bilder skalas automatiskt ner till max 2000 px och sparas som JPEG vid uppladdning.

## Sökmotoroptimering

- Canonical, sitemap och strukturerad data (JSON-LD) pekar på `https://oljeportratt.se/`. Ändra dem om domänen byts.
- Anmäl `sitemap.xml` i Google Search Console när domänen fungerar.
