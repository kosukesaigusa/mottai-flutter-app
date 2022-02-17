import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:mottai_flutter_app/controllers/application/application_controller.dart';
import 'package:mottai_flutter_app/controllers/application/application_state.dart';
import 'package:mottai_flutter_app/controllers/bottom_navigation_bar/bottom_navigation_bar_controller.dart';
import 'package:mottai_flutter_app/controllers/bottom_navigation_bar/bottom_navigation_bar_state.dart';
import 'package:mottai_flutter_app/controllers/snack_bar/snack_bar_controller.dart';
import 'package:mottai_flutter_app/repository/auth/auth_repository.dart';
import 'package:provider/provider.dart';

class AppMultiProvider extends StatelessWidget {
  const AppMultiProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // 同階層ではアルファベット順にしておく
    return MultiProvider(
      providers: [
        Provider(create: (_) => GlobalKey<NavigatorState>()),
        Provider(create: (_) => ScaffoldMessengerController()),
      ],
      child: MultiProvider(
        providers: [
          Provider(create: (_) => AuthRepository()),
          // Provider(create: (_) => CompletePaymentTaskRepository()),
          // Provider(create: (_) => CreateReceiptTaskRepository()),
          // Provider(create: (_) => CompletePaymentTaskRepository()),
          // Provider(create: (_) => PaymentRepository()),
          // Provider(create: (_) => SupportingGroupRepository()),
        ],
        child: MultiProvider(
          providers: [
            StateNotifierProvider<ApplicationController, ApplicationState>(
              create: (_) => ApplicationController(),
            ),
            StateNotifierProvider<BottomNavigationBarController, BottomNavigationBarState>(
              create: (_) => BottomNavigationBarController(),
            ),
            // StateNotifierProvider<MainPageController, MainPageState>(
            //   create: (_) => MainPageController(),
            // ),
            // StateNotifierProvider<PaymentManagementPageController, PaymentManagementPageState>(
            //   create: (_) => PaymentManagementPageController(),
            // ),
            // StateNotifierProvider<SignInPageController, SignInPageState>(
            //   create: (_) => SignInPageController(),
            // ),
            // StateNotifierProvider<PaymentLogsPageController, PaymentLogsPageState>(
            //   create: (_) => PaymentLogsPageController(),
            // ),
          ],
          child: child,
        ),
      ),
    );
  }
}
