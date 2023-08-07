// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i20;
import 'package:flutter/material.dart' as _i21;
import 'package:mottai_flutter_app/chat/ui/chat_room.dart' as _i1;
import 'package:mottai_flutter_app/chat/ui/chat_rooms.dart' as _i2;
import 'package:mottai_flutter_app/development/color/ui/color.dart' as _i3;
import 'package:mottai_flutter_app/development/development_items/ui/development_items.dart'
    as _i5;
import 'package:mottai_flutter_app/development/firebase_storage/ui/firebase_storage.dart'
    as _i6;
import 'package:mottai_flutter_app/development/force_update/ui/force_update.dart'
    as _i7;
import 'package:mottai_flutter_app/development/generic_image/ui/generic_images.dart'
    as _i8;
import 'package:mottai_flutter_app/development/image_detail_view/ui/image_detail_view_stub.dart'
    as _i10;
import 'package:mottai_flutter_app/development/image_picker/ui/image_picker_sample.dart'
    as _i11;
import 'package:mottai_flutter_app/development/in_review/ui/in_review.dart'
    as _i12;
import 'package:mottai_flutter_app/development/sample_todo/ui/sample_todos.dart'
    as _i16;
import 'package:mottai_flutter_app/development/sign_in/ui/sign_in.dart' as _i17;
import 'package:mottai_flutter_app/development/web_link/ui/web_link_stub.dart'
    as _i18;
import 'package:mottai_flutter_app/host/ui/create_or_update_host.dart' as _i4;
import 'package:mottai_flutter_app/host/ui/host.dart' as _i9;
import 'package:mottai_flutter_app/job/ui/job_detail.dart' as _i13;
import 'package:mottai_flutter_app/map/ui/map.dart' as _i14;
import 'package:mottai_flutter_app/root/ui/root.dart' as _i15;
import 'package:mottai_flutter_app/worker/ui/worker.dart' as _i19;

abstract class $AppRouter extends _i20.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i20.PageFactory> pagesMap = {
    ChatRoomRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ChatRoomRouteArgs>(
          orElse: () => ChatRoomRouteArgs(
              chatRoomId: pathParams.getString('chatRoomId')));
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.ChatRoomPage(
          chatRoomId: args.chatRoomId,
          key: args.key,
        ),
      );
    },
    ChatRoomsRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ChatRoomsPage(),
      );
    },
    ColorRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ColorPage(),
      );
    },
    CreateOrUpdateHostRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CreateOrUpdateHostRouteArgs>(
          orElse: () => CreateOrUpdateHostRouteArgs(
              userId: pathParams.getString('userId')));
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.CreateOrUpdateHostPage(
          userId: args.userId,
          key: args.key,
        ),
      );
    },
    DevelopmentItemsRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.DevelopmentItemsPage(),
      );
    },
    FirebaseStorageSampleRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.FirebaseStorageSamplePage(),
      );
    },
    ForceUpdateSampleRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.ForceUpdateSamplePage(),
      );
    },
    GenericImagesRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.GenericImagesPage(),
      );
    },
    HostRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HostRouteArgs>(
          orElse: () => HostRouteArgs(userId: pathParams.getString('userId')));
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.HostPage(
          userId: args.userId,
          key: args.key,
        ),
      );
    },
    ImageDetailViewStubRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.ImageDetailViewStubPage(),
      );
    },
    ImagePickerSampleRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.ImagePickerSamplePage(),
      );
    },
    InReviewRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.InReviewPage(),
      );
    },
    JobDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<JobDetailRouteArgs>(
          orElse: () =>
              JobDetailRouteArgs(jobId: pathParams.getString('jobId')));
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.JobDetailPage(
          jobId: args.jobId,
          key: args.key,
        ),
      );
    },
    MapRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.MapPage(),
      );
    },
    RootRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.RootPage(),
      );
    },
    SampleTodosRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.SampleTodosPage(),
      );
    },
    SignInSampleRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.SignInSamplePage(),
      );
    },
    WebLinkStubRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i18.WebLinkStubPage(),
      );
    },
    WorkerRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkerRouteArgs>(
          orElse: () =>
              WorkerRouteArgs(userId: pathParams.getString('userId')));
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i19.WorkerPage(
          userId: args.userId,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.ChatRoomPage]
