import 'package:leave_management_app/features/leave/domain/entities/leave_entity.dart';

abstract class LeaveRepository {
  /// Submits a new leave request. Returns the created LeaveEntity.
  Future<LeaveEntity> submitLeave({
    required String userId,
    required String schoolId,
    required String userName,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    String? attachmentUrl,
  });

  /// Returns a stream of leaves for a specific user.
  Stream<List<LeaveEntity>> getUserLeaves(String userId);

  /// Returns a stream of pending leaves for a whole school (for managers).
  Stream<List<LeaveEntity>> getPendingLeavesBySchool(String schoolId);

  /// Updates the status of a leave request (e.g. approve/reject).
  Future<void> updateLeaveStatus({
    required String leaveId,
    required String status,
  });
}
