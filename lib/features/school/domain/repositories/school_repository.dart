import 'package:leave_management_app/features/auth/domain/entities/user_entity.dart';
import '../entities/school_entity.dart';

abstract class SchoolRepository {
  Stream<List<UserEntity>> watchSchoolUsers(String schoolId);
  Future<void> updateUserRole(String userId, String role);
  Future<SchoolEntity> getSchool(String schoolId);
}
