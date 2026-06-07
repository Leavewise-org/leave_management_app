import '../../domain/entities/leave_entity.dart';
import '../../domain/repositories/leave_repository.dart';
import '../datasources/leave_remote_datasource.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDatasource _remoteDatasource;

  LeaveRepositoryImpl(this._remoteDatasource);

  @override
  Future<LeaveEntity> submitLeave({
    required String userId,
    required String schoolId,
    required String userName,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required bool isHalfDay,
    String? attachmentUrl,
  }) async {
    return await _remoteDatasource.submitLeave(
      userId: userId,
      schoolId: schoolId,
      userName: userName,
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      isHalfDay: isHalfDay,
      attachmentUrl: attachmentUrl,
    );
  }

  @override
  Stream<List<LeaveEntity>> getUserLeaves(String userId) {
    return _remoteDatasource.getUserLeaves(userId);
  }

  @override
  Stream<List<LeaveEntity>> getPendingLeavesBySchool(String schoolId) {
    return _remoteDatasource.getPendingLeavesBySchool(schoolId);
  }

  @override
  Future<void> updateLeaveStatus({
    required String leaveId,
    required String status,
  }) async {
    return await _remoteDatasource.updateLeaveStatus(leaveId, status);
  }
}
