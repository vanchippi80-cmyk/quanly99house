# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Vietnamese rental property management SPA (single-page app) for "99house". The entire application lives in **one file: `index.html`** (~2200 lines). No build step, no npm, no TypeScript — just HTML, CSS, and vanilla JS (ES2020+).

External libraries are loaded via CDN only:
- Firebase SDK v9 (compat mode) — auth + Firestore
- SheetJS v0.18.5 — Excel import/export

## Running the App

Open `index.html` in a browser directly, or serve it with any static file server:
```
npx serve .
```

## Deploying

```
deploy.bat
```

This script runs `git add index.html`, `git commit -m "Update app"`, `git push origin main`. GitHub Pages serves the result.

## Architecture

### Single-file SPA

All HTML, CSS, and JavaScript is co-located in `index.html`. There are no modules, no imports, no bundler. All logic is global scope.

### Backend: Firebase

- **Auth**: Google Sign-In via `firebase.auth().signInWithPopup()`
- **Database**: Firestore (NoSQL). Firebase config is hardcoded in the file.
- **No backend server** — everything runs in the browser.

### Firestore Collections

All per-property data is scoped by a `cosoId` field:

| Collection | Purpose |
|---|---|
| `coso` | Properties ("cơ sở") with name, address, initial balance |
| `phong` | Rooms with tenant info, lease dates, rent/deposit |
| `thu` | Revenue records (rent, utilities, deposits) |
| `bank` | Bank statement transactions |
| `no` | Debt/receivables |
| `hoahong` | Sales commissions |
| `taisan` | Fixed assets with depreciation |
| `inout` | Tenant check-in/check-out history |
| `danhmuc` | Custom transaction categories per property |
| `users` | User profiles and roles |

### In-Memory Cache

All Firestore data for the selected property is mirrored into a single global object:
```js
let cache = { phong:[], thu:[], no:[], users:[], hoahong:[], taisan:[], bank:[], inout:[] };
```
Firestore `onSnapshot` listeners update this cache and call `renderAll()` on every change.

### Navigation

Tab-based navigation via `switchTab(tabId)`. Shows/hides `<div class="tab-pane">` elements. No URL routing. Available tabs per role are defined in `NAV_CONFIG`.

### Multi-Tenancy

A global `selectedCosoId` gates all data access. Switching properties tears down all Firestore listeners and resubscribes with the new `cosoId`.

### Role-Based Access

| Role | Access |
|---|---|
| `owner` | Full access — all reports, user management, all properties |
| `manager` | Financial reports + operations, no user management |
| `sale` | Operational tabs only (rooms, tenants, collections, commissions) |
| `pending` | Blocked until an owner grants a role |

### UI Patterns

- Modals use CSS classes `modal-overlay` + `modal`
- Toast notifications via `toast(message)` global function
- DOM updates are direct `innerHTML` string builds — no virtual DOM
- Print support via `@media print` CSS hiding nav elements

### Excel Import (Bank Tab)

SheetJS parses `.xlsx` uploads. Auto-detects headers, normalizes dates (Excel serial numbers, `dd/mm/yyyy`, `yyyy-mm-dd`). Batch-writes to Firestore in chunks of 400 to stay under the 500-write batch limit.
