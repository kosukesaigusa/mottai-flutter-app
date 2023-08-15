// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job.dart';

class ReadJob {
  const ReadJob({
    required this.jobId,
    required this.path,
    required this.hostId,
    required this.imageUrl,
    required this.title,
    required this.place,
    required this.content,
    required this.belongings,
    required this.reward,
    required this.accessDescription,
    required this.accessTypes,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  final String jobId;

  final String path;

  final String hostId;

  final String imageUrl;

  final String title;

  final String place;

  final String content;

  final String belongings;

  final String reward;

  final String accessDescription;

  final Set<AccessType> accessTypes;

  final String comment;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  factory ReadJob._fromJson(Map<String, dynamic> json) {
    return ReadJob(
      jobId: json['jobId'] as String,
      path: json['path'] as String,
      hostId: json['hostId'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? '',
      content: json['content'] as String? ?? '',
      belongings: json['belongings'] as String? ?? '',
      reward: json['reward'] as String? ?? '',
      accessDescription: json['accessDescription'] as String? ?? '',
      accessTypes: json['accessTypes'] == null
          ? const <AccessType>{}
          : _accessTypesConverter
              .fromJson(json['accessTypes'] as List<dynamic>?),
      comment: json['comment'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
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
    this.imageUrl = '',
    required this.title,
    required this.place,
    required this.content,
    required this.belongings,
    required this.reward,
    this.accessDescription = '',
    this.accessTypes = const <AccessType>{},
    this.comment = '',
  });

  final String hostId;
  final String imageUrl;
  final String title;
  final String place;
  final String content;
  final String belongings;
  final String reward;
  final String accessDescription;
  final Set<AccessType> accessTypes;
  final String comment;

  Map<String, dynamic> toJson() {
    return {
      'hostId': hostId,
      'imageUrl': imageUrl,
      'title': title,
      'place': place,
      'content': content,
      'belongings': belongings,
      'reward': reward,
      'accessDescription': accessDescription,
      'accessTypes': _accessTypesConverter.toJson(accessTypes),
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateJob {
  const UpdateJob({
    this.hostId,
    this.imageUrl,
    this.title,
    this.place,
    this.content,
    this.belongings,
    this.reward,
    this.accessDescription,
    this.accessTypes,
    this.comment,
    this.createdAt,
  });

  final String? hostId;
  final String? imageUrl;
  final String? title;
  final String? place;
  final String? content;
  final String? belongings;
  final String? reward;
  final String? accessDescription;
  final Set<AccessType>? accessTypes;
  final String? comment;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (hostId != null) 'hostId': hostId,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (title != null) 'title': title,
      if (place != null) 'place': place,
      if (content != null) 'content': content,
      if (belongings != null) 'belongings': belongings,
      if (reward != null) 'reward': reward,
      if (accessDescription != null) 'accessDescription': accessDescription,
      if (accessTypes != null)
        'accessTypes': _accessTypesConverter.toJson(accessTypes!),
      if (comment != null) 'comment': comment,
      if (createdAt != null) 'createdAt': createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class DeleteJob {}

/// Provides a reference to the jobs collection for reading.
final readJobCollectionReference =
    FirebaseFirestore.instance.collection('jobs').withConverter<ReadJob>(
          fromFirestore: (ds, _) => ReadJob.fromDocumentSnapshot(ds),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a job document for reading.
DocumentReference<ReadJob> readJobDocumentReference({
  required String jobId,
}) =>
    readJobCollectionReference.doc(jobId);

/// Provides a reference to the jobs collection for creating.
final createJobCollectionReference =
    FirebaseFirestore.instance.collection('jobs').withConverter<CreateJob>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a job document for creating.
DocumentReference<CreateJob> createJobDocumentReference({
  required String jobId,
}) =>
    createJobCollectionReference.doc(jobId);

/// Provides a reference to the jobs collection for updating.
final updateJobCollectionReference =
    FirebaseFirestore.instance.collection('jobs').withConverter<UpdateJob>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (obj, _) => obj.toJson(),
        );

/// Provides a reference to a job document for updating.
DocumentReference<UpdateJob> updateJobDocumentReference({
  required String jobId,
}) =>
    updateJobCollectionReference.doc(jobId);

/// Provides a reference to the jobs collection for deleting.
final deleteJobCollectionReference =
    FirebaseFirestore.instance.collection('jobs').withConverter<DeleteJob>(
          fromFirestore: (_, __) => throw UnimplementedError(),
          toFirestore: (_, __) => throw UnimplementedError(),
        );

/// Provides a reference to a job document for deleting.
DocumentReference<DeleteJob> deleteJobDocumentReference({
  required String jobId,
}) =>
    deleteJobCollectionReference.doc(jobId);

/// Manages queries against the jobs collection.
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

  /// Fetches a specific [ReadJob] document.
  Future<ReadJob?> fetchDocument({
    required String jobId,
    GetOptions? options,
  }) async {
    final ds = await readJobDocumentReference(
      jobId: jobId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [Job] document.
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

  /// Updates a specific [Job] document.
  Future<void> update({
    required String jobId,
    required UpdateJob updateJob,
  }) =>
      updateJobDocumentReference(
        jobId: jobId,
      ).update(updateJob.toJson());

  /// Deletes a specific [Job] document.
  Future<void> delete({
    required String jobId,
  }) =>
      deleteJobDocumentReference(
        jobId: jobId,
      ).delete();
}
