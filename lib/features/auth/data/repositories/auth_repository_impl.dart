import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';
import '../datasources/auth_remote_datasource.dart';

/// Concrete implementation of [AuthRepository].
/// Wraps [AuthRemoteDatasource] calls and maps Firebase errors
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
    } on FirebaseAuthException catch (e) {
      final msg = e.message?.toLowerCase() ?? '';
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential' ||
          msg.contains('invalid') ||
          msg.contains('credentials') ||
          msg.contains('password')) {
        throw const InvalidCredentialsFailure();
      }
      throw UnknownAuthFailure(e.message ?? 'Unknown Firebase Auth Error');
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') throw const ProfileNotFoundFailure();
      throw UnknownAuthFailure(e.message ?? 'Firebase Error');
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
    } on FirebaseAuthException catch (e) {
      final msg = e.message?.toLowerCase() ?? '';
      if (e.code == 'email-already-in-use' || msg.contains('already in use')) {
        throw const EmailAlreadyInUseFailure();
      }
      throw UnknownAuthFailure(e.message ?? 'Unknown Firebase Auth Error');
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') throw const ProfileNotFoundFailure();
      throw UnknownAuthFailure(e.message ?? 'Firebase Error');
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
