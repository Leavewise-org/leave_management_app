import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/leave_entity.dart';

class LeaveModel extends LeaveEntity {
  const LeaveModel({
    required super.id,
    required super.userId,
    required super.schoolId,
    required super.userName,
    required super.leaveType,
    required super.startDate,
    required super.endDate,
    required super.reason,
    required super.status,
    super.attachmentUrl,
    super.isHalfDay = false,
    required super.durationDays,
    required super.createdAt,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json, String id) {
    final startDate = json['startDate'] != null ? (json['startDate'] as Timestamp).toDate() : DateTime.now();
    final endDate = json['endDate'] != null ? (json['endDate'] as Timestamp).toDate() : DateTime.now();
    final isHalfDay = json['isHalfDay'] as bool? ?? false;
    
    // Fallback for old data that didn't store durationDays
    double calculateFallbackDuration() {
      if (isHalfDay) return 0.5;
      final diff = endDate.difference(startDate).inDays;
      return (diff >= 0 ? diff + 1 : 0).toDouble();
    }

    return LeaveModel(
      id: id,
      userId: json['userId'] as String? ?? '',
      schoolId: json['schoolId'] as String? ?? '',
      userName: json['userName'] as String? ?? 'Unknown',
      leaveType: json['leaveType'] as String? ?? '',
      startDate: startDate,
      endDate: endDate,
      reason: json['reason'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      attachmentUrl: json['attachmentUrl'] as String?,
      isHalfDay: isHalfDay,
      durationDays: json['durationDays'] != null 
          ? (json['durationDays'] as num).toDouble() 
          : calculateFallbackDuration(),
      createdAt: json['createdAt'] != null ? (json['createdAt'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'schoolId': schoolId,
      'userName': userName,
      'leaveType': leaveType,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'reason': reason,
      'status': status,
      'attachmentUrl': attachmentUrl,
      'isHalfDay': isHalfDay,
      'durationDays': durationDays,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory LeaveModel.fromEntity(LeaveEntity entity) {
    return LeaveModel(
      id: entity.id,
      userId: entity.userId,
      schoolId: entity.schoolId,
      userName: entity.userName,
      leaveType: entity.leaveType,
      startDate: entity.startDate,
      endDate: entity.endDate,
      reason: entity.reason,
      status: entity.status,
      attachmentUrl: entity.attachmentUrl,
      isHalfDay: entity.isHalfDay,
      durationDays: entity.durationDays,
      createdAt: entity.createdAt,
    );
  }
}
