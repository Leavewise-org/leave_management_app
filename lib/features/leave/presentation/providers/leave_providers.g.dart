// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$leaveRemoteDatasourceHash() =>
    r'76c37c86be3b918b7c2dd14af78f02a83623a715';

/// See also [leaveRemoteDatasource].
@ProviderFor(leaveRemoteDatasource)
final leaveRemoteDatasourceProvider =
    AutoDisposeProvider<LeaveRemoteDatasource>.internal(
  leaveRemoteDatasource,
  name: r'leaveRemoteDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$leaveRemoteDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LeaveRemoteDatasourceRef
    = AutoDisposeProviderRef<LeaveRemoteDatasource>;
String _$leaveRepositoryHash() => r'efb03b73549d52533bee12c1a46952ea97883ca5';

/// See also [leaveRepository].
@ProviderFor(leaveRepository)
final leaveRepositoryProvider = AutoDisposeProvider<LeaveRepository>.internal(
  leaveRepository,
  name: r'leaveRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$leaveRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LeaveRepositoryRef = AutoDisposeProviderRef<LeaveRepository>;
String _$userLeavesHash() => r'dfcc6d694ee6db99716f35df422d99ec054aef50';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [userLeaves].
@ProviderFor(userLeaves)
const userLeavesProvider = UserLeavesFamily();

/// See also [userLeaves].
class UserLeavesFamily extends Family<AsyncValue<List<LeaveEntity>>> {
  /// See also [userLeaves].
  const UserLeavesFamily();

  /// See also [userLeaves].
  UserLeavesProvider call(
    String userId,
  ) {
    return UserLeavesProvider(
      userId,
    );
  }

  @override
  UserLeavesProvider getProviderOverride(
    covariant UserLeavesProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userLeavesProvider';
}

/// See also [userLeaves].
class UserLeavesProvider extends AutoDisposeStreamProvider<List<LeaveEntity>> {
  /// See also [userLeaves].
  UserLeavesProvider(
    String userId,
  ) : this._internal(
          (ref) => userLeaves(
            ref as UserLeavesRef,
            userId,
          ),
          from: userLeavesProvider,
          name: r'userLeavesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userLeavesHash,
          dependencies: UserLeavesFamily._dependencies,
          allTransitiveDependencies:
              UserLeavesFamily._allTransitiveDependencies,
          userId: userId,
        );

  UserLeavesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    Stream<List<LeaveEntity>> Function(UserLeavesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserLeavesProvider._internal(
        (ref) => create(ref as UserLeavesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<LeaveEntity>> createElement() {
    return _UserLeavesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserLeavesProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserLeavesRef on AutoDisposeStreamProviderRef<List<LeaveEntity>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserLeavesProviderElement
    extends AutoDisposeStreamProviderElement<List<LeaveEntity>>
    with UserLeavesRef {
  _UserLeavesProviderElement(super.provider);

  @override
  String get userId => (origin as UserLeavesProvider).userId;
}

String _$pendingLeavesHash() => r'5ce3f54572513db0195a9b7fa11465f9280e3611';

/// See also [pendingLeaves].
@ProviderFor(pendingLeaves)
const pendingLeavesProvider = PendingLeavesFamily();

/// See also [pendingLeaves].
class PendingLeavesFamily extends Family<AsyncValue<List<LeaveEntity>>> {
  /// See also [pendingLeaves].
  const PendingLeavesFamily();

  /// See also [pendingLeaves].
  PendingLeavesProvider call(
    String schoolId,
  ) {
    return PendingLeavesProvider(
      schoolId,
    );
  }

  @override
  PendingLeavesProvider getProviderOverride(
    covariant PendingLeavesProvider provider,
  ) {
    return call(
      provider.schoolId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'pendingLeavesProvider';
}

/// See also [pendingLeaves].
class PendingLeavesProvider
    extends AutoDisposeStreamProvider<List<LeaveEntity>> {
  /// See also [pendingLeaves].
  PendingLeavesProvider(
    String schoolId,
  ) : this._internal(
          (ref) => pendingLeaves(
            ref as PendingLeavesRef,
            schoolId,
          ),
          from: pendingLeavesProvider,
          name: r'pendingLeavesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$pendingLeavesHash,
          dependencies: PendingLeavesFamily._dependencies,
          allTransitiveDependencies:
              PendingLeavesFamily._allTransitiveDependencies,
          schoolId: schoolId,
        );

  PendingLeavesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.schoolId,
  }) : super.internal();

  final String schoolId;

  @override
  Override overrideWith(
    Stream<List<LeaveEntity>> Function(PendingLeavesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PendingLeavesProvider._internal(
        (ref) => create(ref as PendingLeavesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        schoolId: schoolId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<LeaveEntity>> createElement() {
    return _PendingLeavesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingLeavesProvider && other.schoolId == schoolId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, schoolId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PendingLeavesRef on AutoDisposeStreamProviderRef<List<LeaveEntity>> {
  /// The parameter `schoolId` of this provider.
  String get schoolId;
}

class _PendingLeavesProviderElement
    extends AutoDisposeStreamProviderElement<List<LeaveEntity>>
    with PendingLeavesRef {
  _PendingLeavesProviderElement(super.provider);

  @override
  String get schoolId => (origin as PendingLeavesProvider).schoolId;
}

String _$submitLeaveNotifierHash() =>
    r'2d0983d7970401f81bfe52a4cb350e0bae4ceb51';

/// See also [SubmitLeaveNotifier].
@ProviderFor(SubmitLeaveNotifier)
final submitLeaveNotifierProvider =
    AutoDisposeNotifierProvider<SubmitLeaveNotifier, SubmitLeaveState>.internal(
  SubmitLeaveNotifier.new,
  name: r'submitLeaveNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$submitLeaveNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubmitLeaveNotifier = AutoDisposeNotifier<SubmitLeaveState>;
String _$manageLeaveNotifierHash() =>
    r'da9d3096c3f0ce1e2b7dc71119427116dfb8bb8c';

/// See also [ManageLeaveNotifier].
@ProviderFor(ManageLeaveNotifier)
final manageLeaveNotifierProvider =
    AutoDisposeNotifierProvider<ManageLeaveNotifier, ManageLeaveState>.internal(
  ManageLeaveNotifier.new,
  name: r'manageLeaveNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$manageLeaveNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ManageLeaveNotifier = AutoDisposeNotifier<ManageLeaveState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
