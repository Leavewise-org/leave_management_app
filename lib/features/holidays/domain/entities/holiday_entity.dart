class HolidayEntity {
  final String id;
  final String name;
  final DateTime date;
  final String type;
  final int year;
  final bool isPublicHoliday;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HolidayEntity({
    required this.id,
    required this.name,
    required this.date,
    required this.type,
    required this.year,
    required this.isPublicHoliday,
    required this.createdAt,
    required this.updatedAt,
  });
}
