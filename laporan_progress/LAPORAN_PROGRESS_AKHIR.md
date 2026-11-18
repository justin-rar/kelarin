# LAPORAN PROGRES AKHIR PENGEMBANGAN APLIKASI
## TaskFlow Mobile (Kelarin) - Academic Productivity App

**Tanggal Pembaruan:** 19 November 2026  
**Versi Aplikasi:** v1.0.0 (Build 240)  
**Target Platform:** Mobile (Android & iOS)  
**Framework & Bahasa:** Flutter 3.50+ / Dart 3.14+  
**Arsitektur:** GetX Pattern (State Management, Routing, Dependency Injection) + Hive NoSQL Local Storage  
**Panduan Desain Utama:** [design/DESIGN.md](../design/DESIGN.md)  

---

## 1. Ringkasan Eksekutif

Aplikasi **TaskFlow Mobile (Kelarin)** telah mencapai status fungsional penuh (**100% Core Requirements Implemented**). Seluruh kebutuhan fungsional (manajemen tugas, rekap selesai, pelacakan presensi kuliah, editor catatan, asisten AI jadwal, keamanan PIN, dan notifikasi lokal) telah selesai diimplementasikan, teruji bebas galat tipe runtime (*null-safe & type-safe*), dan mematuhi standar desain monokromatis minimalis Google Stitch.

### Indikator Keberhasilan Teknis:
- **Analisis Statis (`dart analyze lib`)**: **0 Error**, kode bersih dan terstandarisasi.
- **Pengujian Unit (`flutter test`)**: **6/6 Suites Passed (100%)**, mencakup validasi dummy data, serialisasi model, token warna monokrom, logika verifikasi PIN & *recovery*, kalkulasi unread notifikasi, serta ketahanan adapter Hive terhadap data null/malformed.
- **Konsistensi UI**: 100% monokrom tanpa warna kromat, menggunakan tipografi *Plus Jakarta Sans*, radius kartu 24 px, dan sistem bayangan difus lembut (*soft-card elevation*).

---

## 2. Status Implementasi Fitur

### A. Modul Otentikasi & Keamanan (PIN Protection & Onboarding)
- [x] **Form Awal Data Pribadi & Pemulihan (Setup Awal)**:
  - Section **DATA PRIBADI**: Hanya mencakup *Nama Lengkap \** (selaras dengan halaman Edit Profil, tanpa meminta data kampus/NIM/Email di form awal).
  - Section **PEMULIHAN KUNCI KEAMANAN**:
    - Dropdown *Pertanyaan Keamanan \** yang membuka ke arah bawah (`PopupMenuPosition.under`) dengan border radius 16 px dan bayangan lembut.
    - Field *Informasi Pribadi (Pemulihan PIN) \** dengan fitur sembunyikan/tampilkan password (*obscure toggle*).
- [x] **Keypad Numerik Lokal Monokrom**: Keypad kustom 4-digit dengan umpan balik visual (*dot indicator* aktif/kosong).
- [x] **Alur Fleksibel**:
  - Validasi PIN saat aplikasi dibuka (Splash screen check).
  - Setup PIN baru bagi pengguna pertama kali setelah mengisi nama dan pemulihan keamanan.
  - Ubah PIN lama dengan verifikasi PIN sebelumnya.
  - Nonaktifkan PIN melalui dialog konfirmasi aman.
- [x] **Riwayat PIN (Anti-Reuse)**: Mencegah pengguna menggunakan kembali PIN yang pernah dipakai sebelumnya.
- [x] **Lupa PIN & Pemulihan Akun**: Verifikasi identitas melalui jawaban keamanan terdaftar sebelum mengizinkan setel ulang PIN.

### B. Modul Navigasi Utama (Main Navigation)
- [x] **Floating Bottom Navigation Bar**:
  - Kontainer melayang setinggi 72 px, radius 32 px, margin horizontal 20 px dengan bayangan lembut.
  - 5 slot: **Home**, **Selesai**, **Tombol Tengah Aksi Cepat (+)**, **Absen**, dan **Catatan**.
  - Indikator tab aktif: Ikon & teks berwarna hitam (`primary`) dengan dot hitam 4 px di bawah label.
