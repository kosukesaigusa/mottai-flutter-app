import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common.dart';

/// hostLocations コレクションへの参照。
final hostLocationsRef =
    FirebaseFirestore.instance.collection('hostLocations').withConverter(
          fromFirestore: (ds, _) => HostLocation.fromDocumentSnapshot(ds),
          toFirestore: (obj, _) => obj.toJson(),
        );
