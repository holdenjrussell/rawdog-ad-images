# rawdog-ad-images

PUBLIC image CDN repo for RAWDOG (www.justrawdogit.com). Everything in this repo is
consumed via
`https://raw.githubusercontent.com/holdenjrussell/rawdog-ad-images/main/<path>`
URLs so images render inside AI-agent chats, sandboxes, Google Slides/Docs URL
fetchers, and Slack image blocks without auth.

PUBLIC-SAFE CONTENT ONLY. Screenshots of publicly served ads and emails,
public brand assets, and public storefront product photos qualify.
Never commit: customer data, internal dashboards, revenue numbers,
unreleased creative under embargo, credentials, or anything the brand
would not show a stranger.

## Layout

| Path | Contents | Producer |
|---|---|---|
| `brand/` | RAWDOG logo variants (PNG + SVG) and palette card | Seeded at setup from the brand kit; updated manually |
| `products/<handle>.jpg` | Public storefront product photos, one per product handle | Seeded from the public product-catalog snapshot |
| `emails/<slug>-<sha8>.png\|jpg` | Rendered screenshots of publicly sent RAWDOG emails, content-addressed | ESP render lanes (module: klaviyo) |
| `previews/<ad_id>.jpg` | Full rendered ad unit (identity header, copy, media/poster, CTA card) per publicly served ad | Ad-preview screenshot lane (module: meta-ads) |
| `social/<media_id>.jpg` | Normalized cover/poster for a public first-party RAWDOG Instagram post (feed, carousel, video, or story frame) | Organic-social visual sync (module: adimages-cdn) |
| `deck/` | Hand-curated public deck assets | Manual |

## Conventions

- `main` branch only; consumers hardcode `/main/` in raw URLs.
- Filenames are stable IDs (product handle, ad id, slug + content-hash
  prefix), never human-edited names, so URLs are predictable from
  warehouse rows.
- JPEG for screenshots and product photos (size), PNG/SVG for brand
  assets (fidelity).
- Producers commit with machine identities and push immediately after
  capture; a file that is not pushed does not exist as far as consumers
  are concerned.
- `social/` contains only media owned and publicly posted by RAWDOG — the
  capture lane filters on RAWDOG's own Instagram handle. It excludes DMs,
  drafts, comments, private/embargoed media, and creator UGC that is not a
  first-party post.
- Keep files reasonably sized (target < 1 MB per image). raw GitHub
  serves large files slowly and some consumers cap fetch sizes.

## Index metadata

The warehouse keeps index metadata per producer lane (capture time,
source, file path, status, public URL). The repo itself carries no
metadata beyond filenames; the DB row is the source of truth, the repo
is delivery.
