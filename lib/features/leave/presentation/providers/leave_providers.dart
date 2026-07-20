import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/leave_entity.dart';
import '../../domain/repositories/leave_repository.dart';
import '../../data/datasources/leave_remote_datasource.dart';
import '../../data/repositories/leave_repository_impl.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

part 'leave_providers.g.dart';

// ── Infrastructure providers ──────────────────────────────────────

@riverpod
LeaveRemoteDatasource leaveRemoteDatasource(Ref ref) {
  return LeaveRemoteDatasource(FirebaseFirestore.instance);
}

@riverpod
LeaveRepository leaveRepository(Ref ref) {
  return LeaveRepositoryImpl(ref.watch(leaveRemoteDatasourceProvider));
}

// ── Streams ────────────────────────────────────────────────────────

@riverpod
Stream<List<LeaveEntity>> userLeaves(Ref ref, String userId) {
  return ref.watch(leaveRepositoryProvider).getUserLeaves(userId);
}

@riverpod
Stream<List<LeaveEntity>> pendingLeaves(Ref ref, String schoolId) {
  return ref.watch(leaveRepositoryProvider).getPendingLeavesBySchool(schoolId);
}

@riverpod
Stream<List<LeaveEntity>> allLeaves(Ref ref, String schoolId) {
  return ref.watch(leaveRepositoryProvider).getLeavesBySchool(schoolId);
}

// ── Submit Leave Notifier ──────────────────────────────────────────

class SubmitLeaveState {
  final bool isLoading;
  final Failure? failure;
  final bool isSuccess;

  const SubmitLeaveState({
    this.isLoading = false,
    this.failure,
    this.isSuccess = false,
  });
}

@riverpod
class SubmitLeaveNotifier extends _$SubmitLeaveNotifier {
  @override
  SubmitLeaveState build() => const SubmitLeaveState();

  Future<void> submitLeave({
    required String userId,
    required String schoolId,
    required String userName,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required bool isHalfDay,
    required double durationDays,
  }) async {
    state = const SubmitLeaveState(isLoading: true);

    try {
      await ref.read(leaveRepositoryProvider).submitLeave(
        userId: userId,
        schoolId: schoolId,
        userName: userName,
        leaveType: leaveType,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
        isHalfDay: isHalfDay,
        durationDays: durationDays,
      );

      state = const SubmitLeaveState(isSuccess: true);
    } catch (e) {
      if (e is Failure) {
        state = SubmitLeaveState(failure: e);
      } else {
        state = SubmitLeaveState(failure: ServerFailure(e.toString()));
      }
    }
  }

  void reset() => state = const SubmitLeaveState();
}

// ── Manage Leave Notifier ──────────────────────────────────────────

class ManageLeaveState {
  final bool isLoading;
  final Failure? failure;

  const ManageLeaveState({
    this.isLoading = false,
    this.failure,
  });
}

@riverpod
class ManageLeaveNotifier extends _$ManageLeaveNotifier {
  @override
  ManageLeaveState build() => const ManageLeaveState();

  Future<void> updateStatus(String leaveId, String status) async {
    state = const ManageLeaveState(isLoading: true);
    try {
      await ref.read(leaveRepositoryProvider).updateLeaveStatus(
        leaveId: leaveId,
        status: status,
      );
      state = const ManageLeaveState(); // success
    } catch (e) {
      if (e is Failure) {
        state = ManageLeaveState(failure: e);
      } else {
        state = ManageLeaveState(failure: ServerFailure(e.toString()));
      }
    }
  }
}
