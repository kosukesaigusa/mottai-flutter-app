import 'package:auto_route/auto_route.dart';

import '../chat/ui/chat_room.dart';
import '../development/auth/ui/sign_in.dart';
import '../development/color/ui/color.dart';
import '../development/development_items/ui/development_items.dart';
import '../development/force_update/ui/force_update.dart';
import '../development/generic_image/ui/generic_images.dart';
import '../development/image_detail_view/image_detail_view_stub.dart';
import '../development/image_picker/ui/image_picker_sample.dart';
import '../development/in_review/ui/in_review.dart';
import '../development/sample_todo/ui/sample_todos.dart';
import '../development/web_link/ui/web_link_stub.dart';
import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  final List<AutoRoute> routes = [
    RedirectRoute(path: '/', redirectTo: DevelopmentItemsPage.path),
    AutoRoute(
      path: ChatRoomPage.path,
      page: ChatRoomRoute.page,
    ),
    // NOTE: 以下、開発用のページ。
    AutoRoute(
      path: ColorPage.path,
      page: ColorRoute.page,
    ),
    AutoRoute(
      path: DevelopmentItemsPage.path,
      page: DevelopmentItemsRoute.page,
    ),
    AutoRoute(
      path: ForceUpdateSamplePage.path,
      page: ForceUpdateSampleRoute.page,
    ),
    AutoRoute(
      path: GenericImagesPage.path,
      page: GenericImagesRoute.page,
    ),
    AutoRoute(
      path: ImageDetailViewStubPage.path,
      page: ImageDetailViewStubRoute.page,
    ),
    AutoRoute(
      path: ImagePickerSamplePage.path,
      page: ImagePickerSampleRoute.page,
    ),
    AutoRoute(
      path: InReviewPage.path,
      page: InReviewRoute.page,
    ),
    AutoRoute(
      path: SampleTodosPage.path,
      page: SampleTodosRoute.page,
    ),
    AutoRoute(
      path: SignInSamplePage.path,
      page: SignInSampleRoute.page,
    ),
    AutoRoute(
      path: WebLinkStubPage.path,
      page: WebLinkStubRoute.page,
    ),
  ];
}
