import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:leave_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:leave_management_app/features/school/domain/entities/school_entity.dart';
import 'package:leave_management_app/features/school/data/datasources/school_remote_datasource.dart';
import 'package:leave_management_app/features/school/data/repositories/school_repository_impl.dart';
import 'package:leave_management_app/features/school/domain/repositories/school_repository.dart';

final schoolRemoteDatasourceProvider = Provider<SchoolRemoteDatasource>((ref) {
  return SchoolRemoteDatasource(FirebaseFirestore.instance);
});

final schoolRepositoryProvider = Provider<SchoolRepository>((ref) {
  final datasource = ref.watch(schoolRemoteDatasourceProvider);
  return SchoolRepositoryImpl(datasource);
});

final schoolUsersProvider = StreamProvider.autoDispose.family<List<UserEntity>, String>((ref, schoolId) {
  final repository = ref.watch(schoolRepositoryProvider);
  return repository.watchSchoolUsers(schoolId);
});

final currentSchoolProvider = FutureProvider<SchoolEntity?>((ref) async {
  final authUser = await ref.watch(authStateProvider.future);
  if (authUser == null || authUser.schoolId.isEmpty) return null;
  final repository = ref.watch(schoolRepositoryProvider);
  return await repository.getSchool(authUser.schoolId);
});
