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
  final bool isHalfDay;
  final double durationDays; // Now explicitly stored
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
    this.isHalfDay = false,
    required this.durationDays,
    required this.createdAt,
  });
}
