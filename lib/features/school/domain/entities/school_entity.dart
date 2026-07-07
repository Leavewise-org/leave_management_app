class SchoolEntity {
  final String id;
  final String name;
  final String address;
  final Map<String, int> leavePolicies;

  const SchoolEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.leavePolicies,
  });
}
