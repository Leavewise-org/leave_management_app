import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leave_management_app/features/auth/data/models/user_model.dart';
import 'package:leave_management_app/features/auth/domain/entities/user_entity.dart';

class SchoolRemoteDatasource {
  const SchoolRemoteDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  Stream<List<UserEntity>> watchSchoolUsers(String schoolId) {
    return _firestore
        .collection('profiles')
        .where('school_id', isEqualTo: schoolId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromProfileDoc(doc).toEntity())
          .toList();
    });
  }

  Future<void> updateUserRole(String userId, String role) async {
    await _firestore.collection('profiles').doc(userId).update({'role': role});
  }
}
