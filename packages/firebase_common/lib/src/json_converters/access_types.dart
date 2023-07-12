import 'package:json_annotation/json_annotation.dart';

import '../firestore_documents/job.dart';

const accessTypesConverter = AccessTypesConverter();

class AccessTypesConverter
    implements JsonConverter<Set<AccessType>, List<dynamic>?> {
  const AccessTypesConverter();

  @override
  Set<AccessType> fromJson(List<dynamic>? json) =>
      (json ?? []).map((e) => AccessType.fromString(e as String)).toSet();

  @override
  List<String> toJson(Set<AccessType> accessTypes) =>
      accessTypes.map((a) => a.name).toList();
}
