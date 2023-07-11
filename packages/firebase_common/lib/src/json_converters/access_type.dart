import 'package:json_annotation/json_annotation.dart';

import '../firestore_documents/job.dart';

const accessTypesConverter = AccessTypesConverter();

class AccessTypesConverter
    implements JsonConverter<Set<AccessType>, List<String>> {
  const AccessTypesConverter();

  @override
  Set<AccessType> fromJson(List<String>? json) =>
      (json ?? []).map(AccessType.fromString).toSet();

  @override
  List<String> toJson(Set<AccessType> accessTypes) =>
      accessTypes.map((a) => a.name).toList();
}