class ChatRoomRoute extends _i20.PageRouteInfo<ChatRoomRouteArgs> {
  ChatRoomRoute({
    required String chatRoomId,
    _i21.Key? key,
    List<_i20.PageRouteInfo>? children,
  }) : super(
          ChatRoomRoute.name,
          args: ChatRoomRouteArgs(
            chatRoomId: chatRoomId,
            key: key,
          ),
          rawPathParams: {'chatRoomId': chatRoomId},
          initialChildren: children,
        );

  static const String name = 'ChatRoomRoute';

  static const _i20.PageInfo<ChatRoomRouteArgs> page =
      _i20.PageInfo<ChatRoomRouteArgs>(name);
}

class ChatRoomRouteArgs {
  const ChatRoomRouteArgs({
    required this.chatRoomId,
    this.key,
  });

  final String chatRoomId;

  final _i21.Key? key;

  @override
  String toString() {
    return 'ChatRoomRouteArgs{chatRoomId: $chatRoomId, key: $key}';
  }
}

/// generated route for
/// [_i2.ChatRoomsPage]
class ChatRoomsRoute extends _i20.PageRouteInfo<void> {
  const ChatRoomsRoute({List<_i20.PageRouteInfo>? children})
      : super(
          ChatRoomsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatRoomsRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ColorPage]
class ColorRoute extends _i20.PageRouteInfo<void> {
  const ColorRoute({List<_i20.PageRouteInfo>? children})
      : super(
          ColorRoute.name,
          initialChildren: children,
        );

