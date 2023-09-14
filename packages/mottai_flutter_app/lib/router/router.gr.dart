// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i31;
import 'package:flutter/material.dart' as _i32;
import 'package:mottai_flutter_app/chat/ui/chat_room.dart' as _i1;
import 'package:mottai_flutter_app/chat/ui/chat_rooms.dart' as _i2;
import 'package:mottai_flutter_app/development/color/ui/color.dart' as _i3;
import 'package:mottai_flutter_app/development/development_items/ui/development_items.dart'
    as _i5;
import 'package:mottai_flutter_app/development/email_and_password_sign_in/ui/email_and_password_sign_in.dart'
    as _i6;
import 'package:mottai_flutter_app/development/firebase_messaging/ui/firebase_messaging.dart'
    as _i7;
import 'package:mottai_flutter_app/development/firebase_storage/ui/firebase_storage.dart'
    as _i8;
import 'package:mottai_flutter_app/development/force_update/ui/force_update.dart'
    as _i9;
import 'package:mottai_flutter_app/development/generic_image/ui/generic_images.dart'
    as _i10;
import 'package:mottai_flutter_app/development/image_detail_view/ui/image_detail_view_stub.dart'
    as _i14;
import 'package:mottai_flutter_app/development/image_picker/ui/image_picker_sample.dart'
    as _i15;
import 'package:mottai_flutter_app/development/in_review/ui/in_review.dart'
    as _i16;
import 'package:mottai_flutter_app/development/sample_todo/ui/todos.dart'
    as _i25;
import 'package:mottai_flutter_app/development/sign_in/ui/sign_in.dart' as _i24;
import 'package:mottai_flutter_app/development/user_fcm_token/ui/user_fcm_token.dart'
    as _i27;
import 'package:mottai_flutter_app/development/user_generate_content/ui/user_generate_content_sample.dart'
    as _i26;
import 'package:mottai_flutter_app/development/user_social_login/user_social_login.dart'
    as _i28;
import 'package:mottai_flutter_app/development/web_link/ui/web_link_stub.dart'
    as _i29;
import 'package:mottai_flutter_app/host/ui/host.dart' as _i12;
import 'package:mottai_flutter_app/host/ui/host_create.dart' as _i11;
import 'package:mottai_flutter_app/host/ui/host_update.dart' as _i13;
import 'package:mottai_flutter_app/job/ui/job_create.dart' as _i17;
import 'package:mottai_flutter_app/job/ui/job_detail.dart' as _i18;
import 'package:mottai_flutter_app/job/ui/job_update.dart' as _i19;
import 'package:mottai_flutter_app/map/ui/map.dart' as _i20;
import 'package:mottai_flutter_app/my_account/ui/my_account.dart' as _i21;
import 'package:mottai_flutter_app/review/ui/reviews.dart' as _i22;
import 'package:mottai_flutter_app/root/ui/root.dart' as _i23;
import 'package:mottai_flutter_app/worker/ui/create_or_update_worker.dart'
    as _i4;
import 'package:mottai_flutter_app/worker/ui/worker.dart' as _i30;

