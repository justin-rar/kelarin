import 'package:get/get.dart';
import '../../data/models/holiday_model.dart';
import '../../data/services/calendar_service.dart';
import '../../routes/app_routes.dart';

class CalendarController extends GetxController {
  final CalendarService _service = CalendarService();

  final RxList<HolidayModel> holidays = <HolidayModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadHolidays();
  }

  Future<void> loadHolidays() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final list = await _service.fetchUpcomingHolidays();
      holidays.assignAll(list);
    } catch (_) {
      errorMessage.value = 'Gagal memuat kalender libur.';
    } finally {
      isLoading.value = false;
    }
  }

  HolidayModel? get nextHoliday => holidays.isNotEmpty ? holidays.first : null;

  void addHolidayToAgenda(HolidayModel holiday) {
    Get.toNamed(
      AppRoutes.taskAdd,
      arguments: {
        'initialTitle': 'Libur: ${holiday.localName}',
        'initialCategory': 'Pribadi',
        'initialPriority': '— Rendah',
        'initialDate': holiday.parsedDate ?? DateTime.now(),
      },
    );
  }
}
