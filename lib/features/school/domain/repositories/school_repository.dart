import 'package:leave_management_app/features/auth/domain/entities/user_entity.dart';

abstract class SchoolRepository {
  Stream<List<UserEntity>> watchSchoolUsers(String schoolId);
  Future<void> updateUserRole(String userId, String role);
}