- [x] **Aksi Cepat (Quick Action Sheet)**:
  - Muncul melayang di atas *scrim* hitam 40% ber-blur saat tombol tengah (+) disentuh.
  - Tiga pintasan cepat: *Tambah Tugas*, *Tambah Absen*, dan *Catatan Baru*.

### C. Modul Dashboard / Beranda (Home Overview)
- [x] **AppHeader Dinamis**:
  - Avatar pengguna dengan inisial nama atau foto profil lokal.
  - Teks sapaan "Selamat datang" dan nama mahasiswa.
  - Tombol Sparkle Tanya AI (`auto_awesome`).
  - Tombol Lonceng Notifikasi dengan **Badge Unread Dinamis** (otomatis sembunyi saat 0, menampilkan jumlah belum dibaca, atau `99+`).
- [x] **StatGrid 2-Tile**:
  - Tile 1 (`stat-light`): Jumlah tugas prioritas tinggi aktif.
  - Tile 2 (`stat-dark`): Total seluruh tugas aktif.
- [x] **Pencarian Realtime**: Input 48 px untuk memfilter tugas seketika berdasarkan judul, lokasi, kategori, atau catatan.
- [x] **CategoryFilterDropdown (Pembaruan Terkini)**:
  - Menggantikan *PillTabs* lama yang membingungkan dan menghilangkan filter ganda di `PageTitleRow`.
  - Terletak tepat di bawah search bar, tinggi 48 px, background putih, radius 16 px dengan ikon kategori dan chevron ke bawah.
  - Kategori standar: `'Semua'`, `'Kuliah'`, `'Pekerjaan'`, `'Pribadi'`, `'Lainnya'`.
- [x] **Section Grouping & TaskCard**:
  - Section *Prioritas Utama* (`! Tinggi`) dan *Akan Datang* (`= Sedang`, `— Rendah`).
  - Checkbox lingkaran interaktif 24 px (beranimasi centang hitam saat selesai).
  - Chip kategori dan prioritas abu-abu muda (`fill-1`).
  - **Tombol Tiga Titik 32×32 px**: Menggunakan kontainer lingkaran `fill-1` terdedikasi untuk memicu menu popover (opsi: Edit dan Hapus).

### D. Modul Manajemen Tugas (Task Management)
- [x] **Tambah Tugas (`AddTaskView`)**:
  - Input judul, tanggal, dan jam pelaksanaan.
  - Segmented selector 2×2 untuk kategori (`Kuliah`, `Pekerjaan`, `Pribadi`, `Lainnya`).
  - Segmented selector 3 kolom untuk prioritas (`— Rendah`, `= Sedang`, `! Tinggi`).
  - Kartu Pengingat (`ToggleRow`) dengan 5 opsi: 1 hari, 12 jam, 6 jam, 3 jam, 1 jam sebelum tenggat (padding rapi berjarak anti-mepet).
  - Input catatan tambahan.
  - Tombol melayang *Simpan Tugas* dan *Batal*.
- [x] **Edit Tugas (`EditTaskView`)**:
  - Memuat data lama secara aman (*safe type casting*).
  - Tombol *Hapus Tugas* pada bagian bawah form.
- [x] **Detail Tugas (`TaskDetailView`)**:
  - Menampilkan ringkasan status, tenggat waktu, lokasi, sisa waktu, serta pengingat aktif.
  - Aksi *Tandai Selesai*, *Edit Tugas*, dan *Hapus Tugas*.
- [x] **Rekap Selesai (`CompletedTasksView` - Tab 2)**:
  - StatGrid 4-Tile checkerboard (Selesai, Hari Ini, Bulan Ini, % Tepat Waktu) dengan dekorasi grafis *sine-wave*.
  - Filter dropdown tunggal di bawah search bar selaras dengan Home.
  - Kartu tugas selesai dengan judul *strikethrough* dan tombol *Undo* (kembalikan ke tugas aktif) satu sentuhan.

### E. Modul Presensi & Jadwal Kuliah (Attendance - Tab 3)
- [x] **Presensi Aktif (`AttendanceView`)**:
  - Eyebrow header "JADWAL KITA" dengan judul "Presensi Aktif" dan pill hitungan mata kuliah.
  - Kartu mata kuliah (`CourseCard`): Badge tipe (Praktikum hitam, Teori abu-abu), ruangan, kelas, serta status sakelar pengingat.
  - Tombol pencatatan kehadiran instan (+1 pertemuan) hingga kuota maksimal pertemuan (14 sesi).
  - Menu tiga titik dengan tombol kontainer 32×32 px untuk menghapus jadwal.
