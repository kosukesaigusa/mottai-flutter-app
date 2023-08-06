// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:mottai_flutter_app/chat/ui/chat_room.dart' as _i1;
import 'package:mottai_flutter_app/development/color/ui/color.dart' as _i2;
import 'package:mottai_flutter_app/development/development_items/ui/development_items.dart'
    as _i3;
import 'package:mottai_flutter_app/development/force_update/ui/force_update.dart'
    as _i4;
import 'package:mottai_flutter_app/development/generic_image/ui/generic_images.dart'
    as _i5;
import 'package:mottai_flutter_app/development/image_detail_view/ui/image_detail_view_stub.dart'
    as _i6;
import 'package:mottai_flutter_app/development/image_picker/ui/image_picker_sample.dart'
    as _i7;
import 'package:mottai_flutter_app/development/in_review/ui/in_review.dart'
    as _i8;
import 'package:mottai_flutter_app/development/sample_todo/ui/sample_todos.dart'
    as _i9;
import 'package:mottai_flutter_app/development/sign_in/ui/sign_in.dart' as _i10;
import 'package:mottai_flutter_app/development/web_link/ui/web_link_stub.dart'
    as _i11;

abstract class $AppRouter extends _i12.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i12.PageFactory> pagesMap = {
    ChatRoomRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ChatRoomRouteArgs>(
          orElse: () => ChatRoomRouteArgs(
              chatRoomId: pathParams.getString('chatRoomId')));
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.ChatRoomPage(
          chatRoomId: args.chatRoomId,
          key: args.key,
        ),
      );
    },
    ColorRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ColorPage(),
      );
    },
    DevelopmentItemsRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.DevelopmentItemsPage(),
      );
    },
    ForceUpdateSampleRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.ForceUpdateSamplePage(),
      );
    },
    GenericImagesRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.GenericImagesPage(),
      );
    },
    ImageDetailViewStubRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ImageDetailViewStubPage(),
      );
    },
    ImagePickerSampleRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.ImagePickerSamplePage(),
      );
    },
    InReviewRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.InReviewPage(),
      );
    },
    SampleTodosRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SampleTodosPage(),
      );
    },
    SignInSampleRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.SignInSamplePage(),
      );
    },
    WebLinkStubRoute.name: (routeData) {
      return _i12.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.WebLinkStubPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.ChatRoomPage]
class ChatRoomRoute extends _i12.PageRouteInfo<ChatRoomRouteArgs> {
  ChatRoomRoute({
    required String chatRoomId,
    _i13.Key? key,
    List<_i12.PageRouteInfo>? children,
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

  static const _i12.PageInfo<ChatRoomRouteArgs> page =
      _i12.PageInfo<ChatRoomRouteArgs>(name);
}

class ChatRoomRouteArgs {
  const ChatRoomRouteArgs({
    required this.chatRoomId,
    this.key,
  });

  final String chatRoomId;

  final _i13.Key? key;

  @override
  String toString() {
    return 'ChatRoomRouteArgs{chatRoomId: $chatRoomId, key: $key}';
  }
}

/// generated route for
/// [_i2.ColorPage]
class ColorRoute extends _i12.PageRouteInfo<void> {
  const ColorRoute({List<_i12.PageRouteInfo>? children})
      : super(
          ColorRoute.name,
          initialChildren: children,
        );

  static const String name = 'ColorRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i3.DevelopmentItemsPage]
class DevelopmentItemsRoute extends _i12.PageRouteInfo<void> {
  const DevelopmentItemsRoute({List<_i12.PageRouteInfo>? children})
      : super(
          DevelopmentItemsRoute.name,
          initialChildren: children,
        );

  static const String name = 'DevelopmentItemsRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ForceUpdateSamplePage]
class ForceUpdateSampleRoute extends _i12.PageRouteInfo<void> {
  const ForceUpdateSampleRoute({List<_i12.PageRouteInfo>? children})
      : super(
          ForceUpdateSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForceUpdateSampleRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i5.GenericImagesPage]
class GenericImagesRoute extends _i12.PageRouteInfo<void> {
  const GenericImagesRoute({List<_i12.PageRouteInfo>? children})
      : super(
          GenericImagesRoute.name,
          initialChildren: children,
        );

  static const String name = 'GenericImagesRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ImageDetailViewStubPage]
class ImageDetailViewStubRoute extends _i12.PageRouteInfo<void> {
  const ImageDetailViewStubRoute({List<_i12.PageRouteInfo>? children})
      : super(
          ImageDetailViewStubRoute.name,
          initialChildren: children,
        );

  static const String name = 'ImageDetailViewStubRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i7.ImagePickerSamplePage]
class ImagePickerSampleRoute extends _i12.PageRouteInfo<void> {
  const ImagePickerSampleRoute({List<_i12.PageRouteInfo>? children})
      : super(
          ImagePickerSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ImagePickerSampleRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i8.InReviewPage]
class InReviewRoute extends _i12.PageRouteInfo<void> {
  const InReviewRoute({List<_i12.PageRouteInfo>? children})
      : super(
          InReviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'InReviewRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i9.SampleTodosPage]
class SampleTodosRoute extends _i12.PageRouteInfo<void> {
  const SampleTodosRoute({List<_i12.PageRouteInfo>? children})
      : super(
          SampleTodosRoute.name,
          initialChildren: children,
        );

  static const String name = 'SampleTodosRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i10.SignInSamplePage]
class SignInSampleRoute extends _i12.PageRouteInfo<void> {
  const SignInSampleRoute({List<_i12.PageRouteInfo>? children})
      : super(
          SignInSampleRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInSampleRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}

/// generated route for
/// [_i11.WebLinkStubPage]
class WebLinkStubRoute extends _i12.PageRouteInfo<void> {
  const WebLinkStubRoute({List<_i12.PageRouteInfo>? children})
      : super(
          WebLinkStubRoute.name,
          initialChildren: children,
        );

  static const String name = 'WebLinkStubRoute';

  static const _i12.PageInfo<void> page = _i12.PageInfo<void>(name);
}
