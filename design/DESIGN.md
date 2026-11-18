---
name: TaskFlow Mobile
colors:
  surface: '#FFFFFF'
  surface-dim: '#dadadb'
  surface-bright: '#f9f9fa'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f3f4'
  surface-container: '#eeeeef'
  surface-container-high: '#e8e8e9'
  surface-container-highest: '#e2e2e3'
  on-surface: '#1a1c1d'
  on-surface-variant: '#444748'
  inverse-surface: '#2f3132'
  inverse-on-surface: '#f0f1f2'
  outline: '#747878'
  outline-variant: '#c4c7c7'
  surface-tint: '#5f5e5e'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#1c1b1b'
  on-primary-container: '#858383'
  inverse-primary: '#c9c6c5'
  secondary: '#5e5e65'
  on-secondary: '#ffffff'
  secondary-container: '#e0dfe7'
  on-secondary-container: '#626269'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#1a1b20'
  on-tertiary-container: '#838389'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e5e2e1'
  primary-fixed-dim: '#c9c6c5'
  on-primary-fixed: '#1c1b1b'
  on-primary-fixed-variant: '#474646'
  secondary-fixed: '#e3e1e9'
  secondary-fixed-dim: '#c7c6cd'
  on-secondary-fixed: '#1a1b21'
  on-secondary-fixed-variant: '#46464d'
  tertiary-fixed: '#e2e2e8'
  tertiary-fixed-dim: '#c6c6cc'
  on-tertiary-fixed: '#1a1b20'
  on-tertiary-fixed-variant: '#45464c'
  background: '#f9f9fa'
  on-background: '#1a1c1d'
  surface-variant: '#e2e2e3'
  fill-1: '#EFEFF1'
  stat-light: '#EDEDEF'
  stat-dark: '#E2E2E5'
  divider: '#ECECEE'
typography:
  splash-title:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '800'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-h1:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '800'
    lineHeight: 32px
    letterSpacing: -0.02em
  stat-number:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 38px
    letterSpacing: -0.03em
  modal-title:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '700'
    lineHeight: 24px
  card-title:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '700'
    lineHeight: 22px
  body-default:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  button-text:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '700'
    lineHeight: 20px
  caption-meta:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  field-label:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
  nav-label:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  2xl: 1rem
  3xl: 1.5rem
  full: 9999px
spacing:
  gutter: 0.75rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style

TaskFlow is a student productivity app ("Kuliah, tugas, dan catatan dalam satu tempat") that brings assignments, class attendance reminders, notes, and an AI study assistant into one place. It is built for a single mobile viewport (390 × 844), light mode only, with all UI copy in Indonesian.

The visual language is **strict monochrome with soft cards**: white, rounded surfaces floating on a pale grey canvas, diffused low-opacity shadows, generous whitespace, and zero chromatic color. No blues, greens, reds, purples, pastels, or gradients appear anywhere. Status, priority, and hierarchy are expressed only through type weight, grey tonality, icon choice, and literal text markers. Every screen is assembled from the same small set of components, so a new screen should be built by recombining the components below, not by inventing new ones.

## Colors

Color tokens come from the shared Tailwind config that every screen embeds. Use the token names in code; hex values are listed for reference.

**Core roles**

| Role | Token | Hex | Used for |
|---|---|---|---|
| Ink / text-1 | `primary` | `#000000` | Headlines, active pill, primary buttons, FAB, avatar, user chat bubble, toast, unread dot, "on" toggle |
| Body text | `on-surface` | `#1a1c1d` | Card titles, field values, chip text, popover rows |
| Text-2 | `secondary` | `#5e5e65` | Meta lines, field labels, section labels, inactive pill text, chip icons |
| Text-3 | `outline` | `#747878` | Placeholders, inactive bottom-nav tabs (darker variant), timestamps, search icon |
| Canvas | `background` | `#f9f9fa` | Screen background (header uses it at 80–90 % with blur) |
| Surface | `surface` | `#FFFFFF` | Cards, inputs, search bar, popovers, bottom nav, AI bubbles |
| Fill-1 | `fill-1` | `#EFEFF1` | Inactive pills, chips, icon-circle backdrops, secondary buttons, unselected segments |
| Stat light | `stat-light` | `#EDEDEF` | Stat tiles (light position) |
| Stat dark | `stat-dark` | `#E2E2E5` | Stat tiles (dark position), progress track |
| Divider | `divider` | `#ECECEE` | 1 px separators, "off" toggle track |
| Checkbox idle | `surface-container-high` | `#e8e8e9` | Empty task checkbox circle |
| Separator dot | `outline-variant` | `#c4c7c7` | "•" between meta items on Absen cards |

The remaining Material-style tokens (`*-container`, `*-fixed`, `inverse-*`, `error*`) exist in the config but are **not used visually**. Do not reach for `error` red for delete or danger states; destructive actions are distinguished by an icon and label only.

