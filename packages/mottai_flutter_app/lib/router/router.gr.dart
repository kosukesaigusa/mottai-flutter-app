// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i25;
import 'package:flutter/material.dart' as _i26;
import 'package:mottai_flutter_app/chat/ui/chat_room.dart' as _i1;
import 'package:mottai_flutter_app/chat/ui/chat_rooms.dart' as _i2;
import 'package:mottai_flutter_app/development/color/ui/color.dart' as _i3;
import 'package:mottai_flutter_app/development/development_items/ui/development_items.dart'
    as _i6;
import 'package:mottai_flutter_app/development/email_and_password_sign_in/ui/email_and_password_sign_in.dart'
    as _i7;
import 'package:mottai_flutter_app/development/firebase_storage/ui/firebase_storage.dart'
    as _i8;
import 'package:mottai_flutter_app/development/force_update/ui/force_update.dart'
    as _i9;
import 'package:mottai_flutter_app/development/generic_image/ui/generic_images.dart'
    as _i10;
import 'package:mottai_flutter_app/development/image_detail_view/ui/image_detail_view_stub.dart'
    as _i12;
import 'package:mottai_flutter_app/development/image_picker/ui/image_picker_sample.dart'
    as _i13;
import 'package:mottai_flutter_app/development/in_review/ui/in_review.dart'
    as _i14;
import 'package:mottai_flutter_app/development/sample_todo/ui/sample_todos.dart'
    as _i20;
import 'package:mottai_flutter_app/development/sign_in/ui/sign_in.dart' as _i21;
import 'package:mottai_flutter_app/development/user_social_login/user_social_login.dart'
    as _i22;
import 'package:mottai_flutter_app/development/web_link/ui/web_link_stub.dart'
    as _i23;
import 'package:mottai_flutter_app/host/ui/create_or_update_host.dart' as _i4;
import 'package:mottai_flutter_app/host/ui/host.dart' as _i11;
import 'package:mottai_flutter_app/job/ui/job_detail.dart' as _i15;
import 'package:mottai_flutter_app/map/ui/map.dart' as _i16;
import 'package:mottai_flutter_app/my_account/ui/my_account.dart' as _i17;
import 'package:mottai_flutter_app/review/ui/reviews.dart' as _i18;
import 'package:mottai_flutter_app/root/ui/root.dart' as _i19;
import 'package:mottai_flutter_app/worker/ui/create_or_update_worker.dart'
    as _i5;
import 'package:mottai_flutter_app/worker/ui/worker.dart' as _i24;

