# Prompt untuk Antigravity (aplikasi Flutter TaskFlow)

Salin isi bagian "Prompt" di bawah ke Antigravity. Pastikan folder `design/` ini sudah ada di root project Flutter.

## Isi folder design/

- `DESIGN.md`: design system lengkap (token, komponen, aturan standar, catatan Flutter)
- `screens/`: screenshot acuan visual, satu file per layar (daftar di bawah)
- `assets/logo.png`: logo aplikasi
- `reference_html/`: HTML hasil export Stitch, hanya untuk membaca nilai persisnya (jangan di-port class Tailwind-nya)
- `KNOWN_ISSUES_STITCH_EXPORT.md`: cacat di file export, JANGAN ditiru

## Daftar layar

| File | Layar |
|---|---|
| 01_splash | Splash |
| 02_home_kosong | Home, state kosong |
| 03_home_overview | Home, daftar tugas + popover Edit/Hapus |
| 04_home_menu_aksi_cepat | Home, menu Aksi Cepat (tombol +) |
| 05_home_tugas_ditambahkan | Home setelah tugas ditambah (toast) |
| 06_home_tugas_dihapus | Home setelah tugas dihapus (toast Urungkan) |
| 07_tambah_tugas | Form Tambah Tugas |
| 08_detail_tugas | Detail Tugas |
| 09_edit_tugas | Form Edit Tugas |
| 10_selesai_rekap | Selesai / Rekap |
| 11_absen_aktif | Absen, ada jadwal |
| 12_absen_kosong | Absen, state kosong |
| 13_tambah_absen | Form Tambah Absen |
| 14_catatan_kosong | Catatan, state kosong |
| 15_catatan_daftar | Catatan, daftar |
| 16_catatan_baru | Editor catatan baru |
| 17_edit_catatan | Edit catatan |
| 18_tanya_ai_kosong | Tanya AI, state kosong |
| 19_tanya_ai_percakapan | Tanya AI, percakapan |
| 20_notifikasi | Notifikasi |
| 21_profil | Profil |
| 22_edit_profil | Edit Profil |
| 23_tentang | Tentang TaskFlow |

Catatan: screenshot 13, 16, dan 17 tampil dengan font serif karena cacat export. Fontnya tetap Plus Jakarta Sans.

## Prompt

```
Aplikasi Flutter TaskFlow ini sudah jadi, tetapi tampilannya belum selaras
dengan desain. Tugasmu hanya merapikan UI, jangan mengubah logika atau fitur.

Acuan desain ada di folder design/:
- design/DESIGN.md: sumber utama (token, komponen, bagian "Standards", dan
  "Flutter implementation notes"). Kalau ada perbedaan antar layar, aturan di
  bagian "Standards" yang menang.
- design/screens/*.png: acuan visual per layar (daftar ada di
  design/PROMPT_ANTIGRAVITY.md).
- design/assets/logo.png: logo.
- design/reference_html/*.html: hanya untuk membaca nilai persis; jangan
  menyalin class Tailwind-nya.
- Abaikan design/KNOWN_ISSUES_STITCH_EXPORT.md (itu cacat export, bukan target).

Kerjakan bertahap dan berhenti di akhir tiap tahap untuk minta konfirmasi:

1. AUDIT: baca kode UI yang ada, bandingkan dengan DESIGN.md dan screenshot,
   lalu buat daftar selisih per layar (warna, font, radius, shadow, spasi,
   ikon, komponen yang hilang atau berbeda). Jangan edit kode di tahap ini.
2. THEME: buat satu tempat untuk design token (ThemeData + ThemeExtension,
   TextTheme Plus Jakarta Sans). Hapus hex yang di-hardcode di widget.
3. WIDGET BERSAMA: ekstrak komponen yang dipakai ulang (daftar ada di
   DESIGN.md bagian Flutter implementation notes) dan pakai di semua layar.
4. LAYAR: rapikan satu layar per langkah, mulai dari Home (01-06), lalu
   Selesai, Absen, Catatan, Tanya AI, Notifikasi, Profil. Setelah tiap layar,
   jelaskan apa yang diubah dan tunggu konfirmasi.

Kalau ada yang tidak jelas, tanya dulu, jangan menebak.
```