**Scrim:** `#0A0A0A` at 40 % with `backdrop-blur-sm` (4 px), used behind the Aksi Cepat sheet.

**Priority and status are never colored.** Priority is a chip with a literal prefix: `— Rendah`, `= Sedang`, `! Tinggi`. Completed tasks use `secondary` text with strikethrough and a filled black checkbox.

> Legacy values: a few screens (Splash, Rekap, Absen, Edit Profil, Home empty state) hard-code `#0A0A0A`, `#6F6F76`, `#A8A8AE`, and `#F6F6F7` instead of tokens. In the screenshots this shows up as a **lighter grey for inactive bottom-nav tabs** (`#A8A8AE`) on Home empty, Rekap, and Catatan screens, versus the darker `outline` (`#747878`) on Home overview and Absen. Both are used in the exports; `outline` is the token.

## Typography

Plus Jakarta Sans only (weights 500, 600, 700, 800). Do not substitute Inter, Roboto, or system fonts.

| Token | Size / line | Weight | Used for |
|---|---|---|---|
| `splash-title` | 28 / 36 | 800, -0.02em | "TaskFlow" on splash |
| `headline-h1` | 24 / 32 | 800, -0.02em | Screen title ("Overview", "Rekap", "Presensi Aktif") |
| `stat-number` | 32 / 38 | 800, -0.03em | Stat values, profile counts |
| `modal-title` | 18 / 24 | 700 | Centered title in form/detail/profile top bars |
| `card-title` | 16 / 22 | 700 | Task, note, notification, and course titles; "Titut" in header |
| `body-default` | 14 / 20 | 500 | Field values, note previews, toast text (bold), popover rows |
| `button-text` | 14 / 20 | 700 | Buttons, pill tabs, segmented options |
| `caption-meta` | 12 / 16 | 500 | Meta rows, helper text, date pills, "Selamat datang" |
| `field-label` | 12 / 16 | 700 | Field labels; section labels in uppercase with `tracking-wider` |
| `nav-label` | 11 / 14 | 600 | Bottom-nav labels, small chips, timestamps |

Notes from the screens: Home stat numbers are set with `font-bold` (700) rather than the token's 800, while Rekap and Profil use the token weight. Occasional off-scale sizes exist (10 px badge count and "Markdown" tag, 13 px, 15 px for the editor "B" and small icons); avoid adding more.

Copy conventions: sentence case, Indonesian. Section labels and eyebrows ("PRIORITAS UTAMA", "AKAN DATANG", "JADWAL KITA", "KEAMANAN") are uppercase. Required fields end with ` *`. Times use `10:00 WIB`; dates use `24 Okt`, "Besok", "Hari Ini".

## Layout & Spacing

- **Viewport:** content column is `max-w-[390px]`, centered. Side margin is a constant 20 px (`margin`).
- **Gaps:** 12 px between cards and grid items (`gutter`); 16 px inside cards (`space-lg`); 24 px between form fields (`space-xl`); 8 px between a label and its field (`space-sm`).
- **Touch targets:** minimum 44 × 44 px for header buttons; chips and small icon buttons (24–32 px) are used inside cards only.
- **Icons:** Material Symbols Outlined. Sizes: 24 nav, 20 header/buttons, 18 menu/field leading, 14–16 inline meta. Filled variant (`FILL 1`) only for the pinned-note icon.

**Tab screen stack (Home, Selesai, Absen, Catatan)**

1. `AppHeader`: fixed, 56 px, `background/90` + `backdrop-blur-xl`
2. Content starts below header with safe padding:
   - **Home:** title row (`PageTitleRow` with no top dropdown), stat grid (2 tiles), search bar, single category dropdown filter (`CategoryFilterDropdown`), first section label, and task cards.
   - **Selesai (Rekap):** title row (`PageTitleRow` with no top dropdown), stat grid (4 tiles 2×2), search bar, single category dropdown filter (`CategoryFilterDropdown`), and completed task cards.
   - **Absen:** title row (with "X Mata Kuliah" count pill), course cards.
   - **Catatan:** title row (`PageTitleRow` with no dropdown), search bar, note cards (no category filters or tabs).
3. List content, 12 px between cards, section label above each group
4. `main` bottom padding 110 px so the floating `BottomNav` never covers content

**Form / detail screens** replace both header and bottom nav: a fixed 64 px top bar (`FormTopBar`) and, where there are actions, a fixed bottom action bar. `main` uses `pt-16` and `pb-44` to clear them.

## Elevation & Depth

Depth comes from soft shadows on white surfaces over the grey canvas, not from borders.

