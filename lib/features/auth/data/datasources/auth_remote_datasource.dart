import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

/// Encapsulates all direct Supabase calls for authentication.
/// The repository implementation delegates here.
class AuthRemoteDatasource {
  const AuthRemoteDatasource(this._client);

  final SupabaseClient _client;

  // ── Sign In ──────────────────────────────────────────────────────

  /// Signs in with email/password. Returns [UserEntity] on success.
  /// Throws [AuthException] from Supabase on failure.
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final authUser = response.user;
    if (authUser == null) {
      throw const AuthException('Sign-in failed: no user returned.');
    }

    return _fetchProfile(authUser);
  }

  // ── Sign Up ──────────────────────────────────────────────────────

  /// Signs up a new user with email, password, and metadata.
  /// Throws [AuthException] from Supabase on failure.
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String fullName,
    required String schoolSlug,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'school_slug': schoolSlug,
      },
    );

    final authUser = response.user;
    if (authUser == null) {
      throw const AuthException('Sign-up failed: no user returned.');
    }

    // Wait a brief moment for the DB trigger to populate the profile row if using an async trigger, 
    // or rely on it being synchronous. Assuming synchronous for now.
    return _fetchProfile(authUser);
  }

  // ── Sign Out ─────────────────────────────────────────────────────

  Future<void> signOut() => _client.auth.signOut();

  // ── Current User ─────────────────────────────────────────────────

  /// Returns the currently cached [UserEntity] or `null` if unauthenticated.
  Future<UserEntity?> getCurrentUser() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) return null;
    return _fetchProfile(authUser);
  }

  // ── Auth State Stream ────────────────────────────────────────────

  /// Emits [UserEntity] when a session is active, `null` otherwise.
  Stream<UserEntity?> authStateChanges() {
    return _client.auth.onAuthStateChange.asyncMap((event) async {
      final authUser = event.session?.user;
      if (authUser == null) return null;
      return _fetchProfile(authUser);
    });
  }

  // ── Private Helpers ──────────────────────────────────────────────

  /// Fetches the matching `profiles` row and builds a [UserEntity].
  Future<UserEntity> _fetchProfile(User authUser) async {
    final row = await _client
        .from('profiles')
        .select()
        .eq('id', authUser.id)
        .single();

    return UserModel.fromSupabase(
      authUser: authUser,
      profileRow: row,
    ).toEntity();
  }
}
