// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job.dart';

class ReadJob {
  const ReadJob._({
    required this.hostLocationId,
    required this.hostLocationReference,
    required this.hostId,
    required this.content,
    required this.place,
    required this.accessTypes,
    required this.accessDescription,
    required this.belongings,
    required this.comment,
    required this.urls,
    required this.createdAt,
    required this.updatedAt,
  });

  final String hostLocationId;
  final DocumentReference<ReadJob> hostLocationReference;
  final String hostId;
  final String content;
  final String place;
  final Set<AccessType> accessTypes;
  final String accessDescription;
  final String belongings;
  final String comment;
  final List<String> urls;
  final SealedTimestamp createdAt;
  final SealedTimestamp updatedAt;

  factory ReadJob._fromJson(Map<String, dynamic> json) {
    return ReadJob._(
      hostLocationId: json['hostLocationId'] as String,
      hostLocationReference:
          json['hostLocationReference'] as DocumentReference<ReadJob>,
      hostId: json['hostId'] as String,
      content: json['content'] as String? ?? '',
      place: json['place'] as String? ?? '',
      accessTypes: json['accessTypes'] == null
          ? const <AccessType>{}
          : _accessTypesConverter
              .fromJson(json['accessTypes'] as List<dynamic>?),
      accessDescription: json['accessDescription'] as String? ?? '',
      belongings: json['belongings'] as String? ?? '',
      comment: json['comment'] as String? ?? '',
      urls:
          (json['urls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
      createdAt: json['createdAt'] == null
          ? const ServerTimestamp()
          : sealedTimestampConverter.fromJson(json['createdAt'] as Object),
      updatedAt: json['updatedAt'] == null
          ? const ServerTimestamp()
          : alwaysUseServerTimestampSealedTimestampConverter
              .fromJson(json['updatedAt'] as Object),
    );
  }

  factory ReadJob.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadJob._fromJson(<String, dynamic>{
      ...data,
      'hostLocationId': ds.id,
      'hostLocationReference': ds.reference.parent.doc(ds.id).withConverter(
            fromFirestore: (ds, _) => ReadJob.fromDocumentSnapshot(ds),
            toFirestore: (obj, _) => throw UnimplementedError(),
          ),
    });
  }

  ReadJob copyWith({
    String? hostLocationId,
    DocumentReference<ReadJob>? hostLocationReference,
    String? hostId,
    String? content,
    String? place,
    Set<AccessType>? accessTypes,
    String? accessDescription,
    String? belongings,
    String? comment,
    List<String>? urls,
    SealedTimestamp? createdAt,
    SealedTimestamp? updatedAt,
  }) {
    return ReadJob._(
      hostLocationId: hostLocationId ?? this.hostLocationId,
      hostLocationReference:
          hostLocationReference ?? this.hostLocationReference,
      hostId: hostId ?? this.hostId,
      content: content ?? this.content,
      place: place ?? this.place,
      accessTypes: accessTypes ?? this.accessTypes,
      accessDescription: accessDescription ?? this.accessDescription,
      belongings: belongings ?? this.belongings,
      comment: comment ?? this.comment,
      urls: urls ?? this.urls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CreateJob {
  const CreateJob({
    required this.hostId,
    required this.content,
    required this.place,
    this.accessTypes = const <AccessType>{},
    this.accessDescription = '',
    required this.belongings,
    this.comment = '',
    this.urls = const <String>[],
    this.createdAt = const ServerTimestamp(),
    this.updatedAt = const ServerTimestamp(),
  });

  final String hostId;
  final String content;
  final String place;
  final Set<AccessType> accessTypes;
  final String accessDescription;
  final String belongings;
  final String comment;
  final List<String> urls;
  final SealedTimestamp createdAt;
  final SealedTimestamp updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'hostId': hostId,
      'content': content,
      'place': place,
      'accessTypes': _accessTypesConverter.toJson(accessTypes),
      'accessDescription': accessDescription,
      'belongings': belongings,
      'comment': comment,
      'urls': urls,
      'createdAt': sealedTimestampConverter.toJson(createdAt),
      'updatedAt':
          alwaysUseServerTimestampSealedTimestampConverter.toJson(updatedAt),
    };
  }
}

class UpdateJob {
  const UpdateJob({
    this.hostId,
    this.content,
    this.place,
    this.accessTypes,
    this.accessDescription,
    this.belongings,
    this.comment,
    this.urls,
    this.createdAt,
    this.updatedAt = const ServerTimestamp(),
  });

  final String? hostId;
  final String? content;
  final String? place;
  final Set<AccessType>? accessTypes;
  final String? accessDescription;
  final String? belongings;
  final String? comment;
  final List<String>? urls;
  final SealedTimestamp? createdAt;
  final SealedTimestamp? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      if (hostId != null) 'hostId': hostId,
      if (content != null) 'content': content,
      if (place != null) 'place': place,
      if (accessTypes != null)
        'accessTypes': _accessTypesConverter.toJson(accessTypes!),
      if (accessDescription != null) 'accessDescription': accessDescription,
      if (belongings != null) 'belongings': belongings,
      if (comment != null) 'comment': comment,
      if (urls != null) 'urls': urls,
      if (createdAt != null)
        'createdAt': sealedTimestampConverter.toJson(createdAt!),
      'updatedAt': updatedAt == null
          ? const ServerTimestamp()
          : alwaysUseServerTimestampSealedTimestampConverter.toJson(updatedAt!),
    };
  }
}

