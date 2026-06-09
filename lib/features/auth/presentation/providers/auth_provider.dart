import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/error/failures.dart';

part 'auth_provider.g.dart';

// ── Infrastructure providers ──────────────────────────────────────

@riverpod
FirebaseAuth firebaseAuth(Ref ref) => FirebaseAuth.instance;

@riverpod
FirebaseFirestore firestore(Ref ref) => FirebaseFirestore.instance;

@riverpod
AuthRemoteDatasource authRemoteDatasource(Ref ref) =>
    AuthRemoteDatasource(ref.watch(firebaseAuthProvider), ref.watch(firestoreProvider));

@riverpod
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(authRemoteDatasourceProvider));

// ── Auth state stream ─────────────────────────────────────────────

/// Continuously emits the current [UserEntity] (or `null` when signed out).
/// Used by the router guard to redirect automatically.
@riverpod
Stream<UserEntity?> authState(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();

// ── Sign-in notifier ─────────────────────────────────────────────

/// Holds the sign-in form state.
class SignInState {
  const SignInState({
    this.isLoading = false,
    this.failure,
    this.user,
  });

  final bool isLoading;
  final AuthFailure? failure;
  final UserEntity? user;

  bool get isSuccess => user != null;

  SignInState copyWith({
    bool? isLoading,
    AuthFailure? failure,
    UserEntity? user,
    bool clearFailure = false,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : failure ?? this.failure,
      user: user ?? this.user,
    );
  }
}

@riverpod
class SignInNotifier extends _$SignInNotifier {
  @override
  SignInState build() => const SignInState();

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearFailure: true);

    try {
      final user = await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);

      state = state.copyWith(isLoading: false, user: user);
    } on AuthFailure catch (f) {
      state = state.copyWith(isLoading: false, failure: f);
    } catch (e) {
      debugPrint('❌ Unexpected sign-in error: $e');
      state = state.copyWith(
        isLoading: false,
        failure: UnknownAuthFailure(e.toString()),
      );
    }
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const SignInState();
  }

  void clearError() => state = state.copyWith(clearFailure: true);
}

// ── Sign-up notifier ─────────────────────────────────────────────

@riverpod
class SignUpNotifier extends _$SignUpNotifier {
  @override
  SignInState build() => const SignInState();

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = state.copyWith(isLoading: true, clearFailure: true);

    try {
      final user = await ref.read(authRepositoryProvider).signUp(
            email: email,
            password: password,
            fullName: fullName,
          );

      state = state.copyWith(isLoading: false, user: user);
    } on AuthFailure catch (f) {
      state = state.copyWith(isLoading: false, failure: f);
    } catch (e) {
      debugPrint('❌ Unexpected sign-up error: $e');
      state = state.copyWith(
        isLoading: false,
        failure: UnknownAuthFailure(e.toString()),
      );
    }
  }

  void clearError() => state = state.copyWith(clearFailure: true);
}