- [x] **Tambah Jadwal Presensi (`AddAttendanceView`)**:
  - Input nama mata kuliah, kelas, ruangan, hari, dan jam.
  - Pilihan tipe kelas (Praktikum / Teori).
  - Kartu notifikasi kehadiran (Saat kuliah dimulai, 15 menit sebelum, 30 menit sebelum) dengan padding `ToggleRow` yang rapi.

### F. Modul Catatan Akademik (Notes - Tab 4)
- [x] **Daftar Catatan Bersih (`NoteView`)**:
  - Tampilan minimalis tanpa kategori dan tanpa filter ganda.
  - Pemisahan section: *Catatan Tersemat (Pinned)* dan *Catatan Lainnya*.
  - `NoteCard`: Menampilkan pill waktu/tanggal, ikon pin, judul, preview ringkasan teks 2 baris, dan tombol 3 titik 32×32 px (Hanya opsi Hapus).
- [x] **Editor Catatan (`AddNoteView` & `EditNoteView`)**:
  - Status tersimpan otomatis (*autosave timestamp*).
  - 3 Template Akademik Cepat: *Ringkasan Materi*, *Instruksi Tugas*, dan *Catatan Lab/Praktikum*.
  - Toolbar pemformatan kustom (Bold, bullet list, checklist, pin, gambar, tag Markdown).
  - Penghitung kata (*word counter*) realtime.
  - Opsi hapus draf/catatan dan sematkan catatan.

### G. Modul Asisten Belajar (Tanya AI)
- [x] **Antarmuka Tanya AI (`TanyaAiView`)**:
  - Top bar monokrom dengan status model aktif.
  - Saran pertanyaan cepat (*quick prompts*): Jadwal kuliah hari ini, rencana belajar ujian, dan prioritas deadline.
  - Bubble percakapan monokrom (User: hitam dengan ekor kanan; AI: putih dengan avatar sparkle).
  - **Generator Rencana Belajar Terstruktur**: AI menyusun sesi belajar dengan jam dan durasi spesifik.
  - **Tombol Satu Sentuhan `+ Tambahkan ke Daftar Tugas`**: Langsung mengonversi rekomendasi AI menjadi tugas riil di database Hive dan muncul otomatis di Beranda.

### H. Modul Profil, Pengaturan & Notifikasi
- [x] **Profil Mahasiswa (`ProfileView`)**:
  - Kartu identitas mahasiswa (Nama, NIM, Email, Jurusan, Semester).
  - Pengaturan keamanan PIN (Toggle PIN, Ganti PIN).
  - Tombol Edit Profil dan Keluar Akun.
- [x] **Edit Profil (`EditProfileView`)**:
  - Pembaruan nama, email, NIM, jurusan, semester, serta foto profil.
- [x] **Tentang Aplikasi (`AboutView`)**:
  - Informasi build, deskripsi aplikasi, tautan kebijakan privasi, dan dukungan.
- [x] **Pusat Notifikasi (`NotificationView`)**:
  - Segmented tab *Semua* dan *Belum Dibaca*.
  - Kartu notifikasi berbasis waktu relatif ("15 menit lagi", "Kemarin").
  - Menandai terbaca otomatis saat diklik.
  - Fitur *Tandai Semua Dibaca* dan *Bersihkan Notifikasi* dengan opsi Undo.

---

## 3. Rangkuman Perbaikan & Refinement Terkini

Berdasarkan tinjauan dan evaluasi langsung dari pengguna, serangkaian penyempurnaan krusial telah diterapkan:

