// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fcm_token.dart';

class ReadFcmToken {
  const ReadFcmToken._({
    required this.fcmTokenId,
    required this.fcmTokenReference,
    required this.tokenAndDevices,
  });

  final String fcmTokenId;
  final DocumentReference<ReadFcmToken> fcmTokenReference;
  final List<TokenAndDevice> tokenAndDevices;

  factory ReadFcmToken._fromJson(Map<String, dynamic> json) {
    return ReadFcmToken._(
      fcmTokenId: json['fcmTokenId'] as String,
      fcmTokenReference:
          json['fcmTokenReference'] as DocumentReference<ReadFcmToken>,
      tokenAndDevices: _tokenAndDevicesConverter
          .fromJson(json['tokenAndDevices'] as List<dynamic>?),
    );
  }

  factory ReadFcmToken.fromDocumentSnapshot(DocumentSnapshot ds) {
    final data = ds.data()! as Map<String, dynamic>;
    return ReadFcmToken._fromJson(<String, dynamic>{
      ...data,
      'fcmTokenId': ds.id,
      'fcmTokenReference': ds.reference.parent.doc(ds.id).withConverter(
            fromFirestore: (ds, _) => ReadFcmToken.fromDocumentSnapshot(ds),
            toFirestore: (obj, _) => throw UnimplementedError(),
          ),
    });
  }

  ReadFcmToken copyWith({
    String? fcmTokenId,
    DocumentReference<ReadFcmToken>? fcmTokenReference,
    List<TokenAndDevice>? tokenAndDevices,
  }) {
    return ReadFcmToken._(
      fcmTokenId: fcmTokenId ?? this.fcmTokenId,
      fcmTokenReference: fcmTokenReference ?? this.fcmTokenReference,
      tokenAndDevices: tokenAndDevices ?? this.tokenAndDevices,
    );
  }
}

class CreateFcmToken {
  const CreateFcmToken({
    required this.tokenAndDevices,
  });

  final List<TokenAndDevice> tokenAndDevices;

  Map<String, dynamic> toJson() {
    return {
      'tokenAndDevices': _tokenAndDevicesConverter.toJson(tokenAndDevices),
    };
  }
}

class UpdateFcmToken {
  const UpdateFcmToken({
    this.tokenAndDevices,
  });

  final List<TokenAndDevice>? tokenAndDevices;

  Map<String, dynamic> toJson() {
    return {
      if (tokenAndDevices != null)
        'tokenAndDevices': _tokenAndDevicesConverter.toJson(tokenAndDevices!),
    };
  }
}

/// A [CollectionReference] to fcmTokens collection to read.
final readFcmTokenCollectionReference = FirebaseFirestore.instance
    .collection('fcmTokens')
    .withConverter<ReadFcmToken>(
      fromFirestore: (ds, _) => ReadFcmToken.fromDocumentSnapshot(ds),
      toFirestore: (obj, _) => throw UnimplementedError(),
    );

/// A [DocumentReference] to fcmToken document to read.
DocumentReference<ReadFcmToken> readFcmTokenDocumentReference({
  required String fcmTokenId,
}) =>
    readFcmTokenCollectionReference.doc(fcmTokenId);

/// A [CollectionReference] to fcmTokens collection to create.
final createFcmTokenCollectionReference = FirebaseFirestore.instance
    .collection('fcmTokens')
    .withConverter<CreateFcmToken>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to fcmToken document to create.
DocumentReference<CreateFcmToken> createFcmTokenDocumentReference({
  required String fcmTokenId,
}) =>
    createFcmTokenCollectionReference.doc(fcmTokenId);

/// A [CollectionReference] to fcmTokens collection to update.
final updateFcmTokenCollectionReference = FirebaseFirestore.instance
    .collection('fcmTokens')
    .withConverter<UpdateFcmToken>(
      fromFirestore: (ds, _) => throw UnimplementedError(),
      toFirestore: (obj, _) => obj.toJson(),
    );

/// A [DocumentReference] to fcmToken document to update.
DocumentReference<UpdateFcmToken> updateFcmTokenDocumentReference({
  required String fcmTokenId,
}) =>
    updateFcmTokenCollectionReference.doc(fcmTokenId);

/// A query manager to execute query against [FcmToken].
class FcmTokenQuery {
  /// Fetches [ReadFcmToken] documents.
  Future<List<ReadFcmToken>> fetchDocuments({
    GetOptions? options,
    Query<ReadFcmToken>? Function(Query<ReadFcmToken> query)? queryBuilder,
    int Function(ReadFcmToken lhs, ReadFcmToken rhs)? compare,
  }) async {
    Query<ReadFcmToken> query = readFcmTokenCollectionReference;
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

  /// Subscribes [FcmToken] documents.
  Stream<List<ReadFcmToken>> subscribeDocuments({
    Query<ReadFcmToken>? Function(Query<ReadFcmToken> query)? queryBuilder,
    int Function(ReadFcmToken lhs, ReadFcmToken rhs)? compare,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) {
    Query<ReadFcmToken> query = readFcmTokenCollectionReference;
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

  /// Fetches a specified [ReadFcmToken] document.
  Future<ReadFcmToken?> fetchDocument({
    required String fcmTokenId,
    GetOptions? options,
  }) async {
    final ds = await readFcmTokenDocumentReference(
      fcmTokenId: fcmTokenId,
    ).get(options);
    return ds.data();
  }

  /// Subscribes a specified [FcmToken] document.
  Future<Stream<ReadFcmToken?>> subscribeDocument({
    required String fcmTokenId,
    bool includeMetadataChanges = false,
    bool excludePendingWrites = false,
  }) async {
    var streamDs = readFcmTokenDocumentReference(
      fcmTokenId: fcmTokenId,
    ).snapshots(includeMetadataChanges: includeMetadataChanges);
    if (excludePendingWrites) {
      streamDs = streamDs.where((ds) => !ds.metadata.hasPendingWrites);
    }
    return streamDs.map((ds) => ds.data());
  }

  /// Creates a [FcmToken] document.
  Future<DocumentReference<CreateFcmToken>> create({
    required CreateFcmToken createFcmToken,
  }) =>
      createFcmTokenCollectionReference.add(createFcmToken);

  /// Sets a [FcmToken] document.
  Future<void> set({
    required String fcmTokenId,
    required CreateFcmToken createFcmToken,
    SetOptions? options,
  }) =>
      createFcmTokenDocumentReference(
        fcmTokenId: fcmTokenId,
      ).set(createFcmToken, options);

  /// Updates a specified [FcmToken] document.
  Future<void> update({
    required String fcmTokenId,
    required UpdateFcmToken updateFcmToken,
  }) =>
      updateFcmTokenDocumentReference(
        fcmTokenId: fcmTokenId,
      ).update(updateFcmToken.toJson());
}
