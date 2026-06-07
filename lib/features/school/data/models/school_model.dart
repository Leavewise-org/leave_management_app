import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/school_entity.dart';

class SchoolModel extends SchoolEntity {
  const SchoolModel({
    required super.id,
    required super.name,
    required super.address,
    required super.leavePolicies,
  });

  factory SchoolModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('School document data is null');
    }

    final leavePoliciesRaw = data['leave_policies'] as Map<String, dynamic>? ?? {};
    final Map<String, int> leavePolicies = {};
    
    // Ensure types are parsed correctly
    leavePoliciesRaw.forEach((key, value) {
      if (value is num) {
        leavePolicies[key] = value.toInt();
      }
    });

    // Provide default fallback if policies are empty (for backward compatibility)
    if (leavePolicies.isEmpty) {
      leavePolicies['Annual Leave'] = 14;
      leavePolicies['Sick Leave'] = 7;
      leavePolicies['Casual Leave'] = 3;
    }

    return SchoolModel(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      leavePolicies: leavePolicies,
    );
  }

  SchoolEntity toEntity() {
    return SchoolEntity(
      id: id,
      name: name,
      address: address,
      leavePolicies: leavePolicies,
    );
  }
}
