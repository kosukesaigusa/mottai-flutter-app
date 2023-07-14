// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'host_location.dart';

class ReadHostLocation {
  const ReadHostLocation._({
    required this.hostLocationId,
    required this.hostLocationReference,
    required this.hostId,
    required this.address,
    required this.geo,
    required this.createdAt,
    required this.updatedAt,
  });

  final String hostLocationId;
  final DocumentReference<ReadHostLocation> hostLocationReference;
  final String hostId;
  final String address;
  final Geo geo;
  final SealedTimestamp createdAt;
  final SealedTimestamp updatedAt;

  factory ReadHostLocation._fromJson(Map<String, dynamic> json) {
    return ReadHostLocation._(
      hostLocationId: json['hostLocationId'] as String,
      hostLocationReference:
          json['hostLocationReference'] as DocumentReference<ReadHostLocation>,
      hostId: json['hostId'] as String,
      address: json['address'] as String? ?? '',
      geo: _geoConverter.fromJson(json['geo'] as Map<String, dynamic>),
      createdAt: json['createdAt'] == null
          ? const ServerTimestamp()
          : sealedTimestampConverter.fromJson(json['createdAt'] as Object),
      updatedAt: json['updatedAt'] == null
          ? const ServerTimestamp()
          : alwaysUseServerTimestampSealedTimestampConverter
              .fromJson(json['updatedAt'] as Object),
    );
  }

  factory ReadHostLocation.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadHostLocation._fromJson(<String, dynamic>{
      ...data,
      'hostLocationId': ds.id,
      'hostLocationReference': ds.reference.parent.doc(ds.id).withConverter(
            fromFirestore: (ds, _) => ReadHostLocation.fromDocumentSnapshot(ds),
            toFirestore: (obj, _) => throw UnimplementedError(),
          ),
    });
  }

  ReadHostLocation copyWith({
    String? hostLocationId,
    DocumentReference<ReadHostLocation>? hostLocationReference,
    String? hostId,
    String? address,
    Geo? geo,
    SealedTimestamp? createdAt,
    SealedTimestamp? updatedAt,
  }) {
    return ReadHostLocation._(
      hostLocationId: hostLocationId ?? this.hostLocationId,
      hostLocationReference:
          hostLocationReference ?? this.hostLocationReference,
      hostId: hostId ?? this.hostId,
      address: address ?? this.address,
      geo: geo ?? this.geo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CreateHostLocation {
  const CreateHostLocation({
    required this.hostId,
    required this.address,
    required this.geo,
    this.createdAt = const ServerTimestamp(),
    this.updatedAt = const ServerTimestamp(),
  });

  final String hostId;
  final String address;
  final Geo geo;
  final SealedTimestamp createdAt;
  final SealedTimestamp updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'hostId': hostId,
      'address': address,
      'geo': _geoConverter.toJson(geo),
      'createdAt': sealedTimestampConverter.toJson(createdAt),
      'updatedAt':
          alwaysUseServerTimestampSealedTimestampConverter.toJson(updatedAt),
    };
  }
}

class UpdateHostLocation {
  const UpdateHostLocation({
    this.hostId,
    this.address,
    this.geo,
    this.createdAt,
    this.updatedAt = const ServerTimestamp(),
  });

  final String? hostId;
  final String? address;
  final Geo? geo;
  final SealedTimestamp? createdAt;
  final SealedTimestamp? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      if (hostId != null) 'hostId': hostId,
      if (address != null) 'address': address,
      if (geo != null) 'geo': _geoConverter.toJson(geo!),
      if (createdAt != null)
        'createdAt': sealedTimestampConverter.toJson(createdAt!),
      'updatedAt': updatedAt == null
          ? const ServerTimestamp()
          : alwaysUseServerTimestampSealedTimestampConverter.toJson(updatedAt!),
    };
  }
}

/// A [CollectionReference] to hostLocations collection to read.
final readHostLocationCollectionReference = FirebaseFirestore.instance
    .collection('hostLocations')
    .withConverter<ReadHostLocation>(
      fromFirestore: (ds, _) => ReadHostLocation.fromDocumentSnapshot(ds),
      toFirestore: (obj, _) => throw UnimplementedError(),
    );

/// A [DocumentReference] to hostLocation document to read.
DocumentReference<ReadHostLocation> readHostLocationDocumentReference({
  required String hostLocationId,
}) =>
    readHostLocationCollectionReference.doc(hostLocationId);

/// A [CollectionReference] to hostLocations collection to create.
final createHostLocationCollectionReference = FirebaseFirestore.instance
    .collection('hostLocations')
    .withConverter<CreateHostLocation>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to hostLocation document to create.
DocumentReference<CreateHostLocation> createHostLocationDocumentReference({
  required String hostLocationId,
}) =>
    createHostLocationCollectionReference.doc(hostLocationId);

/// A [CollectionReference] to hostLocations collection to update.
final updateHostLocationCollectionReference = FirebaseFirestore.instance
    .collection('hostLocations')
    .withConverter<UpdateHostLocation>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to hostLocation document to update.
DocumentReference<UpdateHostLocation> updateHostLocationDocumentReference({
  required String hostLocationId,
}) =>
    updateHostLocationCollectionReference.doc(hostLocationId);

/// A [CollectionReference] to hostLocations collection to delete.
final deleteHostLocationCollectionReference =
    FirebaseFirestore.instance.collection('hostLocations');

/// A [DocumentReference] to hostLocation document to delete.
DocumentReference<Object?> deleteHostLocationDocumentReference({
  required String hostLocationId,
}) =>
    deleteHostLocationCollectionReference.doc(hostLocationId);

/// A query manager to execute query against [HostLocation].
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

  /// Fetches a specified [ReadHostLocation] document.
  Future<ReadHostLocation?> fetchDocument({
    required String hostLocationId,
    GetOptions? options,
  }) async {
    final ds = await readHostLocationDocumentReference(
      hostLocationId: hostLocationId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specified [HostLocation] document.
  Future<Stream<ReadHostLocation?>> subscribeDocument({
    required String hostLocationId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) async {
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

  /// Updates a specified [HostLocation] document.
  Future<void> update({
    required String hostLocationId,
    required UpdateHostLocation updateHostLocation,
  }) =>
      updateHostLocationDocumentReference(
        hostLocationId: hostLocationId,
      ).update(updateHostLocation.toJson());

  /// Deletes a specified [HostLocation] document.
  Future<void> delete({
    required String hostLocationId,
  }) =>
      deleteHostLocationDocumentReference(
        hostLocationId: hostLocationId,
      ).delete();
}