abstract class $AppRouter extends _i25.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i25.PageFactory> pagesMap = {
    ChatRoomRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ChatRoomRouteArgs>(
          orElse: () => ChatRoomRouteArgs(
              chatRoomId: pathParams.getString('chatRoomId')));
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.ChatRoomPage(
          chatRoomId: args.chatRoomId,
          key: args.key,
        ),
      );
    },
    ChatRoomsRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ChatRoomsPage(),
      );
    },
    ColorRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ColorPage(),
      );
    },
    CreateOrUpdateHostRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CreateOrUpdateHostRouteArgs>(
          orElse: () => CreateOrUpdateHostRouteArgs(
                userId: pathParams.getString('userId'),
                actionType: pathParams.getString('actionType'),
              ));
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.CreateOrUpdateHostPage(
          userId: args.userId,
          actionType: args.actionType,
          key: args.key,
        ),
      );
    },
    CreateOrUpdateWorkerRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CreateOrUpdateWorkerRouteArgs>(
          orElse: () => CreateOrUpdateWorkerRouteArgs(
              userId: pathParams.getString('userId')));
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.CreateOrUpdateWorkerPage(
          userId: args.userId,
          key: args.key,
        ),
      );
    },
    DevelopmentItemsRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.DevelopmentItemsPage(),
      );
    },
    EmailAndPasswordSignInRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.EmailAndPasswordSignInPage(),
      );
    },
    FirebaseStorageSampleRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.FirebaseStorageSamplePage(),
      );
    },
    ForceUpdateSampleRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.ForceUpdateSamplePage(),
      );
    },
    GenericImagesRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.GenericImagesPage(),
      );
    },
    HostRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HostRouteArgs>(
          orElse: () => HostRouteArgs(userId: pathParams.getString('userId')));
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i11.HostPage(
          userId: args.userId,
          key: args.key,
        ),
      );
    },
    ImageDetailViewStubRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.ImageDetailViewStubPage(),
      );
    },
    ImagePickerSampleRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.ImagePickerSamplePage(),
      );
    },
    InReviewRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.InReviewPage(),
      );
    },
    JobDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<JobDetailRouteArgs>(
          orElse: () =>
              JobDetailRouteArgs(jobId: pathParams.getString('jobId')));
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.JobDetailPage(
          jobId: args.jobId,
          key: args.key,
        ),
      );
    },
    MapRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.MapPage(),
      );
    },
    MyAccountRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.MyAccountPage(),
      );
    },
    ReviewsRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i18.ReviewsPage(),
      );
    },
    RootRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.RootPage(),
      );
    },
    SampleTodosRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i20.SampleTodosPage(),
      );
    },
    SignInSampleRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i21.SignInSamplePage(),
      );
    },
    UserSocialLoginSampleRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i22.UserSocialLoginSamplePage(),
      );
    },
    WebLinkStubRoute.name: (routeData) {
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i23.WebLinkStubPage(),
      );
    },
    WorkerRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkerRouteArgs>(
          orElse: () =>
              WorkerRouteArgs(userId: pathParams.getString('userId')));
      return _i25.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i24.WorkerPage(
          userId: args.userId,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.ChatRoomPage]
