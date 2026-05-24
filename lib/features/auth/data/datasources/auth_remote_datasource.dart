import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

/// Encapsulates all direct Firebase calls for authentication.
/// The repository implementation delegates here.
class AuthRemoteDatasource {
  const AuthRemoteDatasource(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  // ── Sign In ──────────────────────────────────────────────────────

  /// Signs in with email/password. Returns [UserEntity] on success.
  /// Throws [FirebaseAuthException] from Firebase on failure.
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final authUser = response.user;
    if (authUser == null) {
      throw FirebaseAuthException(code: 'sign-in-failed', message: 'Sign-in failed: no user returned.');
    }

    return _fetchProfile(authUser);
  }

  // ── Sign Up ──────────────────────────────────────────────────────

  /// Signs up a new user with email, password, and metadata.
  /// Throws [FirebaseAuthException] from Firebase on failure.
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String fullName,
    required String schoolSlug,
  }) async {
    final response = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final authUser = response.user;
    if (authUser == null) {
      throw FirebaseAuthException(code: 'sign-up-failed', message: 'Sign-up failed: no user returned.');
    }

    // Resolve school ID from school slug.
    // In a real app, you would query the 'schools' collection.
    // For now we'll write the slug as schoolId since the db is empty
    String schoolId = schoolSlug;
    try {
      final schoolQuery = await _firestore.collection('schools').where('slug', isEqualTo: schoolSlug).limit(1).get();
      if (schoolQuery.docs.isNotEmpty) {
        schoolId = schoolQuery.docs.first.id;
      }
    } catch (_) {}

    await _firestore.collection('profiles').doc(authUser.uid).set({
      'full_name': fullName,
      'school_id': schoolId,
      'role': 'employee',
    });

    return _fetchProfile(authUser);
  }

  // ── Sign Out ─────────────────────────────────────────────────────

  Future<void> signOut() => _auth.signOut();

  // ── Current User ─────────────────────────────────────────────────

  /// Returns the currently cached [UserEntity] or `null` if unauthenticated.
  Future<UserEntity?> getCurrentUser() async {
    final authUser = _auth.currentUser;
    if (authUser == null) return null;
    try {
      return await _fetchProfile(authUser);
    } catch (_) {
      return null;
    }
  }

  // ── Auth State Stream ────────────────────────────────────────────

  /// Emits [UserEntity] when a session is active, `null` otherwise.
  Stream<UserEntity?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((authUser) async {
      if (authUser == null) return null;
      try {
        return await _fetchProfile(authUser);
      } catch (_) {
        return null;
      }
    });
  }

  // ── Private Helpers ──────────────────────────────────────────────

  /// Fetches the matching `profiles` document and builds a [UserEntity].
  Future<UserEntity> _fetchProfile(User authUser) async {
    final doc = await _firestore.collection('profiles').doc(authUser.uid).get();

    return UserModel.fromFirebase(
      authUser: authUser,
      profileDoc: doc,
    ).toEntity();
  }
}
