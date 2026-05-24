class LeaveEntity {
  final String id;
  final String userId;
  final String schoolId;
  final String userName;
  final String leaveType; // 'Annual Leave', 'Sick Leave', etc.
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status; // 'pending', 'approved', 'rejected'
  final String? attachmentUrl;
  final DateTime createdAt;

  const LeaveEntity({
    required this.id,
    required this.userId,
    required this.schoolId,
    required this.userName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.attachmentUrl,
    required this.createdAt,
  });

  /// Duration in days (inclusive). Returns 1 if start and end are the same day.
  int get durationDays {
    final diff = endDate.difference(startDate).inDays;
    return diff >= 0 ? diff + 1 : 0;
  }
}
