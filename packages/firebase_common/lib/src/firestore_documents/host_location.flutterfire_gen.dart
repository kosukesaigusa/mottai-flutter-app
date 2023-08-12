// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'host_location.dart';

class ReadHostLocation {
  const ReadHostLocation({
    required this.hostLocationId,
    required this.path,
    required this.hostId,
    required this.address,
    required this.geo,
    required this.createdAt,
    required this.updatedAt,
  });

  final String hostLocationId;

  final String path;

  final String hostId;

  final String address;

  final Geo geo;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  factory ReadHostLocation._fromJson(Map<String, dynamic> json) {
    return ReadHostLocation(
      hostLocationId: json['hostLocationId'] as String,
      path: json['path'] as String,
      hostId: json['hostId'] as String,
      address: json['address'] as String? ?? '',
      geo: _geoConverter.fromJson(json['geo'] as Map<String, dynamic>),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadHostLocation.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadHostLocation._fromJson(<String, dynamic>{
      ...data,
      'hostLocationId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateHostLocation {
  const CreateHostLocation({
    required this.hostId,
    required this.address,
    required this.geo,
  });

  final String hostId;
  final String address;
  final Geo geo;

  Map<String, dynamic> toJson() {
    return {
      'hostId': hostId,
      'address': address,
      'geo': _geoConverter.toJson(geo),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateHostLocation {
  const UpdateHostLocation({
    this.hostId,
    this.address,
    this.geo,
    this.createdAt,
  });

  final String? hostId;
  final String? address;
  final Geo? geo;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (hostId != null) 'hostId': hostId,
      if (address != null) 'address': address,
      if (geo != null) 'geo': _geoConverter.toJson(geo!),
      if (createdAt != null) 'createdAt': createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class DeleteHostLocation {}

/// Provides a reference to the hostLocations collection for reading.
final readHostLocationCollectionReference = FirebaseFirestore.instance
    .collection('hostLocations')
    .withConverter<ReadHostLocation>(
      fromFirestore: (ds, _) => ReadHostLocation.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a hostLocation document for reading.
DocumentReference<ReadHostLocation> readHostLocationDocumentReference({
  required String hostLocationId,
}) =>
    readHostLocationCollectionReference.doc(hostLocationId);

/// Provides a reference to the hostLocations collection for creating.
final createHostLocationCollectionReference = FirebaseFirestore.instance
    .collection('hostLocations')
    .withConverter<CreateHostLocation>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a hostLocation document for creating.
DocumentReference<CreateHostLocation> createHostLocationDocumentReference({
  required String hostLocationId,
}) =>
    createHostLocationCollectionReference.doc(hostLocationId);

/// Provides a reference to the hostLocations collection for updating.
final updateHostLocationCollectionReference = FirebaseFirestore.instance
    .collection('hostLocations')
    .withConverter<UpdateHostLocation>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a hostLocation document for updating.
DocumentReference<UpdateHostLocation> updateHostLocationDocumentReference({
  required String hostLocationId,
}) =>
    updateHostLocationCollectionReference.doc(hostLocationId);

/// Provides a reference to the hostLocations collection for deleting.
final deleteHostLocationCollectionReference = FirebaseFirestore.instance
    .collection('hostLocations')
    .withConverter<DeleteHostLocation>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a hostLocation document for deleting.
DocumentReference<DeleteHostLocation> deleteHostLocationDocumentReference({
  required String hostLocationId,
}) =>
    deleteHostLocationCollectionReference.doc(hostLocationId);

/// Manages queries against the hostLocations collection.
class HostLocationQuery {
  /// Fetches [ReadHostLocation] documents.
  Future<List<ReadHostLocation>> fetchDocuments({
    GetOptions? options,
    Query<ReadHostLocation>? Function(Query<ReadHostLocation> query)?
        queryBuilder,
    int Function(ReadHostLocation lhs, ReadHostLocation rhs)? compare,
  }) async {
    Query<ReadHostLocation> query = readHostLocationCollectionReference;
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final qs = await query.get(options);
    final result = qs.docs.map((qds) => qds.data()).toList();
    if (compare != null) {
      result.sort(compare);
    }
    return result;
  }

  /// Subscribes [HostLocation] documents.
  Stream<List<ReadHostLocation>> subscribeDocuments({
    Query<ReadHostLocation>? Function(Query<ReadHostLocation> query)?
        queryBuilder,
    int Function(ReadHostLocation lhs, ReadHostLocation rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadHostLocation> query = readHostLocationCollectionReference;
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    var streamQs =
        query.snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamQs = streamQs.where((qs) => !qs.metadata.hasPendingWrites);
    }
    return streamQs.map((qs) {
      final result = qs.docs.map((qds) => qds.data()).toList();
      if (compare != null) {
        result.sort(compare);
      }
      return result;
    });
  }

  /// Fetches a specific [ReadHostLocation] document.
  Future<ReadHostLocation?> fetchDocument({
    required String hostLocationId,
    GetOptions? options,
  }) async {
    final ds = await readHostLocationDocumentReference(
      hostLocationId: hostLocationId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [HostLocation] document.
  Stream<ReadHostLocation?> subscribeDocument({
    required String hostLocationId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readHostLocationDocumentReference(
      hostLocationId: hostLocationId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [HostLocation] document.
  Future<DocumentReference<CreateHostLocation>> add({
    required CreateHostLocation createHostLocation,
  }) =>
      createHostLocationCollectionReference.add(createHostLocation);

  /// Sets a [HostLocation] document.
  Future<void> set({
    required String hostLocationId,
    required CreateHostLocation createHostLocation,
    SetOptions? options,
  }) =>
      createHostLocationDocumentReference(
        hostLocationId: hostLocationId,
      ).set(createHostLocation, options);

  /// Updates a specific [HostLocation] document.
  Future<void> update({
    required String hostLocationId,
    required UpdateHostLocation updateHostLocation,
  }) =>
      updateHostLocationDocumentReference(
        hostLocationId: hostLocationId,
      ).update(updateHostLocation.toJson());

  /// Deletes a specific [HostLocation] document.
  Future<void> delete({
    required String hostLocationId,
  }) =>
      deleteHostLocationDocumentReference(
        hostLocationId: hostLocationId,
      ).delete();
}
