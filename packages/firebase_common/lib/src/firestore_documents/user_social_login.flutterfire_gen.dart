// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_social_login.dart';

class ReadUserSocialLogin {
  const ReadUserSocialLogin({
    required this.userSocialLoginId,
    required this.path,
    required this.isGoogleEnabled,
    required this.isLINEEnabled,
    required this.isAppleEnabled,
  });

  final String userSocialLoginId;

  final String path;

  final bool isGoogleEnabled;

  final bool isLINEEnabled;

  final bool isAppleEnabled;

  factory ReadUserSocialLogin._fromJson(Map<String, dynamic> json) {
    return ReadUserSocialLogin(
      userSocialLoginId: json['userSocialLoginId'] as String,
      path: json['path'] as String,
      isGoogleEnabled: json['isGoogleEnabled'] as bool? ?? false,
      isLINEEnabled: json['isLINEEnabled'] as bool? ?? false,
      isAppleEnabled: json['isAppleEnabled'] as bool? ?? false,
    );
  }

  factory ReadUserSocialLogin.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadUserSocialLogin._fromJson(<String, dynamic>{
      ...data,
      'userSocialLoginId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateUserSocialLogin {
  const CreateUserSocialLogin({
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

class UpdateUserSocialLogin {
  const UpdateUserSocialLogin({
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

/// A [CollectionReference] to userSocialLogins collection to read.
final readUserSocialLoginCollectionReference = FirebaseFirestore.instance
    .collection('userSocialLogins')
    .withConverter<ReadUserSocialLogin>(
      fromFirestore: (ds, _) => ReadUserSocialLogin.fromDocumentSnapshot(ds),
      toFirestore: (obj, _) => throw UnimplementedError(),
    );

/// A [DocumentReference] to userSocialLogin document to read.
DocumentReference<ReadUserSocialLogin> readUserSocialLoginDocumentReference({
  required String userSocialLoginId,
}) =>
    readUserSocialLoginCollectionReference.doc(userSocialLoginId);

/// A [CollectionReference] to userSocialLogins collection to create.
final createUserSocialLoginCollectionReference = FirebaseFirestore.instance
    .collection('userSocialLogins')
    .withConverter<CreateUserSocialLogin>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to userSocialLogin document to create.
DocumentReference<CreateUserSocialLogin>
    createUserSocialLoginDocumentReference({
  required String userSocialLoginId,
}) =>
        createUserSocialLoginCollectionReference.doc(userSocialLoginId);

/// A [CollectionReference] to userSocialLogins collection to update.
final updateUserSocialLoginCollectionReference = FirebaseFirestore.instance
    .collection('userSocialLogins')
    .withConverter<UpdateUserSocialLogin>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to userSocialLogin document to update.
DocumentReference<UpdateUserSocialLogin>
    updateUserSocialLoginDocumentReference({
  required String userSocialLoginId,
}) =>
        updateUserSocialLoginCollectionReference.doc(userSocialLoginId);

/// A [CollectionReference] to userSocialLogins collection to delete.
final deleteUserSocialLoginCollectionReference =
    FirebaseFirestore.instance.collection('userSocialLogins');

/// A [DocumentReference] to userSocialLogin document to delete.
DocumentReference<Object?> deleteUserSocialLoginDocumentReference({
  required String userSocialLoginId,
}) =>
    deleteUserSocialLoginCollectionReference.doc(userSocialLoginId);

/// A query manager to execute query against [UserSocialLogin].
class UserSocialLoginQuery {
  /// Fetches [ReadUserSocialLogin] documents.
  Future<List<ReadUserSocialLogin>> fetchDocuments({
    GetOptions? options,
    Query<ReadUserSocialLogin>? Function(Query<ReadUserSocialLogin> query)?
        queryBuilder,
    int Function(ReadUserSocialLogin lhs, ReadUserSocialLogin rhs)? compare,
  }) async {
    Query<ReadUserSocialLogin> query = readUserSocialLoginCollectionReference;
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

  /// Subscribes [UserSocialLogin] documents.
  Stream<List<ReadUserSocialLogin>> subscribeDocuments({
    Query<ReadUserSocialLogin>? Function(Query<ReadUserSocialLogin> query)?
        queryBuilder,
    int Function(ReadUserSocialLogin lhs, ReadUserSocialLogin rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadUserSocialLogin> query = readUserSocialLoginCollectionReference;
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

  /// Fetches a specified [ReadUserSocialLogin] document.
  Future<ReadUserSocialLogin?> fetchDocument({
    required String userSocialLoginId,
    GetOptions? options,
  }) async {
    final ds = await readUserSocialLoginDocumentReference(
      userSocialLoginId: userSocialLoginId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specified [UserSocialLogin] document.
  Stream<ReadUserSocialLogin?> subscribeDocument({
    required String userSocialLoginId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readUserSocialLoginDocumentReference(
      userSocialLoginId: userSocialLoginId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [UserSocialLogin] document.
  Future<DocumentReference<CreateUserSocialLogin>> add({
    required CreateUserSocialLogin createUserSocialLogin,
  }) =>
      createUserSocialLoginCollectionReference.add(createUserSocialLogin);

  /// Sets a [UserSocialLogin] document.
  Future<void> set({
    required String userSocialLoginId,
    required CreateUserSocialLogin createUserSocialLogin,
    SetOptions? options,
  }) =>
      createUserSocialLoginDocumentReference(
        userSocialLoginId: userSocialLoginId,
      ).set(createUserSocialLogin, options);

  /// Updates a specified [UserSocialLogin] document.
  Future<void> update({
    required String userSocialLoginId,
    required UpdateUserSocialLogin updateUserSocialLogin,
  }) =>
      updateUserSocialLoginDocumentReference(
        userSocialLoginId: userSocialLoginId,
      ).update(updateUserSocialLogin.toJson());

  /// Deletes a specified [UserSocialLogin] document.
  Future<void> delete({
    required String userSocialLoginId,
  }) =>
      deleteUserSocialLoginDocumentReference(
        userSocialLoginId: userSocialLoginId,
      ).delete();
}