| Shadow | Value | Applied to |
|---|---|---|
| Standard | `0 8px 24px rgba(0,0,0,0.06)` | Cards, search bar, header circle buttons, pills with shadow, bottom nav, reminder card, AI bubbles |
| Field | `0 4px 12px rgba(0,0,0,0.03)` | Form inputs and textareas (focus: `0 8px 20px rgba(0,0,0,0.06)`) |
| Selected segment | `0 4px 12px rgba(0,0,0,0.08)` | Active segmented option |
| Stat tile | `0 8px 24px rgba(0,0,0,0.03)` | Rekap stat tiles |
| CTA | `0 8px 24px rgba(0,0,0,0.12)` | FAB, primary empty-state button |
| Toast | `0 8px 24px rgba(0,0,0,0.18)` | Toast |
| Popover | `0 12px 32px rgba(0,0,0,0.14)` | Three-dot menu |
| Sheet | `0 12px 36px rgba(0,0,0,0.16)` | Aksi Cepat sheet |
| Top bar | `0 1px 8px rgba(0,0,0,0.04)` | Form top bar |
| Sticky action bar | `0 -8px 24px rgba(0,0,0,0.06)` | Bottom action bar on forms |

Borders are not used on cards or inputs. The only borders are the 1 px `divider` rules between grouped rows, the hairline above editor status text, and a faint `divider/60` outline on the Aksi Cepat sheet. Overlays use the scrim described under Colors. Pressed states scale down: `active:scale-95` for small buttons, `active:scale-[0.98]` for large buttons and rows, `active:scale-[0.99]` for note cards.

## Shapes

| Radius | Used for |
|---|---|
| 9999 px (full) | Buttons, pills, chips, avatars, toggles, circular icon buttons, checkboxes |
| 32 px | Floating bottom nav |
| 28 px | Aksi Cepat sheet |
| 24 px | List cards, stat tiles, empty-state card, reminder card, settings groups, notification cards |
| 20 px | FAB (56 × 56), toast |
| 16 px | Search bar, **all form fields and segmented options**, popover, sheet rows, chat bubbles (`2xl`), editor formatting dock |
| 12 px (`xl`) | Editor tool buttons only |

Chat bubbles keep one tighter corner at the tail: `rounded-br-sm` for the user bubble, `rounded-bl-sm` for the AI bubble.

## Components

Each component below was checked against the exported screenshots. Where screens differ from each other, the variants are listed explicitly.

### AppHeader
Tab screens only (Home, Selesai, Absen, Catatan). Fixed, 56 px, 20 px side padding, `background/90` + blur.
- **Left (links to Profil):** 44 px black circle with a white "T" (16 px bold, never an icon) or user profile photo if set, then two lines: "Selamat datang" (12 px, `secondary`) over "Titut" (`card-title`).
- **Right:** two 44 px white circle buttons, 12 px apart, standard shadow. Bell (`notifications_none_outlined`, 20 px) with a reactive black count badge at its top-right (min 16×16 px, white 10 px bold, hidden via `SizedBox.shrink()` when unread count is 0, displays '99+' if > 99), and `auto_awesome_outlined` sparkle which opens Tanya AI.
- Nothing else is added to this header.

### PageTitleRow
`headline-h1` on the left ("Overview" on Home, "Rekap" on Selesai, "Semua Catatan" on Catatan).
- **No top dropdown filter:** Filter dropdown on the top-right has been removed from Home, Selesai, and Catatan to prevent duplicate filter controls and maintain a clean, uncluttered layout.
- **Absen:** Preserves a 36 px `fill-1` count pill ("X Mata Kuliah") on the right.

### StatGrid
Rounded 24 px tiles, 12 px gap.
- **Home (2 tiles):** `stat-light` then `stat-dark`; value and label centered; label 12 px semibold `secondary`. Height 88 px in every Home state, including the empty state (values "0" / "0"). No wave, no chevron.
- **Rekap (2 × 2, 96 px high):** checkerboard (light, dark / dark, light). Value top-left, a black wavy line top-right (about 44 × 14 px, 2 px stroke), label bottom-left, 14 px `chevron_right` bottom-right. Tiles: 18 Selesai, 4 Hari Ini, 14 Bulan Ini, 92% Tepat Waktu.
- **Profil (2 tiles):** `stat-light` / `stat-dark`, value + label left-aligned, wavy line top-right, no chevron ("42 Tugas Selesai", "7 Tugas Aktif").

### SearchBar
48 px high, `surface`, 16 px radius, standard shadow. 20 px `search` icon in `outline`, 12 px text. Placeholders: "Cari tugas..." (Home), "Cari tugas selesai..." (Rekap), "Cari catatan, tag, atau ide..." (Catatan).

