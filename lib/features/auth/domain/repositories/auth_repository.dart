import '../entities/user_entity.dart';

/// Contract for authentication operations.
/// The data layer implements this; the domain/presentation layer depends only on this interface.
abstract interface class AuthRepository {
  /// Returns the currently signed-in [UserEntity], or `null` if not signed in.
  Future<UserEntity?> getCurrentUser();

  /// Signs the user in with [email] and [password].
  /// Throws [AuthException] on failure.
  Future<UserEntity> signIn({required String email, required String password});

  /// Registers a new user with [email], [password], [fullName], and [schoolSlug].
  /// Throws [AuthException] on failure.
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String fullName,
    required String schoolSlug,
  });

  /// Signs the user out and clears the local session.
  Future<void> signOut();

  /// Emits the current auth state whenever it changes.
  /// Emits `null` when signed out, [UserEntity] when signed in.
  Stream<UserEntity?> authStateChanges();
}
