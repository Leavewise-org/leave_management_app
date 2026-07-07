import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leave_management_app/features/leave/data/models/leave_model.dart';
import '../../../../core/error/failures.dart';

class LeaveRemoteDatasource {
  final FirebaseFirestore _firestore;

  LeaveRemoteDatasource(this._firestore);

  CollectionReference<Map<String, dynamic>> get _leavesCollection =>
      _firestore.collection('leave_requests');

  Future<LeaveModel> submitLeave({
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
    try {
      final now = DateTime.now();
      final docRef = _leavesCollection.doc();
      
      final leaveModel = LeaveModel(
        id: docRef.id,
        userId: userId,
        schoolId: schoolId,
        userName: userName,
        leaveType: leaveType,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
        status: 'pending',
        attachmentUrl: attachmentUrl,
        isHalfDay: isHalfDay,
        createdAt: now,
      );

      await docRef.set(leaveModel.toJson());
      return leaveModel;
    } catch (e) {
      throw ServerFailure('Failed to submit leave: $e');
    }
  }

  Stream<List<LeaveModel>> getUserLeaves(String userId) {
    return _leavesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => LeaveModel.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  Stream<List<LeaveModel>> getPendingLeavesBySchool(String schoolId) {
    return _leavesCollection
        .where('schoolId', isEqualTo: schoolId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      final docs = snapshot.docs
          .map((doc) => LeaveModel.fromJson(doc.data(), doc.id))
          .toList();
      docs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return docs;
    });
  }

  Stream<List<LeaveModel>> getLeavesBySchool(String schoolId) {
    return _leavesCollection
        .where('schoolId', isEqualTo: schoolId)
        .snapshots()
        .map((snapshot) {
      final docs = snapshot.docs
          .map((doc) => LeaveModel.fromJson(doc.data(), doc.id))
          .toList();
      docs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return docs;
    });
  }

  Future<void> updateLeaveStatus(String leaveId, String status) async {
    try {
      await _leavesCollection.doc(leaveId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerFailure('Failed to update leave status: $e');
    }
  }
}
