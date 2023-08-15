// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'in_review_config.dart';

class ReadInReviewConfig {
  const ReadInReviewConfig({
    required this.inReviewConfigId,
    required this.path,
    required this.iOSInReviewVersion,
    required this.enableIOSInReviewMode,
    required this.androidInReviewVersion,
    required this.enableAndroidInReviewMode,
  });

  final String inReviewConfigId;

  final String path;

  final String iOSInReviewVersion;

  final bool enableIOSInReviewMode;

  final String androidInReviewVersion;

  final bool enableAndroidInReviewMode;

  factory ReadInReviewConfig._fromJson(Map<String, dynamic> json) {
    return ReadInReviewConfig(
      inReviewConfigId: json['inReviewConfigId'] as String,
      path: json['path'] as String,
      iOSInReviewVersion: json['iOSInReviewVersion'] as String? ?? '1.0.0',
      enableIOSInReviewMode: json['enableIOSInReviewMode'] as bool? ?? false,
      androidInReviewVersion:
          json['androidInReviewVersion'] as String? ?? '1.0.0',
      enableAndroidInReviewMode:
          json['enableAndroidInReviewMode'] as bool? ?? false,
    );
  }

  factory ReadInReviewConfig.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadInReviewConfig._fromJson(<String, dynamic>{
      ...data,
      'inReviewConfigId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateInReviewConfig {
  const CreateInReviewConfig({
    required this.iOSInReviewVersion,
    required this.enableIOSInReviewMode,
    required this.androidInReviewVersion,
    required this.enableAndroidInReviewMode,
  });

  final String iOSInReviewVersion;
  final bool enableIOSInReviewMode;
  final String androidInReviewVersion;
  final bool enableAndroidInReviewMode;

  Map<String, dynamic> toJson() {
    return {
      'iOSInReviewVersion': iOSInReviewVersion,
      'enableIOSInReviewMode': enableIOSInReviewMode,
      'androidInReviewVersion': androidInReviewVersion,
      'enableAndroidInReviewMode': enableAndroidInReviewMode,
    };
  }
}

class UpdateInReviewConfig {
  const UpdateInReviewConfig({
    this.iOSInReviewVersion,
    this.enableIOSInReviewMode,
    this.androidInReviewVersion,
    this.enableAndroidInReviewMode,
  });

  final String? iOSInReviewVersion;
  final bool? enableIOSInReviewMode;
  final String? androidInReviewVersion;
  final bool? enableAndroidInReviewMode;

  Map<String, dynamic> toJson() {
    return {
      if (iOSInReviewVersion != null) 'iOSInReviewVersion': iOSInReviewVersion,
      if (enableIOSInReviewMode != null)
        'enableIOSInReviewMode': enableIOSInReviewMode,
      if (androidInReviewVersion != null)
        'androidInReviewVersion': androidInReviewVersion,
      if (enableAndroidInReviewMode != null)
        'enableAndroidInReviewMode': enableAndroidInReviewMode,
    };
  }
}

class DeleteInReviewConfig {}

/// Provides a reference to the configurations collection for reading.
final readInReviewConfigCollectionReference = FirebaseFirestore.instance
    .collection('configurations')
    .withConverter<ReadInReviewConfig>(
      fromFirestore: (ds, _) => ReadInReviewConfig.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a inReviewConfig document for reading.
DocumentReference<ReadInReviewConfig> readInReviewConfigDocumentReference({
  required String inReviewConfigId,
}) =>
    readInReviewConfigCollectionReference.doc(inReviewConfigId);

/// Provides a reference to the configurations collection for creating.
final createInReviewConfigCollectionReference = FirebaseFirestore.instance
    .collection('configurations')
    .withConverter<CreateInReviewConfig>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a inReviewConfig document for creating.
DocumentReference<CreateInReviewConfig> createInReviewConfigDocumentReference({
  required String inReviewConfigId,
}) =>
    createInReviewConfigCollectionReference.doc(inReviewConfigId);

/// Provides a reference to the configurations collection for updating.
final updateInReviewConfigCollectionReference = FirebaseFirestore.instance
    .collection('configurations')
    .withConverter<UpdateInReviewConfig>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a inReviewConfig document for updating.
DocumentReference<UpdateInReviewConfig> updateInReviewConfigDocumentReference({
  required String inReviewConfigId,
}) =>
    updateInReviewConfigCollectionReference.doc(inReviewConfigId);

/// Provides a reference to the configurations collection for deleting.
final deleteInReviewConfigCollectionReference = FirebaseFirestore.instance
    .collection('configurations')
    .withConverter<DeleteInReviewConfig>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a inReviewConfig document for deleting.
DocumentReference<DeleteInReviewConfig> deleteInReviewConfigDocumentReference({
  required String inReviewConfigId,
}) =>
    deleteInReviewConfigCollectionReference.doc(inReviewConfigId);

/// Manages queries against the configurations collection.
class InReviewConfigQuery {
  /// Fetches [ReadInReviewConfig] documents.
  Future<List<ReadInReviewConfig>> fetchDocuments({
    GetOptions? options,
    Query<ReadInReviewConfig>? Function(Query<ReadInReviewConfig> query)?
        queryBuilder,
    int Function(ReadInReviewConfig lhs, ReadInReviewConfig rhs)? compare,
  }) async {
    Query<ReadInReviewConfig> query = readInReviewConfigCollectionReference;
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

  /// Subscribes [InReviewConfig] documents.
  Stream<List<ReadInReviewConfig>> subscribeDocuments({
    Query<ReadInReviewConfig>? Function(Query<ReadInReviewConfig> query)?
        queryBuilder,
    int Function(ReadInReviewConfig lhs, ReadInReviewConfig rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadInReviewConfig> query = readInReviewConfigCollectionReference;
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

  /// Fetches a specific [ReadInReviewConfig] document.
  Future<ReadInReviewConfig?> fetchDocument({
    required String inReviewConfigId,
    GetOptions? options,
  }) async {
    final ds = await readInReviewConfigDocumentReference(
      inReviewConfigId: inReviewConfigId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [InReviewConfig] document.
  Stream<ReadInReviewConfig?> subscribeDocument({
    required String inReviewConfigId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readInReviewConfigDocumentReference(
      inReviewConfigId: inReviewConfigId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [InReviewConfig] document.
  Future<DocumentReference<CreateInReviewConfig>> add({
    required CreateInReviewConfig createInReviewConfig,
  }) =>
      createInReviewConfigCollectionReference.add(createInReviewConfig);

  /// Sets a [InReviewConfig] document.
  Future<void> set({
    required String inReviewConfigId,
    required CreateInReviewConfig createInReviewConfig,
    SetOptions? options,
  }) =>
      createInReviewConfigDocumentReference(
        inReviewConfigId: inReviewConfigId,
      ).set(createInReviewConfig, options);

  /// Updates a specific [InReviewConfig] document.
  Future<void> update({
    required String inReviewConfigId,
    required UpdateInReviewConfig updateInReviewConfig,
  }) =>
      updateInReviewConfigDocumentReference(
        inReviewConfigId: inReviewConfigId,
      ).update(updateInReviewConfig.toJson());

  /// Deletes a specific [InReviewConfig] document.
  Future<void> delete({
    required String inReviewConfigId,
  }) =>
      deleteInReviewConfigDocumentReference(
        inReviewConfigId: inReviewConfigId,
      ).delete();
}