### CategoryFilterDropdown (replaces PillTabs on Home & Selesai)
Positioned directly below the SearchBar on Home and Selesai screens. Replaces horizontal PillTabs to eliminate double-filtering and horizontal scroll clutter:
- **Button container:** 48 px high, `surface` background, 16 px border radius (`radius2Xl`), field shadow (`AppShadows.field`), 16 px horizontal padding.
- **Leading:** 18 px `category_outlined` icon in `secondary`, followed by 10 px gap and 14 px semibold text (`bodyDefault`). Text shows "Semua Kategori" when 'Semua' is selected, or the active category name.
- **Trailing:** 20 px `keyboard_arrow_down_rounded` icon in `secondary`.
- **Menu overlay:** `PopupMenuButton<String>` opening downward (`offset: Offset(0, 6)`), `surface` background, 16 px border radius, hairline border (`divider` at 0.6 opacity), 4 px elevation.
- **Menu items:** 44 px height each, category name on left, checkmark icon (`check_rounded`, 18 px `primary`) on right when selected.
- **Standard categories:** `'Semua'`, `'Kuliah'`, `'Pekerjaan'`, `'Pribadi'`, `'Lainnya'`.

### PillTabs
Compact segmented pills are reserved for screens with simple binary or narrow tabs:
- **Notifikasi:** two compact pills "Semua (X)" / "Belum Dibaca (X)".
- **Home & Selesai:** Replaced by `CategoryFilterDropdown`.
- **Catatan:** No pill tabs and no category filters.

### SectionLabel
`field-label`, uppercase, `tracking-wider`, `secondary`. Home: "PRIORITAS UTAMA", "AKAN DATANG". Rekap: group name left, count right ("SELESAI HARI INI … 3 tugas", "KEMARIN … 2 tugas"). Catatan: "HARI INI" is preceded by a small pin icon; then "7 HARI SEBELUMNYA", "30 HARI SEBELUMNYA"; the list ends with a centered "4 CATATAN".

### ListCard (task)
`surface`, 24 px radius, 16 px padding, standard shadow.
1. **Header row:** date/time pill left (28 px, `fill-1`, 14 px icon + 12 px text, e.g. "24 Okt", "Hari Ini, 14:00", "24 Okt · 10:00 WIB", "Besok, 14:00 WIB"); 32×32 px circular `fill-1` container with 3-dot `more_vert` right.
2. **Title row:** 24 px circular checkbox + `card-title`.
3. **Meta row**, indented under the title: 12 px `secondary`, 14 px icons, "•" separators (clock + time, location, folder, group, `videocam` Google Meet…).
4. **Chip row**, same indent: 24 px `fill-1` chips, 12 px semibold: standardized category (`Kuliah`, `Pekerjaan`, `Pribadi`, `Lainnya`) then priority (`— Rendah`, `= Sedang`, `! Tinggi`).

Checkbox: 24 px circle filled `surface-container-high` when empty (the same in every Home state); checked = black circle with a white check.

**Selesai variant:** header pill "Selesai · 14:15 WIB" with `check_circle`; the three-dot is replaced by a 32×32 px `fill-1` circular `undo` icon; black checkbox; title struck through in `secondary`.

### Popover (three-dot menu)
- **Trigger button:** 32×32 px circular container with `fill-1` (`#EFEFF1`) background and 16–18 px icon centered. This gives the trigger a clear, raised container shape separated from the card background (never a raw bare icon floating on white).
- **Popover container:** White (`surface`), 16 px border radius, hairline border (`divider` with 0.8 opacity), 8 px elevation with diffused shadow (`rgba(0,0,0,0.14)`), `offset: Offset(0, 8)` below the trigger button.
- **Menu items by card type:**
  - **Task card:** 44 px "Edit" (`edit_outlined`) + 1 px divider + 44 px "Hapus" (`delete_outline`).
  - **Note card:** ONLY 44 px "Hapus" (`delete_outline`).
  - **Attendance card:** 44 px "Hapus" (`delete_outline`).

### BottomNav
Floating `surface` bar, 72 px high, 32 px radius, 20 px side margins, standard shadow, five slots: Home, Selesai, center +, Absen, Catatan. Tabs are 24 px icon over an 11 px semibold label. Active tab: black icon and label, plus a 4 px dot below the label. Center button: 56 × 56 black square, 20 px radius, white `add`, raised 8 px.

Standard: use the Home set on every screen (`home`, `task_alt`, `add`, `calendar_today`, `edit_note`), with inactive tabs in `outline`. The exports vary as follows:

| Screen | Selesai | Absen | Catatan |
|---|---|---|---|
| Home (overview, states), Rekap | `task_alt` | `calendar_today` | `edit_note` |
| Absen | `task_alt` | `calendar_today` | `description` |
| Catatan | `task_alt` | `schedule` (clock) | `description` |

### Aksi Cepat (quick-action sheet)
Opens from the center button over a dimmed, blurred Home; the header stays crisp and the FAB icon becomes `close`. Floating white card above the nav, 28 px radius, 16 px padding, sheet shadow. Header row: "AKSI CEPAT" left, "Pilih tindakan" right, divider below. Three rows, each 44 px `fill-1` icon circle, 14 px bold title, 12 px `secondary` subtitle, light `chevron_right`:
1. Tambah Tugas, "Buat to-do & agenda kuliah"
2. Tambah Absen, "Pengingat presensi kelas"
3. Catatan Baru, "Tulis materi atau ide"

