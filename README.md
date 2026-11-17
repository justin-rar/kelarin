# TaskFlow Mobile (Kelarin) 📱

Aplikasi mobile produktivitas akademik terpadu yang dirancang khusus untuk mahasiswa. Memadukan manajemen tugas & tenggat waktu (*to-do list*), rekapitulasi riwayat tugas selesai, pelacakan presensi kuliah, editor catatan akademik berbasis template, serta asisten studi cerdas (*Tanya AI*).

Dibuat untuk memenuhi spesifikasi **Praktikum Pemrograman Aplikasi Mobile (Semester 5)** dengan standar desain **Google Stitch Monochromatic Minimalist Soft-Card System** dan arsitektur **GetX + Hive**.

---

## ✨ Fitur Utama

1. **Dashboard Overview (Home)**
   - **StatGrid (2×2 Metrics)**: Penghitungan otomatis realtime untuk *Hari Ini*, *Terjadwal*, *Prioritas*, dan *Semua Tugas* dengan ornamen grafis *sine-wave*.
   - **Pencarian Realtime**: Pencarian instan berdasarkan judul tugas, catatan, atau ruangan.
   - **PillTabs Filter**: Filter kategori tugas (*Semua*, *Hari Ini*, *Kuliah*, *Pekerjaan*, *Pribadi*, *Kesehatan*) dengan badge count realtime.
   - **Pengelompokan Prioritas**: Memisahkan section *Prioritas Utama* (`! Tinggi`) dan *Akan Datang* (`= Sedang`, `— Rendah`).
   - **Aksi Cepat**: Menu edit, hapus, dan checklist tugas.

2. **Rekap Selesai (Tab 2)**
   - Daftar riwayat tugas yang sudah tuntas dengan teks *strikethrough* dan checkbox hitam.
   - Tombol satu-sentuhan untuk membatalkan/mengurungkan status tugas selesai (*undo completion*).
   - Opsi pembersihan riwayat selesai secara aman.

3. **Presensi & Jadwal Kuliah (Tab 3)**
   - Pelacakan jadwal kelas praktikum (badge hitam) dan kelas teori (badge netral).
   - Indikator persentase kehadiran (misal: *10/14 Pertemuan - 71%*) dan tombol *Catat Hadir Minggu Ini*.
   - Sakelar pengingat kelas (*class reminder switch*).
   - Form tambah jadwal mata kuliah baru.

4. **Catatan Akademik & Template Ringkas (Tab 4)**
   - Manajemen catatan kuliah dengan fitur **Sematkan ke Atas (Pinned Notes)**.
   - **3 Template Akademik Cepat**:
     - *Ringkasan Materi Kuliah*
     - *Instruksi Tugas Kuliah*
     - *Catatan Lab & Praktikum (Troubleshooting & Snippet Kode)*
   - Editor catatan terstruktur dengan penghitung kata/karakter.

5. **Tanya AI (Asisten Studi Cerdas)**
   - Menganalisis daftar tugas aktif secara otomatis dan memberikan rekomendasi jadwal belajar terstruktur.
   - Tombol interaktif **`+ Tambahkan ke Jadwal Tugas`** untuk langsung menyuntikkan sesi belajar ke database Hive dan mengupdate tampilan Home.
   - Quick prompt suggestions: *Jadwal belajar hari ini*, *Prioritas deadline terdekat*, dan *Tips responsi PAM*.

6. **Keamanan & Personalisasi**
   - Kunci keamanan PIN 4-digit dengan keypad numerik lokal.
   - Layar Splash interaktif dengan validasi PIN otomatis.
   - Pengaturan profil mahasiswa (Nama, NIM, Email, Program Studi, Semester).
   - Floating SnackBar / Toast dengan aksi *Urungkan (Undo)* untuk setiap operasi penting.

---

## 🛠️ Teknologi & Arsitektur

- **Framework**: Flutter 3.47 / Dart 3.13
- **State & Route Management**: [GetX](https://pub.dev/packages/get) (`GetMaterialApp`, `GetxController`, `Rx`, `Obx`, `Bindings`, `GetPage`)
- **Basis Data Lokal**: [Hive](https://pub.dev/packages/hive) & [hive_flutter](https://pub.dev/packages/hive_flutter) (TypeAdapter terdaftar untuk Task, Attendance, Note, dan Notification)
- **Sesi & Keamanan**: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Notifikasi**: [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) dengan Java Core Library Desugaring
- **Desain UI**: Google Stitch Design System ID `12778491443419006802`
- **Tipografi**: Plus Jakarta Sans via [google_fonts](https://pub.dev/packages/google_fonts)

---

## 🚀 Cara Menjalankan Proyek

1. **Clone repositori**:
   ```bash
   git clone https://github.com/justin-rar/kelarin.git
   cd kelarin
   ```

2. **Pasang dependensi**:
   ```bash
   flutter pub get
   ```

3. **Jalankan emulator / perangkat mobile**:
   ```bash
   flutter run
   ```

---

## 📄 Lisensi & Kredit
Dikembangkan untuk keperluan akademik Mata Kuliah **Praktikum Pemrograman Aplikasi Mobile (PAM)**, Jurusan Sistem Informasi / Informatika, UPN "Veteran" Yogyakarta.