abstract class $AppRouter extends _i31.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i31.PageFactory> pagesMap = {
    ChatRoomRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ChatRoomRouteArgs>(
          orElse: () => ChatRoomRouteArgs(
              chatRoomId: pathParams.getString('chatRoomId')));
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.ChatRoomPage(
          chatRoomId: args.chatRoomId,
          key: args.key,
        ),
      );
    },
    ChatRoomsRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ChatRoomsPage(),
      );
    },
    ColorRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ColorPage(),
      );
    },
    CreateOrUpdateWorkerRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CreateOrUpdateWorkerRouteArgs>(
          orElse: () => CreateOrUpdateWorkerRouteArgs(
              userId: pathParams.getString('userId')));
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.CreateOrUpdateWorkerPage(
          userId: args.userId,
          key: args.key,
        ),
      );
    },
    DevelopmentItemsRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.DevelopmentItemsPage(),
      );
    },
    EmailAndPasswordSignInRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.EmailAndPasswordSignInPage(),
      );
    },
    FirebaseMessagingRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.FirebaseMessagingPage(),
      );
    },
    FirebaseStorageSampleRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.FirebaseStorageSamplePage(),
      );
    },
    ForceUpdateSampleRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.ForceUpdateSamplePage(),
      );
    },
    GenericImagesRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.GenericImagesPage(),
      );
    },
    HostCreateRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.HostCreatePage(),
      );
    },
    HostRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HostRouteArgs>(
          orElse: () => HostRouteArgs(userId: pathParams.getString('userId')));
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.HostPage(
          userId: args.userId,
          key: args.key,
        ),
      );
    },
    HostUpdateRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<HostUpdateRouteArgs>(
          orElse: () =>
              HostUpdateRouteArgs(hostId: pathParams.getString('hostId')));
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i13.HostUpdatePage(
          hostId: args.hostId,
          key: args.key,
        ),
      );
    },
    ImageDetailViewStubRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.ImageDetailViewStubPage(),
      );
    },
    ImagePickerSampleRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.ImagePickerSamplePage(),
      );
    },
    InReviewRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.InReviewPage(),
      );
    },
    JobCreateRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.JobCreatePage(),
      );
    },
    JobDetailRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<JobDetailRouteArgs>(
          orElse: () =>
              JobDetailRouteArgs(jobId: pathParams.getString('jobId')));
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i18.JobDetailPage(
          jobId: args.jobId,
          key: args.key,
        ),
      );
    },
    JobUpdateRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<JobUpdateRouteArgs>(
          orElse: () =>
              JobUpdateRouteArgs(jobId: pathParams.getString('jobId')));
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i19.JobUpdatePage(
          jobId: args.jobId,
          key: args.key,
        ),
      );
    },
    MapRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i20.MapPage(),
      );
    },
    MyAccountRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i21.MyAccountPage(),
      );
    },
    ReviewsRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i22.ReviewsPage(),
      );
    },
    RootRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i23.RootPage(),
      );
    },
    SignInSampleRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i24.SignInSamplePage(),
      );
    },
    TodosRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i25.TodosPage(),
      );
    },
    UgcSampleRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i26.UgcSamplePage(),
      );
    },
    UgcSampleRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i26.UgcSamplePage(),
      );
    },
    UserFcmTokenRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i27.UserFcmTokenPage(),
      );
    },
    UserSocialLoginSampleRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i28.UserSocialLoginSamplePage(),
      );
    },
    WebLinkStubRoute.name: (routeData) {
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i29.WebLinkStubPage(),
      );
    },
    WorkerRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<WorkerRouteArgs>(
          orElse: () =>
              WorkerRouteArgs(userId: pathParams.getString('userId')));
      return _i31.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i30.WorkerPage(
          userId: args.userId,
          key: args.key,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.ChatRoomPage]
