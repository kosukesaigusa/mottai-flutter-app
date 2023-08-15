// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_social_login.dart';

class ReadUserSocialLogin {
  const ReadUserSocialLogin({
    required this.userSocialLoginId,
    required this.path,
    required this.isGoogleEnabled,
    required this.isAppleEnabled,
    required this.isLINEEnabled,
  });

  final String userSocialLoginId;

  final String path;

  final bool isGoogleEnabled;

  final bool isAppleEnabled;

  final bool isLINEEnabled;

  factory ReadUserSocialLogin._fromJson(Map<String, dynamic> json) {
    return ReadUserSocialLogin(
      userSocialLoginId: json['userSocialLoginId'] as String,
      path: json['path'] as String,
      isGoogleEnabled: json['isGoogleEnabled'] as bool? ?? false,
      isAppleEnabled: json['isAppleEnabled'] as bool? ?? false,
      isLINEEnabled: json['isLINEEnabled'] as bool? ?? false,
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
    this.isAppleEnabled = false,
    this.isLINEEnabled = false,
  });

  final bool isGoogleEnabled;
  final bool isAppleEnabled;
  final bool isLINEEnabled;

  Map<String, dynamic> toJson() {
    return {
      'isGoogleEnabled': isGoogleEnabled,
      'isAppleEnabled': isAppleEnabled,
      'isLINEEnabled': isLINEEnabled,
    };
  }
}

class UpdateUserSocialLogin {
  const UpdateUserSocialLogin({
    this.isGoogleEnabled,
    this.isAppleEnabled,
    this.isLINEEnabled,
  });

  final bool? isGoogleEnabled;
  final bool? isAppleEnabled;
  final bool? isLINEEnabled;

  Map<String, dynamic> toJson() {
    return {
      if (isGoogleEnabled != null) 'isGoogleEnabled': isGoogleEnabled,
      if (isAppleEnabled != null) 'isAppleEnabled': isAppleEnabled,
      if (isLINEEnabled != null) 'isLINEEnabled': isLINEEnabled,
    };
  }
}

class DeleteUserSocialLogin {}

/// Provides a reference to the userSocialLogins collection for reading.
final readUserSocialLoginCollectionReference = FirebaseFirestore.instance
    .collection('userSocialLogins')
    .withConverter<ReadUserSocialLogin>(
      fromFirestore: (ds, _) => ReadUserSocialLogin.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a userSocialLogin document for reading.
DocumentReference<ReadUserSocialLogin> readUserSocialLoginDocumentReference({
  required String userSocialLoginId,
}) =>
    readUserSocialLoginCollectionReference.doc(userSocialLoginId);

/// Provides a reference to the userSocialLogins collection for creating.
final createUserSocialLoginCollectionReference = FirebaseFirestore.instance
    .collection('userSocialLogins')
    .withConverter<CreateUserSocialLogin>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a userSocialLogin document for creating.
DocumentReference<CreateUserSocialLogin>
    createUserSocialLoginDocumentReference({
  required String userSocialLoginId,
}) =>
        createUserSocialLoginCollectionReference.doc(userSocialLoginId);

/// Provides a reference to the userSocialLogins collection for updating.
final updateUserSocialLoginCollectionReference = FirebaseFirestore.instance
    .collection('userSocialLogins')
    .withConverter<UpdateUserSocialLogin>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a userSocialLogin document for updating.
DocumentReference<UpdateUserSocialLogin>
    updateUserSocialLoginDocumentReference({
  required String userSocialLoginId,
}) =>
        updateUserSocialLoginCollectionReference.doc(userSocialLoginId);

/// Provides a reference to the userSocialLogins collection for deleting.
final deleteUserSocialLoginCollectionReference = FirebaseFirestore.instance
    .collection('userSocialLogins')
    .withConverter<DeleteUserSocialLogin>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a userSocialLogin document for deleting.
DocumentReference<DeleteUserSocialLogin>
    deleteUserSocialLoginDocumentReference({
  required String userSocialLoginId,
}) =>
        deleteUserSocialLoginCollectionReference.doc(userSocialLoginId);

/// Manages queries against the userSocialLogins collection.
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

  /// Fetches a specific [ReadUserSocialLogin] document.
  Future<ReadUserSocialLogin?> fetchDocument({
    required String userSocialLoginId,
    GetOptions? options,
  }) async {
    final ds = await readUserSocialLoginDocumentReference(
      userSocialLoginId: userSocialLoginId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [UserSocialLogin] document.
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

  /// Updates a specific [UserSocialLogin] document.
  Future<void> update({
    required String userSocialLoginId,
    required UpdateUserSocialLogin updateUserSocialLogin,
  }) =>
      updateUserSocialLoginDocumentReference(
        userSocialLoginId: userSocialLoginId,
      ).update(updateUserSocialLogin.toJson());

  /// Deletes a specific [UserSocialLogin] document.
  Future<void> delete({
    required String userSocialLoginId,
  }) =>
      deleteUserSocialLoginDocumentReference(
        userSocialLoginId: userSocialLoginId,
      ).delete();
}
