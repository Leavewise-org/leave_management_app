/// Generic failure base class
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Sealed failure hierarchy for auth errors.
/// Used to return typed errors from repositories instead of throwing raw exceptions.
sealed class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Bad credentials, account not found, etc.
final class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
      : super('Invalid email or password. Please try again.');
}

/// Email is already registered to an existing account.
final class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure()
      : super('An account with this email already exists. Try signing in.');
}

/// Network unreachable.
final class NetworkFailure extends AuthFailure {
  const NetworkFailure() : super('No internet connection.');
}

/// Session has expired and needs re-login.
final class SessionExpiredFailure extends AuthFailure {
  const SessionExpiredFailure()
      : super('Your session has expired. Please sign in again.');
}

/// The user's profile row was not found in the `profiles` table.
final class ProfileNotFoundFailure extends AuthFailure {
  const ProfileNotFoundFailure()
      : super('Your account profile could not be found. Contact your admin.');
}

/// Catch-all for unexpected errors.
final class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure(super.message);
}