### Toast
Floats above the BottomNav, 56 px high, black, 20 px radius, white content: `check_circle` + 14 px bold message, and a trailing control. Observed: "Tugas berhasil ditambahkan" (close icon), "Tugas berhasil dihapus" (bold "Urungkan"), "Profil berhasil diperbarui" (Urungkan).

### EmptyState
White 24 px-radius card, centered content, 24 px padding: 96 px `fill-1` circle with a 40 px line icon, `card-title` heading, 14 px `secondary` body, then buttons.
- **Home:** check icon; "Belum Ada Tugas" / "Tambahkan tugas pertamamu atau cari tugas yang sudah ada."; two full-width 48 px pills: black "+ Tambah Tugas" and `fill-1` "Cari Tugas" (`search`).
- **Absen:** calendar-check icon with a small black round `add` badge at the circle's bottom-right; "Belum Ada Jadwal Absen"; body about adding courses so attendance isn't missed; full-width black "+ Tambah Absen". Count pill reads "0 Mata Kuliah".
- **Catatan:** file-plus icon; "Belum Ada Catatan" / "Catatan, ide, dan rangkuman kuliahmu akan muncul di sini."; a compact (not full-width) black pill "+ Tulis Catatan"; the pill tabs with zero counts sit above the card.

### FormTopBar
Fixed 64 px, translucent background, hairline shadow. 44 px white circle back button left, `modal-title` centered, invisible 44 px spacer right. Standard back icon: `arrow_back` (←) on every screen. The exports use a "<" chevron on Tambah Tugas, Edit Tugas, and Tambah Absen; change those to `arrow_back`.

### Form fields
- **Label:** `field-label`, `secondary`, 8 px above the field; required fields end with " *".
- **Text input:** 52 px high, white, field shadow, 16 px side padding, 14 px value, `outline` placeholder. Radius is 16 px on every form (the exports use 12 px on Tambah/Edit Tugas). Textarea min 110 px.
- **Date + time:** two columns, each a button-style field with a leading 18 px icon (`calendar_today` / `schedule`).
- **Segmented selector:** 48 px options, 16 px radius, 8 px gap; selected black with white text and a soft shadow, unselected `fill-1`. Priority (3 columns: `— Rendah`, `= Sedang`, `! Tinggi`), Tipe Tugas (2 × 2 standardized: `Kuliah`, `Pekerjaan`, `Pribadi`, `Lainnya`), Tipe Kelas (2 columns: `Praktikum`, `Teori`).
- **Toggle rows card (Pengingat & Notifikasi):** white card with 24 px radius, standard shadow, `padding: const EdgeInsets.symmetric(vertical: 8)`, and `clipBehavior: Clip.antiAlias`.
  - **Rows:** 56 px high, with `padding: const EdgeInsets.symmetric(horizontal: 16)` inside each row so content and switch never press against card edges ("rapi dan tidak mepet").
  - **Leading:** 32 px `fill-1` circle with bell icon (active: `primary`, inactive: `secondary`).
  - **Content:** 14 px semibold label (`bodyDefault`), optional 12 px subtitle (`captionMeta`).
  - **Trailing:** custom 48 × 28 pill toggle (`AppSwitch`).
  - **Dividers:** 1 px `divider` with `indent: 16, endIndent: 16` so they align cleanly with the content and never touch outer card borders.
  - **Tambah/Edit Tugas "Pengingat":** 1 hari sebelum, 12 jam sebelum, 6 jam sebelum, 3 jam sebelum, 1 jam sebelum (default: 3 jam is on).
  - **Tambah Absen "Notifikasi Absen":** Saat kuliah dimulai (on), 15 menit sebelum (on), 30 menit sebelum (off, shown with `notifications_off`).
- **Toggle:** 48 × 28 pill; on = black track, off = `divider` track; white 24 px thumb.
- **Location:** `location_on` field plus an underlined text link "Gunakan lokasi saat ini" with `near_me` below it.
- **Two-column pairs:** Tambah Absen puts Kelas and Ruangan side by side.

### Sticky Action Bar
Fixed bottom, near-white with blur and a soft upward shadow, 20 px padding. Stacked full-width 52 px pills 8 px apart: black primary ("Simpan Tugas", "Simpan Perubahan", "Simpan Absen") over `fill-1` "Batal". Edit Profil's primary has a leading check icon. Edit Tugas adds a third, text-only "Hapus Tugas" (`delete` icon) under "Batal".

