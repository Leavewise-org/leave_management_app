// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_events_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserLeavesHash() => r'65daafaaaccc55cf9530309b9ac422ece3e34e3a';

/// See also [currentUserLeaves].
@ProviderFor(currentUserLeaves)
final currentUserLeavesProvider =
    AutoDisposeStreamProvider<List<LeaveEntity>>.internal(
  currentUserLeaves,
  name: r'currentUserLeavesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserLeavesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserLeavesRef = AutoDisposeStreamProviderRef<List<LeaveEntity>>;
String _$calendarEventsHash() => r'99d10e17aa71c6922eb6e0a33c588dae0106fba8';

/// See also [calendarEvents].
@ProviderFor(calendarEvents)
final calendarEventsProvider =
    AutoDisposeProvider<Map<DateTime, List<dynamic>>>.internal(
  calendarEvents,
  name: r'calendarEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$calendarEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CalendarEventsRef
    = AutoDisposeProviderRef<Map<DateTime, List<dynamic>>>;
String _$upcomingEventsHash() => r'2faab7dadfa38ee854e93d2df0b1f8ae01135a74';

/// See also [upcomingEvents].
@ProviderFor(upcomingEvents)
final upcomingEventsProvider = AutoDisposeProvider<List<dynamic>>.internal(
  upcomingEvents,
  name: r'upcomingEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$upcomingEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpcomingEventsRef = AutoDisposeProviderRef<List<dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
