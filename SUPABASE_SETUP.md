# Turning on live sync (Supabase)

Right now the app saves on each device. Follow these 4 steps once and all 5 partners will share one live dataset that updates in real time.

## 1. Create a free Supabase project
1. Go to **https://supabase.com** and sign up (free tier is plenty).
2. Click **New project**. Give it a name (e.g. `futsal-ledger`) and a database password (save it somewhere).
3. Wait ~2 minutes for it to finish setting up.

## 2. Create the tables
1. In your project, open **SQL Editor** (left sidebar).
2. Open the file [supabase-schema.sql](supabase-schema.sql) from this folder, copy everything, paste it in, and click **Run**.
3. You should see "Success". This creates the `settings`, `deposits`, and `expenses` tables with open access and live sync.

## 3. Get your two keys
1. Open **Project Settings** (gear icon) → **API**.
2. Copy two values:
   - **Project URL** — looks like `https://abcd1234.supabase.co`
   - **anon public** key — a long string under "Project API keys"

## 4. Paste them into the app
1. Open **index.html** in a text editor.
2. Near the top of the script find these two lines and paste your values between the quotes:
   ```js
   const SUPABASE_URL = '';        // e.g. https://abcd1234.supabase.co
   const SUPABASE_ANON_KEY = '';   // your "anon public" key
   ```
3. Save the file and refresh the app.

That's it. The first device to connect uploads its current data automatically. After that, every add / edit / delete syncs across all devices within a second.

---

### How to share it with your partners
For everyone to use the same live data, the app needs to be hosted at a URL they can open. Easiest free options:
- **Netlify Drop** — drag this folder onto https://app.netlify.com/drop and you get a link.
- **Vercel**, **Cloudflare Pages**, or **GitHub Pages** also work.

Send that one link to your partners. Everyone who opens it sees the same live ledger.

### Notes
- **Open access:** anyone with the link (and the key inside it) can view and edit. Keep the link within your group. You can tighten this later with logins if you want.
- **Local fallback:** if the keys are blank or the internet is down, the app still works on your device and syncs up when it reconnects on the next change.
- **Backups:** Settings → Export JSON still works any time as an extra safety net.