### Detail Tugas
Back circle and centered title "Detail Tugas", then white 24 px-radius cards, 12 px apart:
1. **Summary:** chips "Kuliah" and "! Tinggi" on the left (both `fill-1`, as in lists; the export fills "! Tinggi" black, which is not used anywhere else); on the right a grey dot + "Belum Selesai" (12 px `secondary`). Title (about 20 px, extra-bold), description in `secondary`.
2. **Info:** three rows with 1 px dividers; each has a 40 px `fill-1` icon circle, a 12 px `secondary` label over a 14 px bold value: Tenggat Waktu "24 Okt 2024, 10:00 WIB", Lokasi "Lab Komputer 3", Sisa Waktu "Besok (22 jam lagi)".
3. **Pengingat Notifikasi:** bell icon + bold title, "1 aktif" at right; inside a `fill-1` row "3 jam sebelum (07:00 WIB)" / "Pemberitahuan push aktif" with an on toggle; caption below "Notifikasi akan dikirimkan ke perangkat ini."
4. **Actions:** full-width black "Tandai Selesai" (`check_circle`); below, two `fill-1` pills side by side: "Edit Tugas" (`edit`, black text) and "Hapus Tugas" (`delete`, `secondary` text; the export labels it just "Hapus").

### Absen
Header block: eyebrow "JADWAL KITA" (uppercase, `tracking-widest`), `headline-h1` "Presensi Aktif", and a `fill-1` count pill ("3 Mata Kuliah"). Course card: time pill (`schedule`, "08:00 - 09:40 WIB") left and class badge right ("Praktikum" black with white text; "Teori" `fill-1`), course name in `card-title`, meta row (`location_on` room • `group` class), reminder line (`notifications_active` "Pengingat aktif"). Cards are 24 px radius, 12 px apart.

### Catatan
- **List:** title "Semua Catatan" (no top dropdown), search bar ("Cari catatan, tag, atau ide..."), grouped notes. **No category filters, chips, or tabs on this screen.** Note card: time/date pill (`schedule` for time or "Kemarin", `calendar_today` for dates) and, for pinned notes, a 28 px `fill-1` circle with a pin; 32×32 px `fill-1` circular three-dot trigger on the right (popover options: ONLY "Hapus"); title in `card-title` (max 2 lines); 14 px `secondary` preview (max 2 lines). **No category chip is displayed on note cards.**
- **Editor (Catatan Baru, Edit Catatan):** one large white card (24 px radius): status line with a clock ("Dibuat hari ini • Baru" or "Terakhir diedit 15:30 WIB • 24 Okt"), a large bold title input ("Judul catatan"), a divider, the body ("Mulai menulis catatan di sini..."), a divider, then a footer with a grey dot + "Draf baru" / "Tersimpan otomatis" and a `fill-1` uppercase "MARKDOWN" tag. Below the card: a white formatting dock (16 px radius) with Bold, bullet list, checklist, pin, image, a thin divider, and a word count ("0 kata", "36 kata") at the right. Under it a `lock` line in `outline`: "Enkripsi lokal aktif • Hanya Anda yang dapat membaca catatan ini". Then stacked pills: black "Simpan Catatan" / "Simpan Perubahan" over `fill-1` "Hapus Draf" / "Hapus Catatan" (the latter with a `delete` icon). These buttons sit in the page flow, not in a fixed bar. **Category selection is omitted from the note editor.**

### Notifikasi
Back + "Notifikasi", two pills ("Semua (3)" black, "Belum Dibaca (2)" `fill-1`), then 24 px-radius cards: time chip ("15 menit lagi" with `schedule`, "Dalam 30 menit" with `notifications_active`, "Kemarin" with `check_circle`), a title (`card-title`), a 12 px `secondary` detail line. Unread cards have a black dot at the top-right; the read card has no dot and is dimmed. Footer: centered text action "Bersihkan notifikasi" with `delete_sweep`.

### Profil
Back + "Profil". Centered black avatar (about 96 px, "T" 40 px extra-bold) with a 32 px white camera badge at its bottom-right; "Titut" (bold), "titut.student@taskflow.id • Semester 5" in `secondary`; a `fill-1` "Edit Profil" pill with `edit`. Two stat tiles (see StatGrid). Group "KEAMANAN": Kunci Aplikasi PIN (toggle on), Ubah PIN (`pin`, "Terakhir diubah 30 hari lalu", chevron), Notifikasi & Pengingat (toggle on). Group "DATA": Bersihkan Tugas Selesai (chevron), Tentang TaskFlow ("Versi 1.0.0 (Build 240)", chevron). Each group is one white card with 36 px `fill-1` icon circles, 14 px bold titles, 12 px `secondary` subtitles, and 1 px dividers. Last: a full-width `fill-1` pill "Keluar dari Akun" with a `logout` icon.

### Edit Profil
Same avatar and camera badge. Fields with leading icons: Nama Lengkap * (`person`, "Titut"), Email * (`mail`, helper text "Email digunakan untuk sinkronisasi akun & notifikasi tugas."), NIM (Opsional) (`badge`). Then a white card "Status Akademik" with a `school` icon circle, "Semester 5 • Informatika", and a trailing `verified` icon. Sticky bar: "✓ Simpan Perubahan" over "Batal". Screen background is `#F6F6F7`.