class ChatRoomRoute extends _i31.PageRouteInfo<ChatRoomRouteArgs> {
  ChatRoomRoute({
    required String chatRoomId,
    _i32.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<ChatRoomRouteArgs> page =
      _i31.PageInfo<ChatRoomRouteArgs>(name);
}

class ChatRoomRouteArgs {
  const ChatRoomRouteArgs({
    required this.chatRoomId,
    this.key,
  });

  final String chatRoomId;

  final _i32.Key? key;

  @override
  String toString() {
    return 'ChatRoomRouteArgs{chatRoomId: $chatRoomId, key: $key}';
  }
}

/// generated route for
/// [_i2.ChatRoomsPage]
class ChatRoomsRoute extends _i31.PageRouteInfo<void> {
  const ChatRoomsRoute({List<_i31.PageRouteInfo>? children})
      : super(
          ChatRoomsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatRoomsRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ColorPage]
class ColorRoute extends _i31.PageRouteInfo<void> {
  const ColorRoute({List<_i31.PageRouteInfo>? children})
      : super(
          ColorRoute.name,
          initialChildren: children,
        );

  static const String name = 'ColorRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i4.CreateOrUpdateWorkerPage]
class CreateOrUpdateWorkerRoute
    extends _i31.PageRouteInfo<CreateOrUpdateWorkerRouteArgs> {
  CreateOrUpdateWorkerRoute({
    required String userId,
    _i32.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<CreateOrUpdateWorkerRouteArgs> page =
      _i31.PageInfo<CreateOrUpdateWorkerRouteArgs>(name);
}

class CreateOrUpdateWorkerRouteArgs {
  const CreateOrUpdateWorkerRouteArgs({
    required this.userId,
    this.key,
  });

  final String userId;

  final _i32.Key? key;

  @override
  String toString() {
    return 'CreateOrUpdateWorkerRouteArgs{userId: $userId, key: $key}';
  }
}

/// generated route for
/// [_i5.DevelopmentItemsPage]
class DevelopmentItemsRoute extends _i31.PageRouteInfo<void> {
  const DevelopmentItemsRoute({List<_i31.PageRouteInfo>? children})
      : super(
          DevelopmentItemsRoute.name,
          initialChildren: children,
        );

  static const String name = 'DevelopmentItemsRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i6.EmailAndPasswordSignInPage]
class EmailAndPasswordSignInRoute extends _i31.PageRouteInfo<void> {
  const EmailAndPasswordSignInRoute({List<_i31.PageRouteInfo>? children})
      : super(
          EmailAndPasswordSignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'EmailAndPasswordSignInRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i7.FirebaseMessagingPage]
class FirebaseMessagingRoute extends _i31.PageRouteInfo<void> {
  const FirebaseMessagingRoute({List<_i31.PageRouteInfo>? children})
      : super(
          FirebaseMessagingRoute.name,
          initialChildren: children,
        );

  static const String name = 'FirebaseMessagingRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i8.FirebaseStorageSamplePage]
class FirebaseStorageSampleRoute extends _i31.PageRouteInfo<void> {
  const FirebaseStorageSampleRoute({List<_i31.PageRouteInfo>? children})
      : super(
          FirebaseStorageSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'FirebaseStorageSampleRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i9.ForceUpdateSamplePage]
class ForceUpdateSampleRoute extends _i31.PageRouteInfo<void> {
  const ForceUpdateSampleRoute({List<_i31.PageRouteInfo>? children})
      : super(
          ForceUpdateSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForceUpdateSampleRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i10.GenericImagesPage]
class GenericImagesRoute extends _i31.PageRouteInfo<void> {
  const GenericImagesRoute({List<_i31.PageRouteInfo>? children})
      : super(
          GenericImagesRoute.name,
          initialChildren: children,
        );

  static const String name = 'GenericImagesRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i11.HostCreatePage]
class HostCreateRoute extends _i31.PageRouteInfo<void> {
  const HostCreateRoute({List<_i31.PageRouteInfo>? children})
      : super(
          HostCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'HostCreateRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i12.HostPage]
class HostRoute extends _i31.PageRouteInfo<HostRouteArgs> {
  HostRoute({
    required String userId,
    _i32.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<HostRouteArgs> page =
      _i31.PageInfo<HostRouteArgs>(name);
}

class HostRouteArgs {
  const HostRouteArgs({
    required this.userId,
    this.key,
  });

  final String userId;

  final _i32.Key? key;

  @override
  String toString() {
    return 'HostRouteArgs{userId: $userId, key: $key}';
  }
}

/// generated route for
/// [_i13.HostUpdatePage]
class HostUpdateRoute extends _i31.PageRouteInfo<HostUpdateRouteArgs> {
  HostUpdateRoute({
    required String hostId,
    _i32.Key? key,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          HostUpdateRoute.name,
          args: HostUpdateRouteArgs(
            hostId: hostId,
            key: key,
          ),
          rawPathParams: {'hostId': hostId},
          initialChildren: children,
        );

  static const String name = 'HostUpdateRoute';

  static const _i31.PageInfo<HostUpdateRouteArgs> page =
      _i31.PageInfo<HostUpdateRouteArgs>(name);
}

class HostUpdateRouteArgs {
  const HostUpdateRouteArgs({
    required this.hostId,
    this.key,
  });

  final String hostId;

  final _i32.Key? key;

  @override
  String toString() {
    return 'HostUpdateRouteArgs{hostId: $hostId, key: $key}';
  }
}

/// generated route for
/// [_i14.ImageDetailViewStubPage]
class ImageDetailViewStubRoute extends _i31.PageRouteInfo<void> {
  const ImageDetailViewStubRoute({List<_i31.PageRouteInfo>? children})
      : super(
          ImageDetailViewStubRoute.name,
          initialChildren: children,
        );

  static const String name = 'ImageDetailViewStubRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i15.ImagePickerSamplePage]
class ImagePickerSampleRoute extends _i31.PageRouteInfo<void> {
  const ImagePickerSampleRoute({List<_i31.PageRouteInfo>? children})
      : super(
          ImagePickerSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ImagePickerSampleRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i16.InReviewPage]
class InReviewRoute extends _i31.PageRouteInfo<void> {
  const InReviewRoute({List<_i31.PageRouteInfo>? children})
      : super(
          InReviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'InReviewRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i17.JobCreatePage]
class JobCreateRoute extends _i31.PageRouteInfo<void> {
  const JobCreateRoute({List<_i31.PageRouteInfo>? children})
      : super(
          JobCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'JobCreateRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i18.JobDetailPage]
class JobDetailRoute extends _i31.PageRouteInfo<JobDetailRouteArgs> {
  JobDetailRoute({
    required String jobId,
    _i32.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<JobDetailRouteArgs> page =
      _i31.PageInfo<JobDetailRouteArgs>(name);
}

class JobDetailRouteArgs {
  const JobDetailRouteArgs({
    required this.jobId,
    this.key,
  });

  final String jobId;

  final _i32.Key? key;

  @override
  String toString() {
    return 'JobDetailRouteArgs{jobId: $jobId, key: $key}';
  }
}

/// generated route for
/// [_i19.JobUpdatePage]
class JobUpdateRoute extends _i31.PageRouteInfo<JobUpdateRouteArgs> {
  JobUpdateRoute({
    required String jobId,
    _i32.Key? key,
    List<_i31.PageRouteInfo>? children,
  }) : super(
          JobUpdateRoute.name,
          args: JobUpdateRouteArgs(
            jobId: jobId,
            key: key,
          ),
          rawPathParams: {'jobId': jobId},
          initialChildren: children,
        );

  static const String name = 'JobUpdateRoute';

  static const _i31.PageInfo<JobUpdateRouteArgs> page =
      _i31.PageInfo<JobUpdateRouteArgs>(name);
}

class JobUpdateRouteArgs {
  const JobUpdateRouteArgs({
    required this.jobId,
    this.key,
  });

  final String jobId;

  final _i32.Key? key;

  @override
  String toString() {
    return 'JobUpdateRouteArgs{jobId: $jobId, key: $key}';
  }
}

/// generated route for
/// [_i20.MapPage]
class MapRoute extends _i31.PageRouteInfo<void> {
  const MapRoute({List<_i31.PageRouteInfo>? children})
      : super(
          MapRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i21.MyAccountPage]
class MyAccountRoute extends _i31.PageRouteInfo<void> {
  const MyAccountRoute({List<_i31.PageRouteInfo>? children})
      : super(
          MyAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyAccountRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i22.ReviewsPage]
class ReviewsRoute extends _i31.PageRouteInfo<void> {
  const ReviewsRoute({List<_i31.PageRouteInfo>? children})
      : super(
          ReviewsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ReviewsRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i23.RootPage]
class RootRoute extends _i31.PageRouteInfo<void> {
  const RootRoute({List<_i31.PageRouteInfo>? children})
      : super(
          RootRoute.name,
          initialChildren: children,
        );

  static const String name = 'RootRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i24.SignInSamplePage]
class SignInSampleRoute extends _i31.PageRouteInfo<void> {
  const SignInSampleRoute({List<_i31.PageRouteInfo>? children})
      : super(
          SignInSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInSampleRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i25.TodosPage]
class TodosRoute extends _i31.PageRouteInfo<void> {
  const TodosRoute({List<_i31.PageRouteInfo>? children})
      : super(
          TodosRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodosRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i26.UgcSamplePage]
class UgcSampleRoute extends _i31.PageRouteInfo<void> {
  const UgcSampleRoute({List<_i31.PageRouteInfo>? children})
      : super(
          UgcSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'UgcSampleRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i27.UserFcmTokenPage]
class UserFcmTokenRoute extends _i31.PageRouteInfo<void> {
  const UserFcmTokenRoute({List<_i31.PageRouteInfo>? children})
      : super(
          UserFcmTokenRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserFcmTokenRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i28.UserSocialLoginSamplePage]
class UserSocialLoginSampleRoute extends _i31.PageRouteInfo<void> {
  const UserSocialLoginSampleRoute({List<_i31.PageRouteInfo>? children})
      : super(
          UserSocialLoginSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserSocialLoginSampleRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i29.WebLinkStubPage]
class WebLinkStubRoute extends _i31.PageRouteInfo<void> {
  const WebLinkStubRoute({List<_i31.PageRouteInfo>? children})
      : super(
          WebLinkStubRoute.name,
          initialChildren: children,
        );

  static const String name = 'WebLinkStubRoute';

  static const _i31.PageInfo<void> page = _i31.PageInfo<void>(name);
}

/// generated route for
/// [_i30.WorkerPage]
class WorkerRoute extends _i31.PageRouteInfo<WorkerRouteArgs> {
  WorkerRoute({
    required String userId,
    _i32.Key? key,
    List<_i31.PageRouteInfo>? children,
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

  static const _i31.PageInfo<WorkerRouteArgs> page =
      _i31.PageInfo<WorkerRouteArgs>(name);
}

class WorkerRouteArgs {
  const WorkerRouteArgs({
    required this.userId,
    this.key,
  });

  final String userId;

  final _i32.Key? key;

  @override
  String toString() {
    return 'WorkerRouteArgs{userId: $userId, key: $key}';
  }
}