| Bagian | Kondisi Sebelumnya | Kondisi Terkini (Final) |
|---|---|---|
| **Filter Home** | Ada dropdown "Minggu Ini" di header atas + PillTabs geser horisontal yang memakan ruang. | Filter atas dihapus. Digantikan oleh **satu `CategoryFilterDropdown`** di bawah SearchBar (`Semua`, `Kuliah`, `Pekerjaan`, `Pribadi`, `Lainnya`). |
| **Filter Selesai** | Terdapat dropdown di title row atas dan filter periode waktu yang redundant. | Diselaraskan 100% dengan Home: filter atas dihapus, hanya ada satu dropdown kategori di bawah SearchBar. |
| **Filter Catatan** | Terdapat dropdown dan chip kategori pada kartu catatan. | **Semua kategori pada catatan dihapus.** Halaman catatan kini fokus murni pada konten, waktu, judul, dan status pin. |
| **Tombol 3 Titik** | Ikon tiga titik polos tanpa latar tampak menyatu dengan kartu (*cluttered*). | Menggunakan **kontainer lingkaran 32×32 px `fill-1` (`#EFEFF1`)** pada seluruh kartu (`TaskCard`, `NoteCard`, `AttendanceCard`) dengan popover beradius 16 px dan bayangan lembut. |
| **Padding Pengingat** | Kontainer kartu pengingat pada form tugas dan absen tampak mepet ke pinggir (*cramped*). | Ditambahkan padding vertikal 8 px pada kontainer kartu dan padding horizontal 16 px pada setiap `ToggleRow`, serta indent 16 px pada divider garis pemisah. |
| **Badge Notifikasi** | Angka badge lonceng pada header sempat statis '2'. | Terhubung secara reaktif (`Obx`) ke `NotificationController.unreadCount`. Otomatis tersembunyi jika 0, dan menampilkan angka aktual / `99+`. |
| **Form Data Awal** | Label bertuliskan "Data Pribadi Mahasiswa" dengan input rumit dan dropdown pertanyaan keamanan popup ke atas. | Disederhanakan menjadi "Data Pribadi" (Nama Lengkap saja), dan dropdown pertanyaan keamanan disetel ke bawah (`DropdownMenu` / downward direction). |
| **Unggah Foto Profil** | Mengalami error/crash saat memilih foto lewat kamera/galeri pada perangkat emulator/desktop serta device tanpa izin. | Menambahkan permission Android (`CAMERA`, `READ_MEDIA_IMAGES`, `READ_EXTERNAL_STORAGE`), fallback otomatis kamera ke galeri bila tidak didukung, safe check `File.existsSync()`, dan `errorBuilder` inisial fallback yang anti-crash. |
| **Profil & Lupa PIN** | Pada halaman profil masih menampilkan subtitle email dan semester, serta dialog lupa PIN meminta NIM & email yang tidak didaftarkan. | Subtitle email dan semester dihapus dari profil utama (tampil bersih: Avatar, Nama, dan Tombol Edit Profil). Pemulihan PIN diselaraskan murni memverifikasi pertanyaan keamanan yang terdaftar. |
| **Stabilitas Tipe** | Terdapat potensi `TypeError` dari unsafe cast Hive adapter dan arguments navigasi. | Seluruh adapter dan argument view diamankan dengan safe parsing (`fields[x]?.toString()`, `int.tryParse`, fallback default) sehingga **bebas dari crash TypeError**. |

---

## 4. Hasil Verifikasi & Pengujian Otomatis

### 1. `dart analyze lib`
```text
Analyzing lib...
0 issues found (with 0 errors).
```

### 2. `flutter test`
```text
00:00 +0: DummyDataService provides initial tasks matching Stitch specs
00:00 +1: TaskModel serializes and deserializes correctly
00:00 +2: Design system color tokens match monochrome specifications
00:00 +3: PIN history and recovery verification logic behaves correctly
00:00 +4: Notification unread count accurately calculates unread items
00:00 +5: All model adapters and deserializers resist null and type mismatch without TypeError
00:00 +6: All tests passed!
```

---

## 5. Kesimpulan & Langkah Selanjutnya

Aplikasi telah siap digunakan (*production ready* untuk konteks praktikum/prototipe akademik). Setiap komponen visual dan logika backend lokal telah dikunci sesuai standar. Dokumen [PANDUAN_KOLABORASI_TIM.md](./PANDUAN_KOLABORASI_TIM.md) dan [DESIGN.md](../design/DESIGN.md) dapat dijadikan acuan utama bagi rekan tim untuk melanjutkan atau mempresentasikan proyek ini.
