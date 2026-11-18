# Known issues in the Stitch export (reference only)

These are defects in the exported screenshots/HTML. They are **not** part of the target design. Do not copy them into the Flutter app.

- **Pinned note icon:** the pin circle on the first note in the Catatan list renders empty; it should show a filled `push_pin`.
- **Rekap search field:** shows a visible default input outline in the screenshot; remove it so it matches the other search bars.
- **Tambah Absen, Catatan Baru, Edit Catatan:** the whole screen renders in serif, including the "MARKDOWN" tag, which wraps onto two lines ("MARKDOW / N") because the tag has no `whitespace-nowrap`.
- **Off-scale sizes:** 10, 13, and 15 px text, and the 20 px Detail Tugas title, are outside the type scale. Map them to `caption-meta`, `body-default`, or `modal-title`.
- **Tab vs screen naming:** the tab is "Selesai" but its screen is titled "Rekap". Keep both, but treat them as one screen.
- **Mock data:** dates conflict ("24 Okt 2024" on tasks, "Hari ini, 24 Mei" on Tambah Absen, a 2025 copyright on Tentang). Use one reference date when building the real screens.
- **Splash and Tentang logo:** loaded from a temporary `googleusercontent` URL. Use the bundled `logo_removebg_preview.png` asset instead.
- **Dependencies loaded from CDNs:** Tailwind and Google Fonts. Bundle fonts and Material Symbols locally for the real app.
- **Toast and popover states** are hidden in some exports; implement them as overlays with the dimensions above, not as part of the page flow.
