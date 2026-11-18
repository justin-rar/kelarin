# Panduan Kolaborasi Tim Pengembang 🤝
## TaskFlow Mobile (Kelarin)

Panduan ini dibuat secara khusus agar seluruh anggota tim pengembang yang melanjutkan pengerjaan proyek **TaskFlow Mobile** memiliki pemahaman teknis dan visual yang sama, sehingga **tidak merusak (break), mengubah sembarangan, atau menimbulkan galat (error)** pada antarmuka dan arsitektur yang sudah berjalan sempurna.

---

## ⚠️ 1. Aturan Emas Desain (Pantangan Keras / Do's & Don'ts)

Proyek ini menggunakan standar **Google Stitch Monochrome Minimalist Soft-Card System** yang didokumentasikan di [design/DESIGN.md](../design/DESIGN.md).

### ❌ HAL-HAL YANG TIDAK BOLEH DILAKUKAN (DON'TS):
1. **DILARANG menggunakan warna kromat:**
   - Jangan menambahkan warna merah, biru, hijau, ungu, kuning, atau gradien apapun pada tombol, status, atau latar belakang.
   - Status prioritas atau aksi hapus TIDAK menggunakan warna merah, melainkan dibedakan dengan teks/ikon dan kontras monokrom (`— Rendah`, `= Sedang`, `! Tinggi`).
2. **DILARANG mengubah letak filter di Home dan Selesai:**
   - Filter dropdown sudah disepakati berada **tepat di bawah SearchBar** (`CategoryFilterDropdown`).
   - Jangan menambahkan filter dropdown lagi di bagian kanan `PageTitleRow` atas (sudah sengaja dihapus agar tidak ada filter ganda).
   - Jangan mengembalikan `PillTabs` geser horizontal ke Home atau Selesai.
3. **DILARANG menambahkan kategori pada Catatan:**
   - Halaman Catatan **sengaja dibuat bersih tanpa kategori** (tidak ada filter kategori di list dan tidak ada pilihan kategori pada form catatan).
   - Jangan menambahkan chip kategori atau tabs kategori pada modul Catatan.
4. **DILARANG mengubah kontainer tombol titik tiga (More Options):**
   - Tombol titik tiga pada kartu tugas, catatan, dan presensi **wajib berada di dalam kontainer lingkaran 32×32 px dengan warna `AppColors.fill1` (`#EFEFF1`)**.
   - Jangan menjadikannya ikon polos transparan karena akan terlihat menyatu mentah dengan latar kartu.
5. **DILARANG membuat kartu pengingat mepet pinggir:**
   - Komponen `ToggleRow` pada form tugas dan absen wajib memiliki `padding: horizontal 16 px` internal dan kontainer kartunya memiliki `padding: vertical 8 px`.
6. **DILARANG menambah field mahasiswa di form awal profil:**
   - Form awal setup hanya mencakup section **DATA PRIBADI** (hanya `Nama Lengkap *`) dan **PEMULIHAN KUNCI KEAMANAN** (dropdown pertanyaan ke arah bawah + jawaban keamanan), selaras dengan halaman Edit Profil. Jangan menambahkan input NIM, email kampus, atau jurusan di form awal ini.

### ✅ HAL-HAL YANG HARUS DILAKUKAN (DO'S):
1. Selalu gunakan token warna dari `AppColors`:
   - `AppColors.primary` (`#000000`)
   - `AppColors.surface` (`#FFFFFF`)
   - `AppColors.background` (`#F9F9FA`)
   - `AppColors.fill1` (`#EFEFF1`)
   - `AppColors.secondary` (`#5E5E65`)
   - `AppColors.divider` (`#ECECEE`)
2. Selalu gunakan gaya tipografi dari `AppTypography` (*Plus Jakarta Sans*).
3. Gunakan konstanta radius dari `AppDimens` (`radiusCard: 24`, `radiusInput: 16`, `radiusFull: 9999`).
4. Gunakan animasi tekan halus (`AnimatedScale` 0.95 untuk tombol kecil, 0.98–0.99 untuk kartu).

---