/// A [CollectionReference] to jobs collection to read.
final readJobCollectionReference =
    FirebaseFirestore.instance.collection('jobs').withConverter<ReadJob>(
          fromFirestore: (ds, _) => ReadJob.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => throw UnimplementedError(),
        );

/// A [DocumentReference] to hostLocation document to read.
DocumentReference<ReadJob> readJobDocumentReference({
  required String hostLocationId,
}) =>
    readJobCollectionReference.doc(hostLocationId);

/// A [CollectionReference] to jobs collection to create.
final createJobCollectionReference =
    FirebaseFirestore.instance.collection('jobs').withConverter<CreateJob>(
          fromFirestore: (ds, _) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// A [DocumentReference] to hostLocation document to create.
DocumentReference<CreateJob> createJobDocumentReference({
  required String hostLocationId,
}) =>
    createJobCollectionReference.doc(hostLocationId);

/// A [CollectionReference] to jobs collection to update.
final updateJobCollectionReference =
    FirebaseFirestore.instance.collection('jobs').withConverter<UpdateJob>(
          fromFirestore: (ds, _) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// A [DocumentReference] to hostLocation document to update.
DocumentReference<UpdateJob> updateJobDocumentReference({
  required String hostLocationId,
}) =>
    updateJobCollectionReference.doc(hostLocationId);

/// A [CollectionReference] to jobs collection to delete.
final deleteJobCollectionReference =
    FirebaseFirestore.instance.collection('jobs');

/// A [DocumentReference] to hostLocation document to delete.
DocumentReference<Object?> deleteJobDocumentReference({
  required String hostLocationId,
}) =>
    deleteJobCollectionReference.doc(hostLocationId);

/// A query manager to execute query against [Job].
class JobQuery {
  /// Fetches [ReadJob] documents.
  Future<List<ReadJob>> fetchDocuments({
    GetOptions? options,
    Query<ReadJob>? Function(Query<ReadJob> query)? queryBuilder,
    int Function(ReadJob lhs, ReadJob rhs)? compare,
  }) async {
    Query<ReadJob> query = readJobCollectionReference;
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

  /// Subscribes [Job] documents.
  Stream<List<ReadJob>> subscribeDocuments({
    Query<ReadJob>? Function(Query<ReadJob> query)? queryBuilder,
    int Function(ReadJob lhs, ReadJob rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadJob> query = readJobCollectionReference;
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

  /// Fetches a specified [ReadJob] document.
  Future<ReadJob?> fetchDocument({
    required String hostLocationId,
    GetOptions? options,
  }) async {
    final ds = await readJobDocumentReference(
      hostLocationId: hostLocationId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specified [Job] document.
  Future<Stream<ReadJob?>> subscribeDocument({
    required String hostLocationId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) async {
    var streamDs = readJobDocumentReference(
      hostLocationId: hostLocationId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [Job] document.
  Future<DocumentReference<CreateJob>> add({
    required CreateJob createJob,
  }) =>
      createJobCollectionReference.add(createJob);

  /// Sets a [Job] document.
  Future<void> set({
    required String hostLocationId,
    required CreateJob createJob,
    SetOptions? options,
  }) =>
      createJobDocumentReference(
        hostLocationId: hostLocationId,
      ).set(createJob, options);

  /// Updates a specified [Job] document.
  Future<void> update({
    required String hostLocationId,
    required UpdateJob updateJob,
  }) =>
      updateJobDocumentReference(
        hostLocationId: hostLocationId,
      ).update(updateJob.toJson());

  /// Deletes a specified [Job] document.
  Future<void> delete({
    required String hostLocationId,
  }) =>
      deleteJobDocumentReference(
        hostLocationId: hostLocationId,
      ).delete();
}
