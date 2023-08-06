// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;
import 'package:mottai_flutter_app/chat/ui/chat_room.dart' as _i1;
import 'package:mottai_flutter_app/development/development_items/ui/development_items.dart'
    as _i2;

abstract class $AppRouter extends _i3.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    ChatRoomRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ChatRoomRouteArgs>(
          orElse: () => ChatRoomRouteArgs(
              chatRoomId: pathParams.getString('chatRoomId')));
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.ChatRoomPage(
          chatRoomId: args.chatRoomId,
          key: args.key,
        ),
      );
    },
    DevelopmentItemsRoute.name: (routeData) {
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.DevelopmentItemsPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.ChatRoomPage]
class ChatRoomRoute extends _i3.PageRouteInfo<ChatRoomRouteArgs> {
  ChatRoomRoute({
    required String chatRoomId,
    _i4.Key? key,
    List<_i3.PageRouteInfo>? children,
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

  static const _i3.PageInfo<ChatRoomRouteArgs> page =
      _i3.PageInfo<ChatRoomRouteArgs>(name);
}

class ChatRoomRouteArgs {
  const ChatRoomRouteArgs({
    required this.chatRoomId,
    this.key,
  });

  final String chatRoomId;

  final _i4.Key? key;

  @override
  String toString() {
    return 'ChatRoomRouteArgs{chatRoomId: $chatRoomId, key: $key}';
  }
}

/// generated route for
/// [_i2.DevelopmentItemsPage]
class DevelopmentItemsRoute extends _i3.PageRouteInfo<void> {
  const DevelopmentItemsRoute({List<_i3.PageRouteInfo>? children})
      : super(
          DevelopmentItemsRoute.name,
          initialChildren: children,
        );

  static const String name = 'DevelopmentItemsRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}
