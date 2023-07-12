// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'host.dart';

class ReadHost {
  const ReadHost._({
    required this.hostId,
    required this.hostReference,
    required this.displayName,
    required this.imageUrl,
    required this.hostTypes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String hostId;
  final DocumentReference<ReadHost> hostReference;
  final String displayName;
  final String imageUrl;
  final Set<HostType> hostTypes;
  final SealedTimestamp createdAt;
  final SealedTimestamp updatedAt;

  factory ReadHost._fromJson(Map<String, dynamic> json) {
    return ReadHost._(
      hostId: json['hostId'] as String,
      hostReference: json['hostReference'] as DocumentReference<ReadHost>,
      displayName: json['displayName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      hostTypes: json['hostTypes'] == null
          ? const <HostType>{}
          : hostTypesConverter.fromJson(json['hostTypes'] as List<dynamic>?),
      createdAt: json['createdAt'] == null
          ? const ServerTimestamp()
          : sealedTimestampConverter.fromJson(json['createdAt'] as Object),
      updatedAt: json['updatedAt'] == null
          ? const ServerTimestamp()
          : alwaysUseServerTimestampSealedTimestampConverter
              .fromJson(json['updatedAt'] as Object),
    );
  }

  factory ReadHost.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadHost._fromJson(<String, dynamic>{
      ...data,
      'hostId': ds.id,
      'hostReference': ds.reference.parent.doc(ds.id).withConverter(
            fromFirestore: (ds, _) => ReadHost.fromDocumentSnapshot(ds),
            toFirestore: (obj, _) => throw UnimplementedError(),
          ),
    });
  }

  ReadHost copyWith({
    String? hostId,
    DocumentReference<ReadHost>? hostReference,
    String? displayName,
    String? imageUrl,
    Set<HostType>? hostTypes,
    SealedTimestamp? createdAt,
    SealedTimestamp? updatedAt,
  }) {
    return ReadHost._(
      hostId: hostId ?? this.hostId,
      hostReference: hostReference ?? this.hostReference,
      displayName: displayName ?? this.displayName,
      imageUrl: imageUrl ?? this.imageUrl,
      hostTypes: hostTypes ?? this.hostTypes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CreateHost {
  const CreateHost({
    required this.displayName,
    this.imageUrl = '',
    this.hostTypes = const <HostType>{},
    this.createdAt = const ServerTimestamp(),
    this.updatedAt = const ServerTimestamp(),
  });

  final String displayName;
  final String imageUrl;
  final Set<HostType> hostTypes;
  final SealedTimestamp createdAt;
  final SealedTimestamp updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'imageUrl': imageUrl,
      'hostTypes': hostTypesConverter.toJson(hostTypes),
      'createdAt': sealedTimestampConverter.toJson(createdAt),
      'updatedAt':
          alwaysUseServerTimestampSealedTimestampConverter.toJson(updatedAt),
    };
  }
}

class UpdateHost {
  const UpdateHost({
    this.displayName,
    this.imageUrl,
    this.hostTypes,
    this.createdAt,
    this.updatedAt = const ServerTimestamp(),
  });

  final String? displayName;
  final String? imageUrl;
  final Set<HostType>? hostTypes;
  final SealedTimestamp? createdAt;
  final SealedTimestamp? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      if (displayName != null) 'displayName': displayName,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (hostTypes != null) 'hostTypes': hostTypesConverter.toJson(hostTypes!),
      if (createdAt != null)
        'createdAt': sealedTimestampConverter.toJson(createdAt!),
      'updatedAt': updatedAt == null
          ? const ServerTimestamp()
          : alwaysUseServerTimestampSealedTimestampConverter.toJson(updatedAt!),
    };
  }
}

/// A [CollectionReference] to hosts collection to read.
final readHostCollectionReference =
    FirebaseFirestore.instance.collection('hosts').withConverter<ReadHost>(
          fromFirestore: (ds, _) => ReadHost.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => throw UnimplementedError(),
        );

/// A [DocumentReference] to host document to read.
DocumentReference<ReadHost> readHostDocumentReference({
  required String hostId,
}) =>
    readHostCollectionReference.doc(hostId);

/// A [CollectionReference] to hosts collection to create.
final createHostCollectionReference =
    FirebaseFirestore.instance.collection('hosts').withConverter<CreateHost>(
          fromFirestore: (ds, _) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// A [DocumentReference] to host document to create.
DocumentReference<CreateHost> createHostDocumentReference({
  required String hostId,
}) =>
    createHostCollectionReference.doc(hostId);

/// A [CollectionReference] to hosts collection to update.
final updateHostCollectionReference =
    FirebaseFirestore.instance.collection('hosts').withConverter<UpdateHost>(
          fromFirestore: (ds, _) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// A [DocumentReference] to host document to update.
DocumentReference<UpdateHost> updateHostDocumentReference({
  required String hostId,
}) =>
    updateHostCollectionReference.doc(hostId);

/// A query manager to execute query against [Host].
class HostQuery {
  /// Fetches [ReadHost] documents.
  Future<List<ReadHost>> fetchDocuments({
    GetOptions? options,
    Query<ReadHost>? Function(Query<ReadHost> query)? queryBuilder,
    int Function(ReadHost lhs, ReadHost rhs)? compare,
  }) async {
    Query<ReadHost> query = readHostCollectionReference;
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

  /// Subscribes [Host] documents.
  Stream<List<ReadHost>> subscribeDocuments({
    Query<ReadHost>? Function(Query<ReadHost> query)? queryBuilder,
    int Function(ReadHost lhs, ReadHost rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadHost> query = readHostCollectionReference;
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

  /// Fetches a specified [ReadHost] document.
  Future<ReadHost?> fetchDocument({
    required String hostId,
    GetOptions? options,
  }) async {
    final ds = await readHostDocumentReference(
      hostId: hostId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specified [Host] document.
  Future<Stream<ReadHost?>> subscribeDocument({
    required String hostId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) async {
    var streamDs = readHostDocumentReference(
      hostId: hostId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Creates a [Host] document.
  Future<DocumentReference<CreateHost>> create({
    required CreateHost createHost,
  }) =>
      createHostCollectionReference.add(createHost);

  /// Sets a [Host] document.
  Future<void> set({
    required String hostId,
    required CreateHost createHost,
    SetOptions? options,
  }) =>
      createHostDocumentReference(
        hostId: hostId,
      ).set(createHost, options);

  /// Updates a specified [Host] document.
  Future<void> update({
    required String hostId,
    required UpdateHost updateHost,
  }) =>
      updateHostDocumentReference(
        hostId: hostId,
      ).update(updateHost.toJson());
}
