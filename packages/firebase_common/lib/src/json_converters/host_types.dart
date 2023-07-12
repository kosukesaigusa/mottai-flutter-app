import 'package:json_annotation/json_annotation.dart';

import '../firestore_documents/host.dart';

const hostTypesConverter = HostTypesConverter();

class HostTypesConverter
    implements JsonConverter<Set<HostType>, List<dynamic>?> {
  const HostTypesConverter();

  @override
  Set<HostType> fromJson(List<dynamic>? json) =>
      (json ?? []).map((e) => HostType.fromString(e as String)).toSet();

  @override
  List<String> toJson(Set<HostType> hostTypes) =>
      hostTypes.map((a) => a.name).toList();
}
