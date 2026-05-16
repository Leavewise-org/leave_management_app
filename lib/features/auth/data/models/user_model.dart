import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';

/// Data model that maps the `profiles` table row + Supabase auth user
/// into a domain [UserEntity].
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.schoolId,
    required this.fullName,
    required this.role,
    this.departmentId,
    this.avatarUrl,
    this.fcmToken,
  });

  final String id;
  final String email;
  final String schoolId;
  final String fullName;
  final String role;
  final String? departmentId;
  final String? avatarUrl;
  final String? fcmToken;

  /// Builds a [UserModel] from:
  /// - [authUser] — the Supabase `auth.User` (provides id + email)
  /// - [profileRow] — a row from the `profiles` table
  factory UserModel.fromSupabase({
    required User authUser,
    required Map<String, dynamic> profileRow,
  }) {
    return UserModel(
      id: authUser.id,
      email: authUser.email ?? '',
      schoolId: profileRow['school_id'] as String,
      fullName: profileRow['full_name'] as String,
      role: profileRow['role'] as String? ?? 'employee',
      departmentId: profileRow['department_id'] as String?,
      avatarUrl: profileRow['avatar_url'] as String?,
      fcmToken: profileRow['fcm_token'] as String?,
    );
  }

  /// Converts to the domain entity.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      schoolId: schoolId,
      fullName: fullName,
      role: role,
      departmentId: departmentId,
      avatarUrl: avatarUrl,
      fcmToken: fcmToken,
    );
  }
}
