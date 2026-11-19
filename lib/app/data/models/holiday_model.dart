class HolidayModel {
  final String date;
  final String localName;
  final String name;
  final String countryCode;
  final bool isGlobal;

  HolidayModel({
    required this.date,
    required this.localName,
    required this.name,
    this.countryCode = 'ID',
    this.isGlobal = true,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      date: json['date']?.toString() ?? '',
      localName: json['localName']?.toString() ??
          json['name']?.toString() ??
          'Hari Libur',
      name: json['name']?.toString() ?? '',
      countryCode: json['countryCode']?.toString() ?? 'ID',
      isGlobal: json['global'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'localName': localName,
      'name': name,
      'countryCode': countryCode,
      'global': isGlobal,
    };
  }

  DateTime? get parsedDate {
    try {
      return DateTime.parse(date);
    } catch (_) {
      return null;
    }
  }

  int get daysUntil {
    final dt = parsedDate;
    if (dt == null) return 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dt.year, dt.month, dt.day);
    return target.difference(today).inDays;
  }

  String get countdownText {
    final days = daysUntil;
    if (days < 0) return 'Telah lewat';
    if (days == 0) return 'Hari ini!';
    if (days == 1) return 'Besok!';
    if (days < 30) return '$days hari lagi';
    final months = (days / 30).floor();
    return '$months bulan lagi ($days hari)';
  }

  String get formattedDateIndo {
    final dt = parsedDate;
    if (dt == null) return date;
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    final dayName = days[dt.weekday - 1];
    final monthName = months[dt.month - 1];
    return '$dayName, ${dt.day} $monthName ${dt.year}';
  }

  String get shortDateIndo {
    final dt = parsedDate;
    if (dt == null) return date;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    final monthName = months[dt.month - 1];
    return '${dt.day} $monthName';
  }
}
