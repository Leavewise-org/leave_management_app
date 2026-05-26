/// Domain entity representing an authenticated user (extends Supabase auth.users).
/// This is a pure Dart class — no Flutter or Supabase imports.
class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    required this.schoolId,
    required this.fullName,
    required this.role,
    this.departmentId,
    this.avatarUrl,
    this.fcmToken,
  });

  /// Supabase auth.users UUID — primary key.
  final String id;

  /// Email used to sign in.
  final String email;

  /// Tenant (school) this user belongs to — enforced by RLS.
  final String schoolId;

  /// Display name from the `profiles` table.
  final String fullName;

  /// One of: employee | manager | school_admin | super_admin
  final String role;

  /// Optional department assignment.
  final String? departmentId;

  /// Remote avatar URL (Supabase Storage).
  final String? avatarUrl;

  /// Firebase Cloud Messaging token for push notifications.
  final String? fcmToken;

  // ── Derived helpers ──────────────────────────────────────────────

  bool get isEmployee => role == 'employee';
  bool get isManager => role == 'manager';
  bool get isSchoolAdmin => role == 'school_admin';
  bool get isSuperAdmin => role == 'super_admin';
  bool get isPending => role == 'pending';

  /// Returns the user's initials for the avatar widget (max 2 chars).
  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  UserEntity copyWith({
    String? id,
    String? email,
    String? schoolId,
    String? fullName,
    String? role,
    String? departmentId,
    String? avatarUrl,
    String? fcmToken,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      schoolId: schoolId ?? this.schoolId,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      departmentId: departmentId ?? this.departmentId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  String toString() =>
      'UserEntity(id: $id, email: $email, role: $role, school: $schoolId)';
}
