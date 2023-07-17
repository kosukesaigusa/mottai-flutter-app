// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'force_update_config.dart';

class ReadForceUpdateConfig {
  const ReadForceUpdateConfig._({
    required this.forceUpdateConfigId,
    required this.forceUpdateConfigReference,
    required this.iOSLatestVersion,
    required this.iOSMinRequiredVersion,
    required this.iOSForceUpdate,
    required this.androidLatestVersion,
    required this.androidMinRequiredVersion,
    required this.androidForceUpdate,
  });

  final String forceUpdateConfigId;
  final DocumentReference<ReadForceUpdateConfig> forceUpdateConfigReference;
  final String iOSLatestVersion;
  final String iOSMinRequiredVersion;
  final bool iOSForceUpdate;
  final String androidLatestVersion;
  final String androidMinRequiredVersion;
  final bool androidForceUpdate;

  factory ReadForceUpdateConfig._fromJson(Map<String, dynamic> json) {
    return ReadForceUpdateConfig._(
      forceUpdateConfigId: json['forceUpdateConfigId'] as String,
      forceUpdateConfigReference: json['forceUpdateConfigReference']
          as DocumentReference<ReadForceUpdateConfig>,
      iOSLatestVersion: json['iOSLatestVersion'] as String,
      iOSMinRequiredVersion: json['iOSMinRequiredVersion'] as String,
      iOSForceUpdate: json['iOSForceUpdate'] as bool? ?? false,
      androidLatestVersion: json['androidLatestVersion'] as String,
      androidMinRequiredVersion: json['androidMinRequiredVersion'] as String,
      androidForceUpdate: json['androidForceUpdate'] as bool? ?? false,
    );
  }

  factory ReadForceUpdateConfig.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadForceUpdateConfig._fromJson(<String, dynamic>{
      ...data,
      'forceUpdateConfigId': ds.id,
      'forceUpdateConfigReference':
          ds.reference.parent.doc(ds.id).withConverter(
                fromFirestore: (ds, _) =>
                    ReadForceUpdateConfig.fromDocumentSnapshot(ds),
                toFirestore: (obj, _) => throw UnimplementedError(),
              ),
    });
  }

  ReadForceUpdateConfig copyWith({
    String? forceUpdateConfigId,
    DocumentReference<ReadForceUpdateConfig>? forceUpdateConfigReference,
    String? iOSLatestVersion,
    String? iOSMinRequiredVersion,
    bool? iOSForceUpdate,
    String? androidLatestVersion,
    String? androidMinRequiredVersion,
    bool? androidForceUpdate,
  }) {
    return ReadForceUpdateConfig._(
      forceUpdateConfigId: forceUpdateConfigId ?? this.forceUpdateConfigId,
      forceUpdateConfigReference:
          forceUpdateConfigReference ?? this.forceUpdateConfigReference,
      iOSLatestVersion: iOSLatestVersion ?? this.iOSLatestVersion,
      iOSMinRequiredVersion:
          iOSMinRequiredVersion ?? this.iOSMinRequiredVersion,
      iOSForceUpdate: iOSForceUpdate ?? this.iOSForceUpdate,
      androidLatestVersion: androidLatestVersion ?? this.androidLatestVersion,
      androidMinRequiredVersion:
          androidMinRequiredVersion ?? this.androidMinRequiredVersion,
      androidForceUpdate: androidForceUpdate ?? this.androidForceUpdate,
    );
  }
}

class CreateForceUpdateConfig {
  const CreateForceUpdateConfig({
    required this.iOSLatestVersion,
    required this.iOSMinRequiredVersion,
    this.iOSForceUpdate = false,
    required this.androidLatestVersion,
    required this.androidMinRequiredVersion,
    this.androidForceUpdate = false,
  });

  final String iOSLatestVersion;
  final String iOSMinRequiredVersion;
  final bool iOSForceUpdate;
  final String androidLatestVersion;
  final String androidMinRequiredVersion;
  final bool androidForceUpdate;

  Map<String, dynamic> toJson() {
    return {
      'iOSLatestVersion': iOSLatestVersion,
      'iOSMinRequiredVersion': iOSMinRequiredVersion,
      'iOSForceUpdate': iOSForceUpdate,
      'androidLatestVersion': androidLatestVersion,
      'androidMinRequiredVersion': androidMinRequiredVersion,
      'androidForceUpdate': androidForceUpdate,
    };
  }
}

class UpdateForceUpdateConfig {
  const UpdateForceUpdateConfig({
    this.iOSLatestVersion,
    this.iOSMinRequiredVersion,
    this.iOSForceUpdate,
    this.androidLatestVersion,
    this.androidMinRequiredVersion,
    this.androidForceUpdate,
  });

  final String? iOSLatestVersion;
  final String? iOSMinRequiredVersion;
  final bool? iOSForceUpdate;
  final String? androidLatestVersion;
  final String? androidMinRequiredVersion;
  final bool? androidForceUpdate;

  Map<String, dynamic> toJson() {
    return {
      if (iOSLatestVersion != null) 'iOSLatestVersion': iOSLatestVersion,
      if (iOSMinRequiredVersion != null)
        'iOSMinRequiredVersion': iOSMinRequiredVersion,
      if (iOSForceUpdate != null) 'iOSForceUpdate': iOSForceUpdate,
      if (androidLatestVersion != null)
        'androidLatestVersion': androidLatestVersion,
      if (androidMinRequiredVersion != null)
        'androidMinRequiredVersion': androidMinRequiredVersion,
      if (androidForceUpdate != null) 'androidForceUpdate': androidForceUpdate,
    };
  }
}

