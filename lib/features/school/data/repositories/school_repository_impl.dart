import 'package:leave_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:leave_management_app/features/school/data/datasources/school_remote_datasource.dart';
import 'package:leave_management_app/features/school/domain/repositories/school_repository.dart';

class SchoolRepositoryImpl implements SchoolRepository {
  const SchoolRepositoryImpl(this._datasource);

  final SchoolRemoteDatasource _datasource;

  @override
  Stream<List<UserEntity>> watchSchoolUsers(String schoolId) {
    return _datasource.watchSchoolUsers(schoolId);
  }

  @override
  Future<void> updateUserRole(String userId, String role) {
    return _datasource.updateUserRole(userId, role);
  }
}