## 🧱 2. Arsitektur State Management & Storage (GetX + Hive)

### A. Pola Modul GetX
Setiap modul di dalam `lib/app/modules/` memiliki struktur baku:
```text
modules/
└── [nama_modul]/
    ├── [nama_modul]_binding.dart     <-- Dependency Injection (lazyPut)
    ├── [nama_modul]_controller.dart  <-- State management (GetxController)
    ├── views/                        <-- Antarmuka tampilan (GetView / StatefulWidget)
    └── widgets/                      <-- Komponen spesifik modul
```
- **Aturan:** Jangan memanggil `Get.put()` di dalam callback pembangun `Obx(() => ...)`. Daftarkan controller melalui `Binding` atau ambil di luar `Obx` untuk menghindari siklus render tak terduga.

### B. Penyimpanan Hive Box & Ketahanan Tipe (Mencegah `TypeError`)
Semua model data lokal disimpan di dalam Hive Box melalui `StorageService`:
- `StorageService.taskBox` (tipe `TaskModel`)
- `StorageService.attendanceBox` (tipe `AttendanceModel`)
- `StorageService.noteBox` (tipe `NoteModel`)
- `StorageService.notificationBox` (tipe `NotificationItemModel`)

**PENTING: Jangan gunakan direct type cast yang tidak aman pada Hive Adapter!**
- ❌ **Hindari:** `fields[0] as String` atau `fields[7] as bool` (jika data null atau format lama di memori pengguna, aplikasi akan langsung crash dengan `TypeError`).
- ✅ **Gunakan:**
  ```dart
  id: fields[0]?.toString() ?? '',
  isCompleted: fields[7] == true,
  dateTime: fields[2] is DateTime ? fields[2] as DateTime : DateTime.now(),
  ```

### C. Pengambilan Argument Antar Halaman
Saat berpindah ke halaman edit atau detail:
- ❌ **Hindari:** `final task = Get.arguments as TaskModel;`
- ✅ **Gunakan:**
  ```dart
  if (Get.arguments is TaskModel) {
    task = Get.arguments as TaskModel;
  } else {
    // fallback aman jika argument null atau salah tipe
  }
  ```

---

## 🧭 3. Standar Kategori & Prioritas

Untuk menjaga konsistensi data di seluruh aplikasi, selalu gunakan opsi baku berikut:

### Kategori Tugas (`TaskModel.category`):
1. `'Kuliah'`
2. `'Pekerjaan'`
3. `'Pribadi'`
4. `'Lainnya'`
*(Ditambah opsi `'Semua'` khusus pada dropdown filter pencarian)*

### Prioritas Tugas (`TaskModel.priority`):
1. `'! Tinggi'` (Masuk section *Prioritas Utama*)
2. `'= Sedang'` (Masuk section *Akan Datang*)
3. `'— Rendah'` (Masuk section *Akan Datang*)

### Tipe Kelas Presensi (`AttendanceModel.type`):
1. `'Praktikum'` (Badge hitam)
2. `'Teori'` (Badge abu-abu netral)

---

## 🧪 4. Standar Pengujian Sebelum Melakukan Commit / Pull Request

Sebelum menyerahkan pekerjaan atau menggabungkan kode baru, **wajib** menjalankan dua perintah pengujian berikut di terminal untuk memastikan tidak ada kode yang rusak:

### 1. Periksa Galat dan Peringatan Kode
```bash
flutter analyze lib
```
*Pastikan tidak ada galat (0 error).*

### 2. Jalankan Pengujian Unit Otomatis
```bash
flutter test
```
*Pastikan seluruh 6 test suites lolos (100% passed).*

---

## 📞 5. Hubungi / Acuan Dokumen Lain
- Acuan Desain Spesifik: [design/DESIGN.md](../design/DESIGN.md)
- Struktur File Lengkap: [STRUKTUR_FILE_DAN_MODUL.md](./STRUKTUR_FILE_DAN_MODUL.md)
- Laporan Progres Keseluruhan: [LAPORAN_PROGRESS_AKHIR.md](./LAPORAN_PROGRESS_AKHIR.md)
