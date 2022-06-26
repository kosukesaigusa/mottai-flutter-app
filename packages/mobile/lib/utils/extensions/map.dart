import 'package:cloud_firestore/cloud_firestore.dart';

extension MapExtension on Map<String, dynamic> {
  Map<String, dynamic> toFirestore([String updatedAtFieldName = 'updatedAt']) {
    final nonNullValueMap = <String, dynamic>{};
    forEach((key, dynamic value) {
      if (value != null) {
        nonNullValueMap[key] = value;
      }
    });
    nonNullValueMap[updatedAtFieldName] = FieldValue.serverTimestamp();
    return nonNullValueMap;
  }
}