  static const String name = 'ColorRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i4.CreateOrUpdateHostPage]
class CreateOrUpdateHostRoute
    extends _i20.PageRouteInfo<CreateOrUpdateHostRouteArgs> {
  CreateOrUpdateHostRoute({
    required String userId,
    _i21.Key? key,
    List<_i20.PageRouteInfo>? children,
  }) : super(
          CreateOrUpdateHostRoute.name,
          args: CreateOrUpdateHostRouteArgs(
            userId: userId,
            key: key,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'CreateOrUpdateHostRoute';

  static const _i20.PageInfo<CreateOrUpdateHostRouteArgs> page =
      _i20.PageInfo<CreateOrUpdateHostRouteArgs>(name);
}

class CreateOrUpdateHostRouteArgs {
  const CreateOrUpdateHostRouteArgs({
    required this.userId,
    this.key,
  });

  final String userId;

  final _i21.Key? key;

  @override
  String toString() {
    return 'CreateOrUpdateHostRouteArgs{userId: $userId, key: $key}';
  }
}

/// generated route for
/// [_i5.DevelopmentItemsPage]
class DevelopmentItemsRoute extends _i20.PageRouteInfo<void> {
  const DevelopmentItemsRoute({List<_i20.PageRouteInfo>? children})
      : super(
          DevelopmentItemsRoute.name,
          initialChildren: children,
        );

  static const String name = 'DevelopmentItemsRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i6.FirebaseStorageSamplePage]
class FirebaseStorageSampleRoute extends _i20.PageRouteInfo<void> {
  const FirebaseStorageSampleRoute({List<_i20.PageRouteInfo>? children})
      : super(
          FirebaseStorageSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'FirebaseStorageSampleRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i7.ForceUpdateSamplePage]
class ForceUpdateSampleRoute extends _i20.PageRouteInfo<void> {
  const ForceUpdateSampleRoute({List<_i20.PageRouteInfo>? children})
      : super(
          ForceUpdateSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForceUpdateSampleRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i8.GenericImagesPage]
class GenericImagesRoute extends _i20.PageRouteInfo<void> {
  const GenericImagesRoute({List<_i20.PageRouteInfo>? children})
      : super(
          GenericImagesRoute.name,
          initialChildren: children,
        );

  static const String name = 'GenericImagesRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i9.HostPage]
class HostRoute extends _i20.PageRouteInfo<HostRouteArgs> {
  HostRoute({
    required String userId,
    _i21.Key? key,
    List<_i20.PageRouteInfo>? children,
  }) : super(
          HostRoute.name,
          args: HostRouteArgs(
            userId: userId,
            key: key,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'HostRoute';

  static const _i20.PageInfo<HostRouteArgs> page =
      _i20.PageInfo<HostRouteArgs>(name);
}

class HostRouteArgs {
  const HostRouteArgs({
    required this.userId,
    this.key,
  });

  final String userId;

  final _i21.Key? key;

  @override
  String toString() {
    return 'HostRouteArgs{userId: $userId, key: $key}';
  }
}

/// generated route for
/// [_i10.ImageDetailViewStubPage]
class ImageDetailViewStubRoute extends _i20.PageRouteInfo<void> {
  const ImageDetailViewStubRoute({List<_i20.PageRouteInfo>? children})
      : super(
          ImageDetailViewStubRoute.name,
          initialChildren: children,
        );

  static const String name = 'ImageDetailViewStubRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i11.ImagePickerSamplePage]
class ImagePickerSampleRoute extends _i20.PageRouteInfo<void> {
  const ImagePickerSampleRoute({List<_i20.PageRouteInfo>? children})
      : super(
          ImagePickerSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ImagePickerSampleRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i12.InReviewPage]
class InReviewRoute extends _i20.PageRouteInfo<void> {
  const InReviewRoute({List<_i20.PageRouteInfo>? children})
      : super(
          InReviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'InReviewRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i13.JobDetailPage]
class JobDetailRoute extends _i20.PageRouteInfo<JobDetailRouteArgs> {
  JobDetailRoute({
    required String jobId,
    _i21.Key? key,
    List<_i20.PageRouteInfo>? children,
  }) : super(
          JobDetailRoute.name,
          args: JobDetailRouteArgs(
            jobId: jobId,
            key: key,
          ),
          rawPathParams: {'jobId': jobId},
          initialChildren: children,
        );

  static const String name = 'JobDetailRoute';

  static const _i20.PageInfo<JobDetailRouteArgs> page =
      _i20.PageInfo<JobDetailRouteArgs>(name);
}

class JobDetailRouteArgs {
  const JobDetailRouteArgs({
    required this.jobId,
    this.key,
  });

  final String jobId;

  final _i21.Key? key;

  @override
  String toString() {
    return 'JobDetailRouteArgs{jobId: $jobId, key: $key}';
  }
}

/// generated route for
/// [_i14.MapPage]
class MapRoute extends _i20.PageRouteInfo<void> {
  const MapRoute({List<_i20.PageRouteInfo>? children})
      : super(
          MapRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i15.RootPage]
class RootRoute extends _i20.PageRouteInfo<void> {
  const RootRoute({List<_i20.PageRouteInfo>? children})
      : super(
          RootRoute.name,
          initialChildren: children,
        );

  static const String name = 'RootRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i16.SampleTodosPage]
class SampleTodosRoute extends _i20.PageRouteInfo<void> {
  const SampleTodosRoute({List<_i20.PageRouteInfo>? children})
      : super(
          SampleTodosRoute.name,
          initialChildren: children,
        );

  static const String name = 'SampleTodosRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i17.SignInSamplePage]
class SignInSampleRoute extends _i20.PageRouteInfo<void> {
  const SignInSampleRoute({List<_i20.PageRouteInfo>? children})
      : super(
          SignInSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInSampleRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i18.WebLinkStubPage]
class WebLinkStubRoute extends _i20.PageRouteInfo<void> {
  const WebLinkStubRoute({List<_i20.PageRouteInfo>? children})
      : super(
          WebLinkStubRoute.name,
          initialChildren: children,
        );

  static const String name = 'WebLinkStubRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i19.WorkerPage]
class WorkerRoute extends _i20.PageRouteInfo<WorkerRouteArgs> {
  WorkerRoute({
    required String userId,
    _i21.Key? key,
    List<_i20.PageRouteInfo>? children,
  }) : super(
          WorkerRoute.name,
          args: WorkerRouteArgs(
            userId: userId,
            key: key,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'WorkerRoute';

  static const _i20.PageInfo<WorkerRouteArgs> page =
      _i20.PageInfo<WorkerRouteArgs>(name);
}

class WorkerRouteArgs {
  const WorkerRouteArgs({
    required this.userId,
    this.key,
  });

  final String userId;

  final _i21.Key? key;

  @override
  String toString() {
    return 'WorkerRouteArgs{userId: $userId, key: $key}';
  }
}
