import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

/// Data model that maps the `profiles` collection document + Firebase auth user
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
  /// - [authUser] — the Firebase `User` (provides id + email)
  /// - [profileDoc] — a document from the `profiles` collection
  factory UserModel.fromFirebase({
    required User authUser,
    required DocumentSnapshot<Map<String, dynamic>> profileDoc,
  }) {
    final data = profileDoc.data() ?? {};
    return UserModel(
      id: authUser.uid,
      email: authUser.email ?? '',
      schoolId: data['school_id'] as String? ?? 'unknown',
      fullName: data['full_name'] as String? ?? 'Unknown User',
      role: data['role'] as String? ?? 'employee',
      departmentId: data['department_id'] as String?,
      avatarUrl: data['avatar_url'] as String?,
      fcmToken: data['fcm_token'] as String?,
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