class ChatRoomRoute extends _i25.PageRouteInfo<ChatRoomRouteArgs> {
  ChatRoomRoute({
    required String chatRoomId,
    _i26.Key? key,
    List<_i25.PageRouteInfo>? children,
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

  static const _i25.PageInfo<ChatRoomRouteArgs> page =
      _i25.PageInfo<ChatRoomRouteArgs>(name);
}

class ChatRoomRouteArgs {
  const ChatRoomRouteArgs({
    required this.chatRoomId,
    this.key,
  });

  final String chatRoomId;

  final _i26.Key? key;

  @override
  String toString() {
    return 'ChatRoomRouteArgs{chatRoomId: $chatRoomId, key: $key}';
  }
}

/// generated route for
/// [_i2.ChatRoomsPage]
class ChatRoomsRoute extends _i25.PageRouteInfo<void> {
  const ChatRoomsRoute({List<_i25.PageRouteInfo>? children})
      : super(
          ChatRoomsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatRoomsRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ColorPage]
class ColorRoute extends _i25.PageRouteInfo<void> {
  const ColorRoute({List<_i25.PageRouteInfo>? children})
      : super(
          ColorRoute.name,
          initialChildren: children,
        );

  static const String name = 'ColorRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i4.CreateOrUpdateHostPage]
class CreateOrUpdateHostRoute
    extends _i25.PageRouteInfo<CreateOrUpdateHostRouteArgs> {
  CreateOrUpdateHostRoute({
    required String userId,
    required String actionType,
    _i26.Key? key,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          CreateOrUpdateHostRoute.name,
          args: CreateOrUpdateHostRouteArgs(
            userId: userId,
            actionType: actionType,
            key: key,
          ),
          rawPathParams: {
            'userId': userId,
            'actionType': actionType,
          },
          initialChildren: children,
        );

  static const String name = 'CreateOrUpdateHostRoute';

  static const _i25.PageInfo<CreateOrUpdateHostRouteArgs> page =
      _i25.PageInfo<CreateOrUpdateHostRouteArgs>(name);
}

class CreateOrUpdateHostRouteArgs {
  const CreateOrUpdateHostRouteArgs({
    required this.userId,
    required this.actionType,
    this.key,
  });

  final String userId;

  final String actionType;

  final _i26.Key? key;

  @override
  String toString() {
    return 'CreateOrUpdateHostRouteArgs{userId: $userId, actionType: $actionType, key: $key}';
  }
}

/// generated route for
/// [_i5.CreateOrUpdateWorkerPage]
class CreateOrUpdateWorkerRoute
    extends _i25.PageRouteInfo<CreateOrUpdateWorkerRouteArgs> {
  CreateOrUpdateWorkerRoute({
    required String userId,
    _i26.Key? key,
    List<_i25.PageRouteInfo>? children,
  }) : super(
          CreateOrUpdateWorkerRoute.name,
          args: CreateOrUpdateWorkerRouteArgs(
            userId: userId,
            key: key,
          ),
          rawPathParams: {'userId': userId},
          initialChildren: children,
        );

  static const String name = 'CreateOrUpdateWorkerRoute';

  static const _i25.PageInfo<CreateOrUpdateWorkerRouteArgs> page =
      _i25.PageInfo<CreateOrUpdateWorkerRouteArgs>(name);
}

class CreateOrUpdateWorkerRouteArgs {
  const CreateOrUpdateWorkerRouteArgs({
    required this.userId,
    this.key,
  });

  final String userId;

  final _i26.Key? key;

  @override
  String toString() {
    return 'CreateOrUpdateWorkerRouteArgs{userId: $userId, key: $key}';
  }
}

/// generated route for
/// [_i6.DevelopmentItemsPage]
class DevelopmentItemsRoute extends _i25.PageRouteInfo<void> {
  const DevelopmentItemsRoute({List<_i25.PageRouteInfo>? children})
      : super(
          DevelopmentItemsRoute.name,
          initialChildren: children,
        );

  static const String name = 'DevelopmentItemsRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i7.EmailAndPasswordSignInPage]
class EmailAndPasswordSignInRoute extends _i25.PageRouteInfo<void> {
  const EmailAndPasswordSignInRoute({List<_i25.PageRouteInfo>? children})
      : super(
          EmailAndPasswordSignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'EmailAndPasswordSignInRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i8.FirebaseStorageSamplePage]
class FirebaseStorageSampleRoute extends _i25.PageRouteInfo<void> {
  const FirebaseStorageSampleRoute({List<_i25.PageRouteInfo>? children})
      : super(
          FirebaseStorageSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'FirebaseStorageSampleRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i9.ForceUpdateSamplePage]
class ForceUpdateSampleRoute extends _i25.PageRouteInfo<void> {
  const ForceUpdateSampleRoute({List<_i25.PageRouteInfo>? children})
      : super(
          ForceUpdateSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForceUpdateSampleRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i10.GenericImagesPage]
class GenericImagesRoute extends _i25.PageRouteInfo<void> {
  const GenericImagesRoute({List<_i25.PageRouteInfo>? children})
      : super(
          GenericImagesRoute.name,
          initialChildren: children,
        );

  static const String name = 'GenericImagesRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i11.HostPage]
class HostRoute extends _i25.PageRouteInfo<HostRouteArgs> {
  HostRoute({
    required String userId,
    _i26.Key? key,
    List<_i25.PageRouteInfo>? children,
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

  static const _i25.PageInfo<HostRouteArgs> page =
      _i25.PageInfo<HostRouteArgs>(name);
}

class HostRouteArgs {
  const HostRouteArgs({
    required this.userId,
    this.key,
  });

  final String userId;

  final _i26.Key? key;

  @override
  String toString() {
    return 'HostRouteArgs{userId: $userId, key: $key}';
  }
}

/// generated route for
/// [_i12.ImageDetailViewStubPage]
class ImageDetailViewStubRoute extends _i25.PageRouteInfo<void> {
  const ImageDetailViewStubRoute({List<_i25.PageRouteInfo>? children})
      : super(
          ImageDetailViewStubRoute.name,
          initialChildren: children,
        );

  static const String name = 'ImageDetailViewStubRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i13.ImagePickerSamplePage]
class ImagePickerSampleRoute extends _i25.PageRouteInfo<void> {
  const ImagePickerSampleRoute({List<_i25.PageRouteInfo>? children})
      : super(
          ImagePickerSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ImagePickerSampleRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i14.InReviewPage]
class InReviewRoute extends _i25.PageRouteInfo<void> {
  const InReviewRoute({List<_i25.PageRouteInfo>? children})
      : super(
          InReviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'InReviewRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i15.JobDetailPage]
class JobDetailRoute extends _i25.PageRouteInfo<JobDetailRouteArgs> {
  JobDetailRoute({
    required String jobId,
    _i26.Key? key,
    List<_i25.PageRouteInfo>? children,
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

  static const _i25.PageInfo<JobDetailRouteArgs> page =
      _i25.PageInfo<JobDetailRouteArgs>(name);
}

class JobDetailRouteArgs {
  const JobDetailRouteArgs({
    required this.jobId,
    this.key,
  });

  final String jobId;

  final _i26.Key? key;

  @override
  String toString() {
    return 'JobDetailRouteArgs{jobId: $jobId, key: $key}';
  }
}

/// generated route for
/// [_i16.MapPage]
class MapRoute extends _i25.PageRouteInfo<void> {
  const MapRoute({List<_i25.PageRouteInfo>? children})
      : super(
          MapRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i17.MyAccountPage]
class MyAccountRoute extends _i25.PageRouteInfo<void> {
  const MyAccountRoute({List<_i25.PageRouteInfo>? children})
      : super(
          MyAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyAccountRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i18.ReviewsPage]
class ReviewsRoute extends _i25.PageRouteInfo<void> {
  const ReviewsRoute({List<_i25.PageRouteInfo>? children})
      : super(
          ReviewsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReviewsRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i19.RootPage]
class RootRoute extends _i25.PageRouteInfo<void> {
  const RootRoute({List<_i25.PageRouteInfo>? children})
      : super(
          RootRoute.name,
          initialChildren: children,
        );

  static const String name = 'RootRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i20.SampleTodosPage]
class SampleTodosRoute extends _i25.PageRouteInfo<void> {
  const SampleTodosRoute({List<_i25.PageRouteInfo>? children})
      : super(
          SampleTodosRoute.name,
          initialChildren: children,
        );

  static const String name = 'SampleTodosRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i21.SignInSamplePage]
class SignInSampleRoute extends _i25.PageRouteInfo<void> {
  const SignInSampleRoute({List<_i25.PageRouteInfo>? children})
      : super(
          SignInSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInSampleRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i22.UserSocialLoginSamplePage]
class UserSocialLoginSampleRoute extends _i25.PageRouteInfo<void> {
  const UserSocialLoginSampleRoute({List<_i25.PageRouteInfo>? children})
      : super(
          UserSocialLoginSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserSocialLoginSampleRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i23.WebLinkStubPage]
class WebLinkStubRoute extends _i25.PageRouteInfo<void> {
  const WebLinkStubRoute({List<_i25.PageRouteInfo>? children})
      : super(
          WebLinkStubRoute.name,
          initialChildren: children,
        );

  static const String name = 'WebLinkStubRoute';

  static const _i25.PageInfo<void> page = _i25.PageInfo<void>(name);
}

/// generated route for
/// [_i24.WorkerPage]
class WorkerRoute extends _i25.PageRouteInfo<WorkerRouteArgs> {
  WorkerRoute({
    required String userId,
    _i26.Key? key,
    List<_i25.PageRouteInfo>? children,
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

  static const _i25.PageInfo<WorkerRouteArgs> page =
      _i25.PageInfo<WorkerRouteArgs>(name);
}

class WorkerRouteArgs {
  const WorkerRouteArgs({
    required this.userId,
    this.key,
  });

  final String userId;

  final _i26.Key? key;

  @override
  String toString() {
    return 'WorkerRouteArgs{userId: $userId, key: $key}';
  }
}
