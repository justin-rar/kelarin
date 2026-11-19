import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/core/theme/app_theme.dart';
import 'app/data/services/notification_service.dart';
import 'app/data/services/storage_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi locale Bahasa Indonesia untuk DateFormat
  await initializeDateFormatting('id_ID', null);

  // 1. Inisialisasi Service Penyimpanan Lokal (Hive & SharedPreferences)
  await Get.putAsync(() => StorageService().init());

  // 2. Inisialisasi Notifikasi Lokal
  await Get.putAsync(() => NotificationService().init());

  runApp(const KelarinApp());
}

class KelarinApp extends StatelessWidget {
  const KelarinApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sesuai materi Modul VIII: Menggunakan GetMaterialApp untuk GetX
    return GetMaterialApp(
      title: 'Kelarin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
    );
  }
}
