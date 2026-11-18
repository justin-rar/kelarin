# Struktur File dan Modul Proyek 🗂️
## TaskFlow Mobile (Kelarin)

Dokumen ini memetakan seluruh berkas kode sumber di dalam direktori `lib/` untuk memudahkan navigasi bagi pengembang dan anggota tim.

---

## 🌳 1. Diagram Struktur Direktori `lib/`

```text
lib/
├── main.dart                                # Titik masuk aplikasi (GetMaterialApp, tema, inisialisasi Hive)
└── app/
    ├── core/                                # Pondasi desain, tema, dan konstanta
    │   ├── constants/
    │   │   ├── app_colors.dart              # Token warna monokrom (#000000, #FFFFFF, #F9F9FA, dll)
    │   │   ├── app_dimens.dart              # Ukuran baku, margin 20px, radius 24px, gap 12px
    │   │   └── app_shadows.dart             # BoxShadow difus lembut (standard, field, popover)
    │   └── theme/
    │       ├── app_theme.dart               # ThemeData konfigurasi utama
    │       ├── app_theme_extension.dart     # Token ekstensi tema Flutter
    │       └── app_typography.dart          # TextStyles baku (Plus Jakarta Sans)
    │
    ├── data/                                # Layer data lokal
    │   ├── models/
    │   │   ├── attendance_model.dart        # Model & TypeAdapter Hive untuk presensi (typeId: 1)
    │   │   ├── note_model.dart              # Model & TypeAdapter Hive untuk catatan (typeId: 2)
    │   │   ├── notification_item_model.dart # Model & TypeAdapter Hive untuk notifikasi (typeId: 3)
    │   │   └── task_model.dart              # Model & TypeAdapter Hive untuk tugas (typeId: 0)
    │   └── services/
    │       ├── dummy_data_service.dart      # Data awal (seeding) sesuai spesifikasi Stitch
    │       └── storage_service.dart         # Wrapper SharedPreferences & Hive Boxes
    │
    ├── global_widgets/                      # Komponen UI yang digunakan bersama
    │   ├── app_form_field.dart              # Input teks & textarea terstandarisasi (radius 16px)
    │   ├── app_header.dart                  # Header 56px dengan avatar & badge notifikasi dinamis
    │   ├── app_search_bar.dart              # Kolom pencarian instan 48px
    │   ├── chat_bubble.dart                 # Gelembung chat monokrom untuk Tanya AI
    │   ├── confirmation_dialog.dart         # Dialog modal konfirmasi tindakan destruktif
    │   ├── course_card.dart                 # Kartu jadwal kuliah & presensi
    │   ├── empty_state.dart                 # Tampilan kosong terstandarisasi dengan tombol aksi
    │   ├── floating_bottom_nav.dart         # Navigasi bawah mengambang 5 slot (Home, Selesai, +, Absen, Catatan)
    │   ├── form_top_bar.dart                # Top bar 64px dengan tombol back lingkaran
    │   ├── page_title_row.dart              # Baris judul halaman utama (H1)
    │   ├── pill_tabs.dart                   # Segmented selector pil untuk filter biner
    │   ├── quick_action_sheet.dart          # Sheet Aksi Cepat saat tombol + ditekan
    │   ├── section_label.dart               # Label seksi huruf kapital (PRIORITAS UTAMA, dll)
    │   ├── segmented_selector.dart          # Pemilih opsi segmented (prioritas, tipe kelas, tipe tugas)
    │   ├── settings_group.dart              # Kartu pengelompokan menu profil / pengaturan
    │   ├── sine_wave_painter.dart           # CustomPainter garis gelombang sine pada kartu statistik
    │   ├── stat_tile.dart                   # Kartu angka statistik (stat-light & stat-dark)
    │   ├── sticky_action_bar.dart           # Bar tombol aksi melayang di bagian bawah form
    │   ├── toggle_row.dart                  # Baris toggle pengingat dengan padding rapi (AppSwitch)
    │   └── undo_toast.dart                  # Toast melayang hitam dengan tombol "Urungkan"
    │
    ├── modules/                             # Modul fitur berbasis GetX
    │   ├── ai/                              # Fitur Tanya AI (Asisten Belajar)
    │   │   ├── ai_controller.dart
    │   │   └── views/
    │   │       ├── tanya_ai_bottom_sheet.dart
    │   │       └── tanya_ai_view.dart
    │   ├── attendance/                      # Fitur Presensi & Jadwal Kuliah
    │   │   ├── attendance_binding.dart
    │   │   ├── attendance_controller.dart
    │   │   ├── views/
    │   │   │   ├── add_attendance_view.dart
    │   │   │   └── attendance_view.dart
    │   │   └── widgets/
    │   │       └── attendance_card.dart
    │   ├── home/                            # Fitur Beranda / Overview
    │   │   ├── home_view.dart
    │   │   └── widgets/
    │   │       ├── pill_tabs.dart
    │   │       └── stat_grid.dart
    │   ├── main_navigation/                 # Wrapper Navigasi Tab Utama
    │   │   ├── main_nav_binding.dart
    │   │   ├── main_nav_controller.dart
    │   │   └── main_nav_view.dart
    │   ├── note/                            # Fitur Catatan Akademik
    │   │   ├── note_binding.dart
    │   │   ├── note_controller.dart
    │   │   ├── views/
    │   │   │   ├── add_note_view.dart
    │   │   │   ├── edit_note_view.dart
    │   │   │   └── note_view.dart
    │   │   └── widgets/
    │   │       └── note_card.dart
    │   ├── notification/                    # Fitur Pusat Notifikasi
    │   │   ├── notification_controller.dart
    │   │   └── views/
    │   │       └── notification_view.dart
    │   ├── onboarding/                      # Pengenalan Aplikasi
    │   │   ├── onboarding_controller.dart
    │   │   └── views/
    │   │       └── onboarding_view.dart
    │   ├── pin/                             # Fitur Keamanan PIN 4-digit
    │   │   ├── pin_controller.dart
    │   │   └── pin_view.dart
    │   ├── profile/                         # Fitur Profil & Pengaturan Mahasiswa
    │   │   ├── profile_binding.dart
    │   │   ├── profile_controller.dart
    │   │   └── views/
    │   │       ├── about_view.dart
    │   │       ├── edit_profile_view.dart
    │   │       └── profile_view.dart
    │   ├── splash/                          # Layar Pembuka & Pengecekan PIN
    │   │   ├── splash_controller.dart
    │   │   └── splash_view.dart
    │   └── task/                            # Fitur Manajemen Tugas
    │       ├── task_binding.dart
    │       ├── task_controller.dart
    │       ├── views/
    │       │   ├── add_task_view.dart
    │       │   ├── completed_tasks_view.dart
    │       │   ├── edit_task_view.dart
    │       │   └── task_detail_view.dart
    │       └── widgets/
    │           └── task_card.dart
    │
    └── routes/                              # Konfigurasi Rute GetPage
        ├── app_pages.dart                   # Daftar halaman, binding, dan transisi rute
        └── app_routes.dart                  # Konstanta nama rute (string path)
```

