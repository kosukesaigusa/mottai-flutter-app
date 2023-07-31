// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job.dart';

class ReadJob {
  const ReadJob({
    required this.jobId,
    required this.path,
    required this.hostId,
    required this.title,
    required this.content,
    required this.place,
    required this.accessTypes,
    required this.accessDescription,
    required this.belongings,
    required this.reward,
    required this.comment,
    required this.urls,
    required this.createdAt,
    required this.updatedAt,
  });

  final String jobId;

  final String path;

  final String hostId;

  final String title;

  final String content;

  final String place;

  final Set<AccessType> accessTypes;

  final String accessDescription;

  final String belongings;

  final String reward;

  final String comment;

  final List<String> urls;

  final SealedTimestamp createdAt;

  final SealedTimestamp updatedAt;

  factory ReadJob._fromJson(Map<String, dynamic> json) {
    return ReadJob(
      jobId: json['jobId'] as String,
      path: json['path'] as String,
      hostId: json['hostId'] as String,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      place: json['place'] as String? ?? '',
      accessTypes: json['accessTypes'] == null
          ? const <AccessType>{}
          : _accessTypesConverter
              .fromJson(json['accessTypes'] as List<dynamic>?),
      accessDescription: json['accessDescription'] as String? ?? '',
      belongings: json['belongings'] as String? ?? '',
      reward: json['reward'] as String? ?? '',
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
      'jobId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateJob {
  const CreateJob({
    required this.hostId,
    required this.title,
    required this.content,
    required this.place,
    this.accessTypes = const <AccessType>{},
    this.accessDescription = '',
    required this.belongings,
    required this.reward,
    this.comment = '',
    this.urls = const <String>[],
    this.createdAt = const ServerTimestamp(),
    this.updatedAt = const ServerTimestamp(),
  });

  final String hostId;
  final String title;
  final String content;
  final String place;
  final Set<AccessType> accessTypes;
  final String accessDescription;
  final String belongings;
  final String reward;
  final String comment;
  final List<String> urls;
  final SealedTimestamp createdAt;
  final SealedTimestamp updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'hostId': hostId,
      'title': title,
      'content': content,
      'place': place,
      'accessTypes': _accessTypesConverter.toJson(accessTypes),
      'accessDescription': accessDescription,
      'belongings': belongings,
      'reward': reward,
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
    this.title,
    this.content,
    this.place,
    this.accessTypes,
    this.accessDescription,
    this.belongings,
    this.reward,
    this.comment,
    this.urls,
    this.createdAt,
    this.updatedAt = const ServerTimestamp(),
  });

  final String? hostId;
  final String? title;
  final String? content;
  final String? place;
  final Set<AccessType>? accessTypes;
  final String? accessDescription;
  final String? belongings;
  final String? reward;
  final String? comment;
  final List<String>? urls;
  final SealedTimestamp? createdAt;
  final SealedTimestamp? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      if (hostId != null) 'hostId': hostId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (place != null) 'place': place,
      if (accessTypes != null)
        'accessTypes': _accessTypesConverter.toJson(accessTypes!),
      if (accessDescription != null) 'accessDescription': accessDescription,
      if (belongings != null) 'belongings': belongings,
      if (reward != null) 'reward': reward,
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

/// A [DocumentReference] to job document to read.
DocumentReference<ReadJob> readJobDocumentReference({
  required String jobId,
}) =>
    readJobCollectionReference.doc(jobId);

/// A [CollectionReference] to jobs collection to create.
final createJobCollectionReference =
    FirebaseFirestore.instance.collection('jobs').withConverter<CreateJob>(
          fromFirestore: (ds, _) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// A [DocumentReference] to job document to create.
DocumentReference<CreateJob> createJobDocumentReference({
  required String jobId,
}) =>
    createJobCollectionReference.doc(jobId);

/// A [CollectionReference] to jobs collection to update.
final updateJobCollectionReference =
    FirebaseFirestore.instance.collection('jobs').withConverter<UpdateJob>(
          fromFirestore: (ds, _) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// A [DocumentReference] to job document to update.
DocumentReference<UpdateJob> updateJobDocumentReference({
  required String jobId,
}) =>
    updateJobCollectionReference.doc(jobId);

/// A [CollectionReference] to jobs collection to delete.
final deleteJobCollectionReference =
    FirebaseFirestore.instance.collection('jobs');

/// A [DocumentReference] to job document to delete.
DocumentReference<Object?> deleteJobDocumentReference({
  required String jobId,
}) =>
    deleteJobCollectionReference.doc(jobId);

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
    required String jobId,
    GetOptions? options,
  }) async {
    final ds = await readJobDocumentReference(
      jobId: jobId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specified [Job] document.
  Stream<ReadJob?> subscribeDocument({
    required String jobId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readJobDocumentReference(
      jobId: jobId,
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
    required String jobId,
    required CreateJob createJob,
    SetOptions? options,
  }) =>
      createJobDocumentReference(
        jobId: jobId,
      ).set(createJob, options);

  /// Updates a specified [Job] document.
  Future<void> update({
    required String jobId,
    required UpdateJob updateJob,
  }) =>
      updateJobDocumentReference(
        jobId: jobId,
      ).update(updateJob.toJson());

  /// Deletes a specified [Job] document.
  Future<void> delete({
    required String jobId,
  }) =>
      deleteJobDocumentReference(
        jobId: jobId,
      ).delete();
}
