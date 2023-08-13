// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'host.dart';

class ReadHost {
  const ReadHost({
    required this.hostId,
    required this.path,
    required this.imageUrl,
    required this.displayName,
    required this.introduction,
    required this.hostTypes,
    required this.urls,
    required this.createdAt,
    required this.updatedAt,
  });

  final String hostId;

  final String path;

  final String imageUrl;

  final String displayName;

  final String introduction;

  final Set<HostType> hostTypes;

  final List<String> urls;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  factory ReadHost._fromJson(Map<String, dynamic> json) {
    return ReadHost(
      hostId: json['hostId'] as String,
      path: json['path'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      introduction: json['introduction'] as String? ?? '',
      hostTypes: json['hostTypes'] == null
          ? const <HostType>{}
          : _hostTypesConverter.fromJson(json['hostTypes'] as List<dynamic>?),
      urls:
          (json['urls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadHost.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadHost._fromJson(<String, dynamic>{
      ...data,
      'hostId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateHost {
  const CreateHost({
    this.imageUrl = '',
    required this.displayName,
    required this.introduction,
    required this.hostTypes,
    this.urls = const <String>[],
  });

  final String imageUrl;
  final String displayName;
  final String introduction;
  final Set<HostType> hostTypes;
  final List<String> urls;

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'displayName': displayName,
      'introduction': introduction,
      'hostTypes': _hostTypesConverter.toJson(hostTypes),
      'urls': urls,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateHost {
  const UpdateHost({
    this.imageUrl,
    this.displayName,
    this.introduction,
    this.hostTypes,
    this.urls,
    this.createdAt,
  });

  final String? imageUrl;
  final String? displayName;
  final String? introduction;
  final Set<HostType>? hostTypes;
  final List<String>? urls;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (displayName != null) 'displayName': displayName,
      if (introduction != null) 'introduction': introduction,
      if (hostTypes != null)
        'hostTypes': _hostTypesConverter.toJson(hostTypes!),
      if (urls != null) 'urls': urls,
      if (createdAt != null) 'createdAt': createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class DeleteHost {}

/// Provides a reference to the hosts collection for reading.
final readHostCollectionReference =
    FirebaseFirestore.instance.collection('hosts').withConverter<ReadHost>(
          fromFirestore: (ds, _) => ReadHost.fromDocumentSnapshot(ds),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a host document for reading.
DocumentReference<ReadHost> readHostDocumentReference({
  required String hostId,
}) =>
    readHostCollectionReference.doc(hostId);

/// Provides a reference to the hosts collection for creating.
final createHostCollectionReference =
    FirebaseFirestore.instance.collection('hosts').withConverter<CreateHost>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a host document for creating.
DocumentReference<CreateHost> createHostDocumentReference({
  required String hostId,
}) =>
    createHostCollectionReference.doc(hostId);

/// Provides a reference to the hosts collection for updating.
final updateHostCollectionReference =
    FirebaseFirestore.instance.collection('hosts').withConverter<UpdateHost>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a host document for updating.
DocumentReference<UpdateHost> updateHostDocumentReference({
  required String hostId,
}) =>
    updateHostCollectionReference.doc(hostId);

/// Provides a reference to the hosts collection for deleting.
final deleteHostCollectionReference =
    FirebaseFirestore.instance.collection('hosts').withConverter<DeleteHost>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a host document for deleting.
DocumentReference<DeleteHost> deleteHostDocumentReference({
  required String hostId,
}) =>
    deleteHostCollectionReference.doc(hostId);

/// Manages queries against the hosts collection.
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

  /// Fetches a specific [ReadHost] document.
  Future<ReadHost?> fetchDocument({
    required String hostId,
    GetOptions? options,
  }) async {
    final ds = await readHostDocumentReference(
      hostId: hostId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [Host] document.
  Stream<ReadHost?> subscribeDocument({
    required String hostId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readHostDocumentReference(
      hostId: hostId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [Host] document.
  Future<DocumentReference<CreateHost>> add({
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

  /// Updates a specific [Host] document.
  Future<void> update({
    required String hostId,
    required UpdateHost updateHost,
  }) =>
      updateHostDocumentReference(
        hostId: hostId,
      ).update(updateHost.toJson());

  /// Deletes a specific [Host] document.
  Future<void> delete({
    required String hostId,
  }) =>
      deleteHostDocumentReference(
        hostId: hostId,
      ).delete();
}