---

## 🗺️ 2. Daftar Rute Navigasi (`AppRoutes`)

| Rute | Konstanta di `AppRoutes` | Deskripsi Tampilan |
|---|---|---|
| `/splash` | `AppRoutes.splash` | Splash screen & pengecekan status inisialisasi / status PIN |
| `/onboarding` | `AppRoutes.onboarding` | Panduan perkenalan awal bagi pengguna baru |
| `/pin` | `AppRoutes.pin` | Layar keypad PIN (auth, setup, ubah, atau konfirmasi) |
| `/main` | `AppRoutes.main` | Wrapper navigasi utama 4 tab (Home, Selesai, Absen, Catatan) |
| `/task/add` | `AppRoutes.taskAdd` | Form pembuatan tugas baru |
| `/task/edit` | `AppRoutes.taskEdit` | Form pengeditan tugas yang sudah ada |
| `/task/detail` | `AppRoutes.taskDetail` | Halaman rincian lengkap tugas |
| `/attendance/add` | `AppRoutes.attendanceAdd` | Form penambahan jadwal mata kuliah / presensi |
| `/note/add` | `AppRoutes.noteAdd` | Editor pembuatan catatan akademik baru |
| `/note/edit` | `AppRoutes.noteEdit` | Editor pengeditan catatan akademik |
| `/profile` | `AppRoutes.profile` | Halaman profil dan pengaturan mahasiswa |
| `/profile/edit` | `AppRoutes.profileEdit` | Form pembaruan data profil dan foto |
| `/profile/about` | `AppRoutes.profileAbout` | Halaman informasi tentang TaskFlow |
| `/notification` | `AppRoutes.notification` | Pusat notifikasi aktivitas dan pengingat |
| `/ai` | `AppRoutes.ai` | Antarmuka percakapan asisten belajar Tanya AI |

---

## 🗄️ 3. Skema Data Hive Box

| Box Name | Tipe Model | Adapter Class | TypeId | Keterangan Data |
|---|---|---|---|---|
| `'tasks'` | `TaskModel` | `TaskModelAdapter` | `0` | Daftar tugas, status penyelesaian, tenggat, prioritas, kategori |
| `'attendances'` | `AttendanceModel` | `AttendanceModelAdapter` | `1` | Jadwal kuliah, total pertemuan, riwayat kehadiran, reminder |
| `'notes'` | `NoteModel` | `NoteModelAdapter` | `2` | Catatan akademik, status sematan (pinned), tanggal pembaruan |
| `'notifications'` | `NotificationItemModel` | `NotificationItemModelAdapter` | `3` | Daftar notifikasi sistem, tugas, dan presensi kelas |