### Tentang TaskFlow
Back + "Tentang TaskFlow". The logo sits in an 84 px white rounded tile with a soft shadow, then "TaskFlow" (24 px bold), the tagline, and a `fill-1` pill with a black dot "Versi 1.0.0 (Build 240)". A white card "Tentang Aplikasi" (`info` icon) with a paragraph in `secondary`. Group "INFORMASI & TAUTAN": Syarat & Ketentuan Layanan (`description`), Kebijakan Privasi (`shield`), Lisensi Sumber Terbuka (`code`), Situs Web Resmi "taskflow.id" (`language`, trailing `open_in_new`). Group "DUKUNGAN": Hubungi Dukungan "bantuan@taskflow.id" (`mail`), Beri Nilai & Ulasan "Dukung pengembangan aplikasi" (`star`), Periksa Pembaruan "Aplikasi Anda menggunakan versi terbaru" (sync icon, trailing `check_circle`). Footer: "© 2025 TaskFlow Indonesia. Hak Cipta Dilindungi." Standard: row titles 14 px bold and group labels `field-label` (700), same as Profil. The export uses lighter weights.

### Tanya AI
Full screen. Top bar: back circle, centered "Tanya Ai" with the subtitle "Asisten Studi & Agenda".
- **Empty:** a status row, black dot + "Model Aktif • Respons Kilat" left and a `fill-1` "Riwayat" pill (`history`) right. A 96 px `fill-1` circle with a sparkle icon and a small white `bolt` badge; "Mulai Tanya AI"; a three-line description. "SARAN PERTANYAAN CEPAT" with "Sentuh untuk pakai" right; four white suggestion cards (44 px icon circle, single-line bold text truncated with an ellipsis, light chevron): jadwal kuliah & tugas hari ini (`calendar_today`), rencana belajar ujian Basis Data (`schedule`), rangkum catatan kuliah terakhirku (`description`), prioritaskan 5 tugas menumpuk (`check_circle`).
- **Conversation:** date chip "Hari Ini, 09:15 WIB". User bubble: right, black, white text, large radius with a squared bottom-right corner, followed by "09:15" and a double-check. AI reply: 28 px black avatar with a sparkle; white bubble with a squared bottom-left corner; timestamp below. A rich schedule card follows (calendar icon circle, "Rencana Belajar: Basis Data", "3 Sesi • Total durasi 3 jam 30 mnt", date pill "Kamis, 26 Okt"; three `fill-1` session rows each with a bold time chip, session name, and a 12 px `secondary` note; full-width black "+ Tambahkan ke Daftar Tugas"). Then another AI bubble and two small white pills with a light shadow: "Ya, pasang alarm" (`alarm_on`) and "Tidak perlu".
- **Input bar:** floating white pill; 36 px `fill-1` `add` button, text field ("Tanya apa saja seputar kuliah..." when empty, "Ketik pesan balasan..." in a conversation), `mic` icon (conversation only), and a 40 px black circular send button (`arrow_upward`).

### SplashScreen
Background `#F6F6F7` with large, very soft concentric radial glow rings behind the logo. Centered 112 × 112 logo: black rounded square (about 28 % radius) containing a light outlined checkbox with a check mark and two short lines (`logo_removebg_preview.png`). 24 px below: "TaskFlow" (28 px extra-bold); 8 px below: the tagline (14 px, `secondary`), wrapping to two lines at 280 px. Near the bottom: a 120 × 4 px progress track (`#E2E2E5`, animated black fill) and "Versi 1.0.0" (12 px, light grey).

## Do's and Don'ts

- **Do** build every screen from the components above and keep their dimensions.
- **Do** use `primary` black as the only emphasis color.
- **Do** keep sticky elements clear of content with the stated bottom padding.
- **Don't** introduce color, gradients, or hard borders on cards and inputs.
- **Don't** use red for delete or error; rely on icon and label.
- **Don't** add icons, titles, or logos to `AppHeader`.
- **Don't** change the order or number of bottom-nav slots.

## Standards (resolved differences)

Where the exported screens disagree, this table is the rule. Component descriptions above note the export variants for reference.

