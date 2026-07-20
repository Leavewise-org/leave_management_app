// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$holidayRemoteDatasourceHash() =>
    r'0d2a61bf8d7d6524504bbc5fc3dc3762340b29da';

/// See also [holidayRemoteDatasource].
@ProviderFor(holidayRemoteDatasource)
final holidayRemoteDatasourceProvider =
    AutoDisposeProvider<HolidayFirestoreDatasource>.internal(
  holidayRemoteDatasource,
  name: r'holidayRemoteDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$holidayRemoteDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HolidayRemoteDatasourceRef
    = AutoDisposeProviderRef<HolidayFirestoreDatasource>;
String _$holidayRepositoryHash() => r'0ebf5c9e65cbb66073d0d9580b938f91c2b58b40';

/// See also [holidayRepository].
@ProviderFor(holidayRepository)
final holidayRepositoryProvider =
    AutoDisposeProvider<HolidayRepository>.internal(
  holidayRepository,
  name: r'holidayRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$holidayRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HolidayRepositoryRef = AutoDisposeProviderRef<HolidayRepository>;
String _$currentYearHolidaysHash() =>
    r'a9a74efe05e9ae27dc0aaa47bf38e92b79d08ba1';

/// See also [currentYearHolidays].
@ProviderFor(currentYearHolidays)
final currentYearHolidaysProvider =
    AutoDisposeFutureProvider<List<HolidayEntity>>.internal(
  currentYearHolidays,
  name: r'currentYearHolidaysProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentYearHolidaysHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentYearHolidaysRef
    = AutoDisposeFutureProviderRef<List<HolidayEntity>>;
String _$holidaysByYearHash() => r'357ff766bd0128d9a7701427dc16453b350c7546';

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

/// See also [holidaysByYear].
@ProviderFor(holidaysByYear)
const holidaysByYearProvider = HolidaysByYearFamily();

/// See also [holidaysByYear].
class HolidaysByYearFamily extends Family<AsyncValue<List<HolidayEntity>>> {
  /// See also [holidaysByYear].
  const HolidaysByYearFamily();

  /// See also [holidaysByYear].
  HolidaysByYearProvider call(
    int year,
  ) {
    return HolidaysByYearProvider(
      year,
    );
  }

  @override
  HolidaysByYearProvider getProviderOverride(
    covariant HolidaysByYearProvider provider,
  ) {
    return call(
      provider.year,
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
  String? get name => r'holidaysByYearProvider';
}

/// See also [holidaysByYear].
class HolidaysByYearProvider
    extends AutoDisposeFutureProvider<List<HolidayEntity>> {
  /// See also [holidaysByYear].
  HolidaysByYearProvider(
    int year,
  ) : this._internal(
          (ref) => holidaysByYear(
            ref as HolidaysByYearRef,
            year,
          ),
          from: holidaysByYearProvider,
          name: r'holidaysByYearProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$holidaysByYearHash,
          dependencies: HolidaysByYearFamily._dependencies,
          allTransitiveDependencies:
              HolidaysByYearFamily._allTransitiveDependencies,
          year: year,
        );

  HolidaysByYearProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
  }) : super.internal();

  final int year;

  @override
  Override overrideWith(
    FutureOr<List<HolidayEntity>> Function(HolidaysByYearRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HolidaysByYearProvider._internal(
        (ref) => create(ref as HolidaysByYearRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<HolidayEntity>> createElement() {
    return _HolidaysByYearProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HolidaysByYearProvider && other.year == year;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HolidaysByYearRef on AutoDisposeFutureProviderRef<List<HolidayEntity>> {
  /// The parameter `year` of this provider.
  int get year;
}

class _HolidaysByYearProviderElement
    extends AutoDisposeFutureProviderElement<List<HolidayEntity>>
    with HolidaysByYearRef {
  _HolidaysByYearProviderElement(super.provider);

  @override
  int get year => (origin as HolidaysByYearProvider).year;
}

String _$holidayByDateHash() => r'f8353c3c89ed376fd79e0056e625aa95560d2e06';

/// See also [holidayByDate].
@ProviderFor(holidayByDate)
const holidayByDateProvider = HolidayByDateFamily();

/// See also [holidayByDate].
class HolidayByDateFamily extends Family<AsyncValue<HolidayEntity?>> {
  /// See also [holidayByDate].
  const HolidayByDateFamily();

  /// See also [holidayByDate].
  HolidayByDateProvider call(
    DateTime date,
  ) {
    return HolidayByDateProvider(
      date,
    );
  }

  @override
  HolidayByDateProvider getProviderOverride(
    covariant HolidayByDateProvider provider,
  ) {
    return call(
      provider.date,
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
  String? get name => r'holidayByDateProvider';
}

/// See also [holidayByDate].
class HolidayByDateProvider extends AutoDisposeFutureProvider<HolidayEntity?> {
  /// See also [holidayByDate].
  HolidayByDateProvider(
    DateTime date,
  ) : this._internal(
          (ref) => holidayByDate(
            ref as HolidayByDateRef,
            date,
          ),
          from: holidayByDateProvider,
          name: r'holidayByDateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$holidayByDateHash,
          dependencies: HolidayByDateFamily._dependencies,
          allTransitiveDependencies:
              HolidayByDateFamily._allTransitiveDependencies,
          date: date,
        );

  HolidayByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    FutureOr<HolidayEntity?> Function(HolidayByDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HolidayByDateProvider._internal(
        (ref) => create(ref as HolidayByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<HolidayEntity?> createElement() {
    return _HolidayByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HolidayByDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HolidayByDateRef on AutoDisposeFutureProviderRef<HolidayEntity?> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _HolidayByDateProviderElement
    extends AutoDisposeFutureProviderElement<HolidayEntity?>
    with HolidayByDateRef {
  _HolidayByDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as HolidayByDateProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
