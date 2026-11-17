import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../profile_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final ProfileController controller = Get.find<ProfileController>();

  late TextEditingController nameController;
  late TextEditingController nimController;
  late TextEditingController emailController;
  late TextEditingController majorController;
  late TextEditingController semesterController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: controller.name.value);
    nimController = TextEditingController(text: controller.nim.value);
    emailController = TextEditingController(text: controller.email.value);
    majorController = TextEditingController(text: controller.major.value);
    semesterController = TextEditingController(text: controller.semester.value);
  }

  @override
  void dispose() {
    nameController.dispose();
    nimController.dispose();
    emailController.dispose();
    majorController.dispose();
    semesterController.dispose();
    super.dispose();
  }

  void _save() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Perhatian', 'Nama tidak boleh kosong');
      return;
    }

    controller.updateProfile(
      newName: name,
      newNim: nimController.text.trim(),
      newEmail: emailController.text.trim(),
      newMajor: majorController.text.trim(),
      newSemester: semesterController.text.trim(),
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: const [AppColors.cardShadow],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.primary),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ),
        title: const Text(
          'Edit Data Profil',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppDimens.margin),
                children: [
                  _buildField('NAMA LENGKAP *', nameController),
                  const SizedBox(height: 16),
                  _buildField('NOMOR INDUK MAHASISWA (NIM)', nimController),
                  const SizedBox(height: 16),
                  _buildField('EMAIL KAMPUS', emailController),
                  const SizedBox(height: 16),
                  _buildField('PROGRAM STUDI / JURUSAN', majorController),
                  const SizedBox(height: 16),
                  _buildField('SEMESTER AKTIF', semesterController),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(AppDimens.margin),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                  ),
                ),
                child: const Text('Simpan Perubahan', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.secondary,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimens.radiusInput),
            boxShadow: const [AppColors.cardShadow],
          ),
          child: Center(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

