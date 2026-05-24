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
    required super.createdAt,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json, String id) {
    return LeaveModel(
      id: id,
      userId: json['userId'] as String? ?? '',
      schoolId: json['schoolId'] as String? ?? '',
      userName: json['userName'] as String? ?? 'Unknown',
      leaveType: json['leaveType'] as String? ?? '',
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      reason: json['reason'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      attachmentUrl: json['attachmentUrl'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
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
      createdAt: entity.createdAt,
    );
  }
}
