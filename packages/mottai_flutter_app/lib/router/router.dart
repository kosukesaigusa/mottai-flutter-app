import 'package:auto_route/auto_route.dart';

import '../chat/ui/chat_room.dart';
import '../chat/ui/chat_rooms.dart';
import '../development/color/ui/color.dart';
import '../development/development_items/ui/development_items.dart';
import '../development/firebase_storage/ui/firebase_storage.dart';
import '../development/force_update/ui/force_update.dart';
import '../development/generic_image/ui/generic_images.dart';
import '../development/image_detail_view/ui/image_detail_view_stub.dart';
import '../development/image_picker/ui/image_picker_sample.dart';
import '../development/in_review/ui/in_review.dart';
import '../development/sample_todo/ui/sample_todos.dart';
import '../development/sign_in/ui/sign_in.dart';
import '../development/web_link/ui/web_link_stub.dart';
import '../host/ui/create_or_update_host.dart';
import '../job/ui/job_detail.dart';
import '../map/ui/map.dart';
import '../worker/ui/worker.dart';
import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  final List<AutoRoute> routes = [
    RedirectRoute(path: '/', redirectTo: DevelopmentItemsPage.path),
    AutoRoute(
      path: MapPage.path,
      page: MapRoute.page,
    ),
    AutoRoute(
      path: ChatRoomsPage.path,
      page: ChatRoomsRoute.page,
    ),
    AutoRoute(
      path: ChatRoomPage.path,
      page: ChatRoomRoute.page,
    ),
    AutoRoute(
      path: JobDetailPage.path,
      page: JobDetailRoute.page,
    ),
    AutoRoute(
      path: WorkerPage.path,
      page: WorkerRoute.page,
    ),
    // AutoRoute(
    //   path: CreateOrUpdateJobPage.path,
    //   page: CreateOrUpdateJobRoute.page,
    // ),
    // AutoRoute(
    //   path: UserPage.path,
    //   page: UserRoute.page,
    // ),
    AutoRoute(
      path: CreateOrUpdateHostPage.path,
      page: CreateOrUpdateHostRoute.page,
      fullscreenDialog: true,
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
      path: FirebaseStorageSamplePage.path,
      page: FirebaseStorageSampleRoute.page,
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
