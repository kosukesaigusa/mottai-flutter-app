// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'use_social_login.dart';

class ReadUseSocialLogin {
  const ReadUseSocialLogin({
    required this.useSocialLoginId,
    required this.path,
    required this.isGoogleEnabled,
    required this.isLINEEnabled,
    required this.isAppleEnabled,
  });

  final String useSocialLoginId;

  final String path;

  final bool isGoogleEnabled;

  final bool isLINEEnabled;

  final bool isAppleEnabled;

  factory ReadUseSocialLogin._fromJson(Map<String, dynamic> json) {
    return ReadUseSocialLogin(
      useSocialLoginId: json['useSocialLoginId'] as String,
      path: json['path'] as String,
      isGoogleEnabled: json['isGoogleEnabled'] as bool? ?? false,
      isLINEEnabled: json['isLINEEnabled'] as bool? ?? false,
      isAppleEnabled: json['isAppleEnabled'] as bool? ?? false,
    );
  }

  factory ReadUseSocialLogin.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadUseSocialLogin._fromJson(<String, dynamic>{
      ...data,
      'useSocialLoginId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateUseSocialLogin {
  const CreateUseSocialLogin({
    this.isGoogleEnabled = false,
    this.isLINEEnabled = false,
    this.isAppleEnabled = false,
  });

  final bool isGoogleEnabled;
  final bool isLINEEnabled;
  final bool isAppleEnabled;

  Map<String, dynamic> toJson() {
    return {
      'isGoogleEnabled': isGoogleEnabled,
      'isLINEEnabled': isLINEEnabled,
      'isAppleEnabled': isAppleEnabled,
    };
  }
}

class UpdateUseSocialLogin {
  const UpdateUseSocialLogin({
    this.isGoogleEnabled,
    this.isLINEEnabled,
    this.isAppleEnabled,
  });

  final bool? isGoogleEnabled;
  final bool? isLINEEnabled;
  final bool? isAppleEnabled;

  Map<String, dynamic> toJson() {
    return {
      if (isGoogleEnabled != null) 'isGoogleEnabled': isGoogleEnabled,
      if (isLINEEnabled != null) 'isLINEEnabled': isLINEEnabled,
      if (isAppleEnabled != null) 'isAppleEnabled': isAppleEnabled,
    };
  }
}

/// A [CollectionReference] to useSocialLogins collection to read.
final readUseSocialLoginCollectionReference = FirebaseFirestore.instance
    .collection('useSocialLogins')
    .withConverter<ReadUseSocialLogin>(
      fromFirestore: (ds, _) => ReadUseSocialLogin.fromDocumentSnapshot(ds),
      toFirestore: (obj, _) => throw UnimplementedError(),
    );

/// A [DocumentReference] to useSocialLogin document to read.
DocumentReference<ReadUseSocialLogin> readUseSocialLoginDocumentReference({
  required String useSocialLoginId,
}) =>
    readUseSocialLoginCollectionReference.doc(useSocialLoginId);

/// A [CollectionReference] to useSocialLogins collection to create.
final createUseSocialLoginCollectionReference = FirebaseFirestore.instance
    .collection('useSocialLogins')
    .withConverter<CreateUseSocialLogin>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to useSocialLogin document to create.
DocumentReference<CreateUseSocialLogin> createUseSocialLoginDocumentReference({
  required String useSocialLoginId,
}) =>
    createUseSocialLoginCollectionReference.doc(useSocialLoginId);

/// A [CollectionReference] to useSocialLogins collection to update.
final updateUseSocialLoginCollectionReference = FirebaseFirestore.instance
    .collection('useSocialLogins')
    .withConverter<UpdateUseSocialLogin>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to useSocialLogin document to update.
DocumentReference<UpdateUseSocialLogin> updateUseSocialLoginDocumentReference({
  required String useSocialLoginId,
}) =>
    updateUseSocialLoginCollectionReference.doc(useSocialLoginId);

/// A [CollectionReference] to useSocialLogins collection to delete.
final deleteUseSocialLoginCollectionReference =
    FirebaseFirestore.instance.collection('useSocialLogins');

/// A [DocumentReference] to useSocialLogin document to delete.
DocumentReference<Object?> deleteUseSocialLoginDocumentReference({
  required String useSocialLoginId,
}) =>
    deleteUseSocialLoginCollectionReference.doc(useSocialLoginId);

/// A query manager to execute query against [UseSocialLogin].
class UseSocialLoginQuery {
  /// Fetches [ReadUseSocialLogin] documents.
  Future<List<ReadUseSocialLogin>> fetchDocuments({
    GetOptions? options,
    Query<ReadUseSocialLogin>? Function(Query<ReadUseSocialLogin> query)?
        queryBuilder,
    int Function(ReadUseSocialLogin lhs, ReadUseSocialLogin rhs)? compare,
  }) async {
    Query<ReadUseSocialLogin> query = readUseSocialLoginCollectionReference;
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

  /// Subscribes [UseSocialLogin] documents.
  Stream<List<ReadUseSocialLogin>> subscribeDocuments({
    Query<ReadUseSocialLogin>? Function(Query<ReadUseSocialLogin> query)?
        queryBuilder,
    int Function(ReadUseSocialLogin lhs, ReadUseSocialLogin rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadUseSocialLogin> query = readUseSocialLoginCollectionReference;
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

  /// Fetches a specified [ReadUseSocialLogin] document.
  Future<ReadUseSocialLogin?> fetchDocument({
    required String useSocialLoginId,
    GetOptions? options,
  }) async {
    final ds = await readUseSocialLoginDocumentReference(
      useSocialLoginId: useSocialLoginId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specified [UseSocialLogin] document.
  Stream<ReadUseSocialLogin?> subscribeDocument({
    required String useSocialLoginId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readUseSocialLoginDocumentReference(
      useSocialLoginId: useSocialLoginId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [UseSocialLogin] document.
  Future<DocumentReference<CreateUseSocialLogin>> add({
    required CreateUseSocialLogin createUseSocialLogin,
  }) =>
      createUseSocialLoginCollectionReference.add(createUseSocialLogin);

  /// Sets a [UseSocialLogin] document.
  Future<void> set({
    required String useSocialLoginId,
    required CreateUseSocialLogin createUseSocialLogin,
    SetOptions? options,
  }) =>
      createUseSocialLoginDocumentReference(
        useSocialLoginId: useSocialLoginId,
      ).set(createUseSocialLogin, options);

  /// Updates a specified [UseSocialLogin] document.
  Future<void> update({
    required String useSocialLoginId,
    required UpdateUseSocialLogin updateUseSocialLogin,
  }) =>
      updateUseSocialLoginDocumentReference(
        useSocialLoginId: useSocialLoginId,
      ).update(updateUseSocialLogin.toJson());

  /// Deletes a specified [UseSocialLogin] document.
  Future<void> delete({
    required String useSocialLoginId,
  }) =>
      deleteUseSocialLoginDocumentReference(
        useSocialLoginId: useSocialLoginId,
      ).delete();
}