/// A [CollectionReference] to configurations collection to read.
final readForceUpdateConfigCollectionReference = FirebaseFirestore.instance
    .collection('configurations')
    .withConverter<ReadForceUpdateConfig>(
      fromFirestore: (ds, _) => ReadForceUpdateConfig.fromDocumentSnapshot(ds),
      toFirestore: (obj, _) => throw UnimplementedError(),
    );

/// A [DocumentReference] to forceUpdateConfig document to read.
DocumentReference<ReadForceUpdateConfig>
    readForceUpdateConfigDocumentReference({
  required String forceUpdateConfigId,
}) =>
        readForceUpdateConfigCollectionReference.doc(forceUpdateConfigId);

/// A [CollectionReference] to configurations collection to create.
final createForceUpdateConfigCollectionReference = FirebaseFirestore.instance
    .collection('configurations')
    .withConverter<CreateForceUpdateConfig>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to forceUpdateConfig document to create.
DocumentReference<CreateForceUpdateConfig>
    createForceUpdateConfigDocumentReference({
  required String forceUpdateConfigId,
}) =>
        createForceUpdateConfigCollectionReference.doc(forceUpdateConfigId);

/// A [CollectionReference] to configurations collection to update.
final updateForceUpdateConfigCollectionReference = FirebaseFirestore.instance
    .collection('configurations')
    .withConverter<UpdateForceUpdateConfig>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to forceUpdateConfig document to update.
DocumentReference<UpdateForceUpdateConfig>
    updateForceUpdateConfigDocumentReference({
  required String forceUpdateConfigId,
}) =>
        updateForceUpdateConfigCollectionReference.doc(forceUpdateConfigId);

/// A [CollectionReference] to configurations collection to delete.
final deleteForceUpdateConfigCollectionReference =
    FirebaseFirestore.instance.collection('configurations');

/// A [DocumentReference] to forceUpdateConfig document to delete.
DocumentReference<Object?> deleteForceUpdateConfigDocumentReference({
  required String forceUpdateConfigId,
}) =>
    deleteForceUpdateConfigCollectionReference.doc(forceUpdateConfigId);

/// A query manager to execute query against [ForceUpdateConfig].
class ForceUpdateConfigQuery {
  /// Fetches [ReadForceUpdateConfig] documents.
  Future<List<ReadForceUpdateConfig>> fetchDocuments({
    GetOptions? options,
    Query<ReadForceUpdateConfig>? Function(Query<ReadForceUpdateConfig> query)?
        queryBuilder,
    int Function(ReadForceUpdateConfig lhs, ReadForceUpdateConfig rhs)? compare,
  }) async {
    Query<ReadForceUpdateConfig> query =
        readForceUpdateConfigCollectionReference;
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

  /// Subscribes [ForceUpdateConfig] documents.
  Stream<List<ReadForceUpdateConfig>> subscribeDocuments({
    Query<ReadForceUpdateConfig>? Function(Query<ReadForceUpdateConfig> query)?
        queryBuilder,
    int Function(ReadForceUpdateConfig lhs, ReadForceUpdateConfig rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadForceUpdateConfig> query =
        readForceUpdateConfigCollectionReference;
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

  /// Fetches a specified [ReadForceUpdateConfig] document.
  Future<ReadForceUpdateConfig?> fetchDocument({
    required String forceUpdateConfigId,
    GetOptions? options,
  }) async {
    final ds = await readForceUpdateConfigDocumentReference(
      forceUpdateConfigId: forceUpdateConfigId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specified [ForceUpdateConfig] document.
  Stream<ReadForceUpdateConfig?> subscribeDocument({
    required String forceUpdateConfigId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readForceUpdateConfigDocumentReference(
      forceUpdateConfigId: forceUpdateConfigId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [ForceUpdateConfig] document.
  Future<DocumentReference<CreateForceUpdateConfig>> add({
    required CreateForceUpdateConfig createForceUpdateConfig,
  }) =>
      createForceUpdateConfigCollectionReference.add(createForceUpdateConfig);

  /// Sets a [ForceUpdateConfig] document.
  Future<void> set({
    required String forceUpdateConfigId,
    required CreateForceUpdateConfig createForceUpdateConfig,
    SetOptions? options,
  }) =>
      createForceUpdateConfigDocumentReference(
        forceUpdateConfigId: forceUpdateConfigId,
      ).set(createForceUpdateConfig, options);

  /// Updates a specified [ForceUpdateConfig] document.
  Future<void> update({
    required String forceUpdateConfigId,
    required UpdateForceUpdateConfig updateForceUpdateConfig,
  }) =>
      updateForceUpdateConfigDocumentReference(
        forceUpdateConfigId: forceUpdateConfigId,
      ).update(updateForceUpdateConfig.toJson());

  /// Deletes a specified [ForceUpdateConfig] document.
  Future<void> delete({
    required String forceUpdateConfigId,
  }) =>
      deleteForceUpdateConfigDocumentReference(
        forceUpdateConfigId: forceUpdateConfigId,
      ).delete();
}
