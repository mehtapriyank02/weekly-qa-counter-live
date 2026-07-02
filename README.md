# Weekly QA Counter - Clean Deploy Package

Use this package if the old GitHub Pages repo is stuck.

## Files to upload
Upload these files to a brand-new GitHub repository:
- index.html
- styles.css
- app.js
- config.js

## Important
Edit config.js before publishing:
- SUPABASE_URL must look like https://xxxxx.supabase.co
- SUPABASE_ANON_KEY must be your anon public key

## Supabase
If the Fail buttons show an RPC error, run:
- fail-selector-rpc-if-needed.sql

## GitHub Pages
Settings -> Pages:
- Source: Deploy from a branch
- Branch: main
- Folder: / root

Open your new site with:
https://YOUR-GITHUB-USERNAME.github.io/NEW-REPO-NAME/?v=300
