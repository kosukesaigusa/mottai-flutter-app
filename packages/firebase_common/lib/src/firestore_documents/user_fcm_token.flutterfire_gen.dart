// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_fcm_token.dart';

class ReadUserFcmToken {
  const ReadUserFcmToken({
    required this.userFcmTokenId,
    required this.path,
    required this.userId,
    required this.token,
    required this.deviceInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  final String userFcmTokenId;

  final String path;

  final String userId;

  final String token;

  final String deviceInfo;

  final DateTime? createdAt;

  final DateTime? updatedAt;

  factory ReadUserFcmToken._fromJson(Map<String, dynamic> json) {
    return ReadUserFcmToken(
      userFcmTokenId: json['userFcmTokenId'] as String,
      path: json['path'] as String,
      userId: json['userId'] as String,
      token: json['token'] as String,
      deviceInfo: json['deviceInfo'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory ReadUserFcmToken.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadUserFcmToken._fromJson(<String, dynamic>{
      ...data,
      'userFcmTokenId': ds.id,
      'path': ds.reference.path,
    });
  }
}

class CreateUserFcmToken {
  const CreateUserFcmToken({
    required this.userId,
    required this.token,
    required this.deviceInfo,
  });

  final String userId;
  final String token;
  final String deviceInfo;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'token': token,
      'deviceInfo': deviceInfo,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class UpdateUserFcmToken {
  const UpdateUserFcmToken({
    this.userId,
    this.token,
    this.deviceInfo,
    this.createdAt,
  });

  final String? userId;
  final String? token;
  final String? deviceInfo;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      if (token != null) 'token': token,
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
      if (createdAt != null) 'createdAt': createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class DeleteUserFcmToken {}

/// Provides a reference to the userFcmTokens collection for reading.
final readUserFcmTokenCollectionReference = FirebaseFirestore.instance
    .collection('userFcmTokens')
    .withConverter<ReadUserFcmToken>(
      fromFirestore: (ds, _) => ReadUserFcmToken.fromDocumentSnapshot(ds),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a userFcmToken document for reading.
DocumentReference<ReadUserFcmToken> readUserFcmTokenDocumentReference({
  required String userFcmTokenId,
}) =>
    readUserFcmTokenCollectionReference.doc(userFcmTokenId);

/// Provides a reference to the userFcmTokens collection for creating.
final createUserFcmTokenCollectionReference = FirebaseFirestore.instance
    .collection('userFcmTokens')
    .withConverter<CreateUserFcmToken>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a userFcmToken document for creating.
DocumentReference<CreateUserFcmToken> createUserFcmTokenDocumentReference({
  required String userFcmTokenId,
}) =>
    createUserFcmTokenCollectionReference.doc(userFcmTokenId);

/// Provides a reference to the userFcmTokens collection for updating.
final updateUserFcmTokenCollectionReference = FirebaseFirestore.instance
    .collection('userFcmTokens')
    .withConverter<UpdateUserFcmToken>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// Provides a reference to a userFcmToken document for updating.
DocumentReference<UpdateUserFcmToken> updateUserFcmTokenDocumentReference({
  required String userFcmTokenId,
}) =>
    updateUserFcmTokenCollectionReference.doc(userFcmTokenId);

/// Provides a reference to the userFcmTokens collection for deleting.
final deleteUserFcmTokenCollectionReference = FirebaseFirestore.instance
    .collection('userFcmTokens')
    .withConverter<DeleteUserFcmToken>(
      fromFirestore: (_, __) => throw UnimplementedError(),
      toFirestore: (_, __) => throw UnimplementedError(),
    );

/// Provides a reference to a userFcmToken document for deleting.
DocumentReference<DeleteUserFcmToken> deleteUserFcmTokenDocumentReference({
  required String userFcmTokenId,
}) =>
    deleteUserFcmTokenCollectionReference.doc(userFcmTokenId);

/// Manages queries against the userFcmTokens collection.
class UserFcmTokenQuery {
  /// Fetches [ReadUserFcmToken] documents.
  Future<List<ReadUserFcmToken>> fetchDocuments({
    GetOptions? options,
    Query<ReadUserFcmToken>? Function(Query<ReadUserFcmToken> query)?
        queryBuilder,
    int Function(ReadUserFcmToken lhs, ReadUserFcmToken rhs)? compare,
  }) async {
    Query<ReadUserFcmToken> query = readUserFcmTokenCollectionReference;
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

  /// Subscribes [UserFcmToken] documents.
  Stream<List<ReadUserFcmToken>> subscribeDocuments({
    Query<ReadUserFcmToken>? Function(Query<ReadUserFcmToken> query)?
        queryBuilder,
    int Function(ReadUserFcmToken lhs, ReadUserFcmToken rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadUserFcmToken> query = readUserFcmTokenCollectionReference;
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

  /// Fetches a specific [ReadUserFcmToken] document.
  Future<ReadUserFcmToken?> fetchDocument({
    required String userFcmTokenId,
    GetOptions? options,
  }) async {
    final ds = await readUserFcmTokenDocumentReference(
      userFcmTokenId: userFcmTokenId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specific [UserFcmToken] document.
  Stream<ReadUserFcmToken?> subscribeDocument({
    required String userFcmTokenId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    var streamDs = readUserFcmTokenDocumentReference(
      userFcmTokenId: userFcmTokenId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Adds a [UserFcmToken] document.
  Future<DocumentReference<CreateUserFcmToken>> add({
    required CreateUserFcmToken createUserFcmToken,
  }) =>
      createUserFcmTokenCollectionReference.add(createUserFcmToken);

  /// Sets a [UserFcmToken] document.
  Future<void> set({
    required String userFcmTokenId,
    required CreateUserFcmToken createUserFcmToken,
    SetOptions? options,
  }) =>
      createUserFcmTokenDocumentReference(
        userFcmTokenId: userFcmTokenId,
      ).set(createUserFcmToken, options);

  /// Updates a specific [UserFcmToken] document.
  Future<void> update({
    required String userFcmTokenId,
    required UpdateUserFcmToken updateUserFcmToken,
  }) =>
      updateUserFcmTokenDocumentReference(
        userFcmTokenId: userFcmTokenId,
      ).update(updateUserFcmToken.toJson());

  /// Deletes a specific [UserFcmToken] document.
  Future<void> delete({
    required String userFcmTokenId,
  }) =>
      deleteUserFcmTokenDocumentReference(
        userFcmTokenId: userFcmTokenId,
      ).delete();
}
