import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/holiday_entity.dart';

class HolidayModel extends HolidayEntity {
  const HolidayModel({
    required super.id,
    required super.name,
    required super.date,
    required super.type,
    required super.year,
    required super.isPublicHoliday,
    required super.createdAt,
    required super.updatedAt,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json, String id) {
    return HolidayModel(
      id: id,
      name: json['name'] as String? ?? '',
      date: json['date'] != null ? (json['date'] as Timestamp).toDate() : DateTime.now(),
      type: json['type'] as String? ?? 'National',
      year: json['year'] as int? ?? DateTime.now().year,
      isPublicHoliday: json['isPublicHoliday'] as bool? ?? true,
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? (json['updatedAt'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': Timestamp.fromDate(date),
      'type': type,
      'year': year,
      'isPublicHoliday': isPublicHoliday,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory HolidayModel.fromEntity(HolidayEntity entity) {
    return HolidayModel(
      id: entity.id,
      name: entity.name,
      date: entity.date,
      type: entity.type,
      year: entity.year,
      isPublicHoliday: entity.isPublicHoliday,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
