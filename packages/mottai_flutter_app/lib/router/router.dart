import 'package:auto_route/auto_route.dart';

import '../chat/ui/chat_room.dart';
import '../chat/ui/chat_rooms.dart';
import '../development/color/ui/color.dart';
import '../development/development_items/ui/development_items.dart';
import '../development/email_and_password_sign_in/ui/email_and_password_sign_in.dart';
import '../development/firebase_messaging/ui/firebase_messaging.dart';
import '../development/firebase_storage/ui/firebase_storage.dart';
import '../development/force_update/ui/force_update.dart';
import '../development/generic_image/ui/generic_images.dart';
import '../development/image_detail_view/ui/image_detail_view_stub.dart';
import '../development/image_picker/ui/image_picker_sample.dart';
import '../development/in_review/ui/in_review.dart';
import '../development/sample_todo/ui/sample_todos.dart';
import '../development/sign_in/ui/sign_in.dart';
import '../development/user_social_login/user_social_login.dart';
import '../development/web_link/ui/web_link_stub.dart';
import '../host/ui/host_create.dart';
import '../host/ui/host.dart';
import '../host/ui/host_update.dart';
import '../job/ui/job_create.dart';
import '../job/ui/job_detail.dart';
import '../job/ui/job_update.dart';
import '../map/ui/map.dart';
import '../my_account/ui/my_account.dart';
import '../review/ui/reviews.dart';
import '../root/ui/root.dart';
import '../worker/ui/create_or_update_worker.dart';
import '../worker/ui/worker.dart';
import 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(
      path: RootPage.path,
      page: RootRoute.page,
      children: [
        AutoRoute(
          path: MapPage.path,
          page: MapRoute.page,
        ),
        AutoRoute(
          path: ChatRoomsPage.path,
          page: ChatRoomsRoute.page,
        ),
        AutoRoute(
          path: ReviewsPage.path,
          page: ReviewsRoute.page,
        ),
        AutoRoute(
          path: MyAccountPage.path,
          page: MyAccountRoute.page,
        ),
      ],
    ),
    AutoRoute(
      path: ChatRoomPage.path,
      page: ChatRoomRoute.page,
    ),
    AutoRoute(
      path: JobCreatePage.path,
      page: JobCreateRoute.page,
    ),
    AutoRoute(
      path: JobDetailPage.path,
      page: JobDetailRoute.page,
    ),
    AutoRoute(
      path: JobUpdatePage.path,
      page: JobUpdateRoute.page,
    ),
    AutoRoute(
      path: WorkerPage.path,
      page: WorkerRoute.page,
    ),
    AutoRoute(
      path: HostCreatePage.path,
      page: HostCreateRoute.page,
    ),
    AutoRoute(
      path: HostPage.path,
      page: HostRoute.page,
    ),
    AutoRoute(
      path: HostUpdatePage.path,
      page: HostUpdateRoute.page,
    ),
    // AutoRoute(
    //   path: UserPage.path,
    //   page: UserRoute.page,
    // ),
    AutoRoute(
      path: CreateOrUpdateWorkerPage.path,
      page: CreateOrUpdateWorkerRoute.page,
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
      path: EmailAndPasswordSignInPage.path,
      page: EmailAndPasswordSignInRoute.page,
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
    AutoRoute(
      path: UserSocialLoginSamplePage.path,
      page: UserSocialLoginSampleRoute.page,
    ),
    AutoRoute(
      path: FirebaseMessagingPage.path,
      page: FirebaseMessagingRoute.page,
    ),
  ];
}
