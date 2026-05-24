import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:supabase_flutter/supabase_flutter.dart' as supa
    show AuthException;
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';
import '../datasources/auth_remote_datasource.dart';

/// Concrete implementation of [AuthRepository].
/// Wraps [AuthRemoteDatasource] calls and maps Supabase errors
/// to typed [AuthFailure]s.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);

  final AuthRemoteDatasource _datasource;

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      return await _datasource.getCurrentUser();
    } catch (_) {
      return null; // silently return null on any error during startup
    }
  }

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _datasource.signIn(email: email, password: password);
    } on supa.AuthException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid') ||
          msg.contains('credentials') ||
          msg.contains('password') ||
          msg.contains('not found')) {
        throw const InvalidCredentialsFailure();
      }
      throw UnknownAuthFailure(e.message);
    } on PostgrestException catch (e) {
      // Profile row missing
      if (e.code == 'PGRST116') throw const ProfileNotFoundFailure();
      throw UnknownAuthFailure(e.message);
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('socket') ||
          msg.contains('network') ||
          msg.contains('connection')) {
        throw const NetworkFailure();
      }
      throw UnknownAuthFailure(e.toString());
    }
  }

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String fullName,
    required String schoolSlug,
  }) async {
    try {
      return await _datasource.signUp(
        email: email,
        password: password,
        fullName: fullName,
        schoolSlug: schoolSlug,
      );
    } on supa.AuthException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('already registered') || msg.contains('already exists')) {
        throw const InvalidCredentialsFailure(); // or a specific user-exists failure
      }
      throw UnknownAuthFailure(e.message);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') throw const ProfileNotFoundFailure();
      throw UnknownAuthFailure(e.message);
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('socket') ||
          msg.contains('network') ||
          msg.contains('connection')) {
        throw const NetworkFailure();
      }
      throw UnknownAuthFailure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _datasource.signOut();
    } catch (_) {
      // Always succeed locally even if the API call fails
    }
  }

  @override
  Stream<UserEntity?> authStateChanges() => _datasource.authStateChanges();
}