| Item | Variants in the exports | Standard |
|---|---|---|
| Font | Serif fallback on Tambah Absen, Catatan Baru, Edit Catatan | Plus Jakarta Sans everywhere; set it explicitly on inputs, textareas, and buttons |
| Form field and segmented radius | 12 px (Tugas forms), 16 px (Absen, Edit Profil) | 16 px |
| Back icon | "<" chevron vs "←" arrow | `arrow_back` |
| Bottom-nav icons | Absen: `calendar_today` or `schedule`; Catatan: `edit_note` or `description` | `calendar_today` and `edit_note` |
| Inactive tab color | `#747878` or `#A8A8AE` | `outline` (`#747878`) |
| Task checkbox (empty) | Grey fill or white with outline | Grey fill (`surface-container-high`) |
| Home stat tile height | 88 px or about 96 px | 88 px |
| Stat number weight | 700 on Home, 800 on Rekap/Profil | 800 (`stat-number`) |
| Screen background | `#f9f9fa` or `#F6F6F7` (Edit Profil, Splash) | `background` (`#f9f9fa`) |
| Hard-coded hex | `#0A0A0A`, `#6F6F76`, `#A8A8AE`, `#F6F6F7` | Tokens: `primary`, `secondary`, `outline`, `background` |
| Priority chip on Detail Tugas | Black fill | `fill-1` like every list |
| Delete label | "Hapus" (Detail) vs "Hapus Tugas" (Edit) | "Hapus Tugas" |
| Row weight on Tentang | Regular | Bold, like Profil |
| Product name | "Tanya Ai" in top bars | "Tanya AI" |
| Task categories | 4 fixed categories | `'Kuliah'`, `'Pekerjaan'`, `'Pribadi'`, `'Lainnya'` across all task forms and filters |
| Task filter location | Top dropdown vs PillTabs vs Dropdown below search | Single 48 px `CategoryFilterDropdown` directly below SearchBar on Home & Selesai; top PageTitleRow dropdown removed |
| Catatan categories & filters | With vs without category tags/filters | **Without** category filters, chips, or selector; notes focus strictly on title, content, date, and pinned state |
| Three-dot trigger button | Raw icon vs circular container | 32×32 px circular `fill-1` container with 16–18 px icon on all cards (`TaskCard`, `NoteCard`, `AttendanceCard`) |
| Three-dot popover menu | Flat overlay vs styled card | 16 px radius, 8 elevation, shadow `rgba(0,0,0,0.14)`, hairline `divider` border |
| Toggle card padding | Flush/mepet vs padded | Card: vertical 8 px padding; Row: horizontal 16 px padding; Dividers: 16 px indent/endIndent |
| Notification badge | Hardcoded '2' vs dynamic count | Reactive `unreadCount`; hidden (`SizedBox.shrink()`) when 0; '99+' when > 99 |

## Flutter implementation notes

Target stack: **Flutter**. This document was written from a Tailwind/HTML export, so translate as follows. The `design/reference_html/` files are only a source of exact values; do not port their classes.

- **Theme:** define the tokens once (a `ThemeData` with a light `ColorScheme`, plus a `ThemeExtension` for the custom tokens `fill1`, `statLight`, `statDark`, `divider`, `textSecondary`, `textTertiary`). Screens read colors from the theme; no hex literals in widgets.
- **Font:** Plus Jakarta Sans, weights 500/600/700/800 (via the `google_fonts` package or bundled font assets). Map the typography table to `TextTheme` / named `TextStyle`s (`headlineH1`, `statNumber`, `modalTitle`, `cardTitle`, `bodyDefault`, `buttonText`, `captionMeta`, `fieldLabel`, `navLabel`). Convert `letterSpacing` from em to logical pixels (for example -0.02em at 24 px is -0.48).
- **Icons:** Material Symbols Outlined; the `material_symbols_icons` package (`Symbols.*`) matches the names used here. Use weight 400 and fill 0, except the filled `push_pin`.
- **Shadows:** `BoxShadow(offset: Offset(0, 8), blurRadius: 24, color: Colors.black.withOpacity(0.06))` is the standard shadow; build the other shadows from the Elevation table.
- **Radii and sizes:** use `BorderRadius.circular(...)` with the values in Shapes; keep touch targets at least 44 px.
- **Layout:** the 390 px width is the reference design, not a fixed width. Use 20 px horizontal padding, and keep the 12/16/24 px spacing. Respect `SafeArea`.
- **AppHeader and BottomNav:** build them as custom widgets (the BottomNav is a floating rounded container with a raised center button), not `AppBar` / `BottomNavigationBar`. The header's translucent blur can use `BackdropFilter`.
- **Scrim and sheet:** the Aksi Cepat overlay is a 40 % black scrim with `ImageFilter.blur(sigmaX: 4, sigmaY: 4)` behind a floating card, not a Material bottom sheet.
- **Pressed state:** wrap tappable cards and buttons in `AnimatedScale` (0.95 for small buttons, 0.98 for large buttons and rows, 0.99 for note cards).
- **Toggle:** custom 48 x 28 switch (or a themed `Switch`) with a black on-track, a `divider` off-track, and a 24 px white thumb.
- **Forms:** one reusable field widget (52 px, 16 px radius, field shadow, `fieldLabel` above) and one segmented-option widget; every form screen uses them.
- **Shared widgets to extract first:** AppHeader, PageTitleRow, StatTile, SearchBar, CategoryFilterDropdown, PillTabs, SectionLabel, TaskCard, NoteCard, CourseCard, BottomNav, QuickActionSheet, Toast, EmptyState, FormTopBar, StickyActionBar, SettingsGroup/SettingsRow, ToggleRow, ChatBubble.
