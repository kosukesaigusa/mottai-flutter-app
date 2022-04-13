import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CustomHeroPageRouter extends PageRouteBuilder<dynamic> {
  CustomHeroPageRouter({
    this.builder,
    required RouteTransitionsBuilder transitionsBuilder,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => Semantics(
            scopesRoute: true,
            explicitChildNodes: true,
            child: builder!(context),
          ),
          transitionsBuilder: transitionsBuilder,
        );

  final WidgetBuilder? builder;

  static Widget buildPageTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.fullscreenDialog) {
      return CustomHeroFullScreenDialogTransition(
        animation: animation,
        child: child,
      );
    } else {
      return CustomHeroPageTransition(
        route: route,
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        child: child,
      );
    }
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      const CustomHeroPageTransitionsBuilder()
          .buildTransitions<dynamic>(this, context, animation, secondaryAnimation, child);
}

class CustomHeroPageTransitionsBuilder extends PageTransitionsBuilder {
  const CustomHeroPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      CustomHeroPageRouter.buildPageTransitions<T>(
          route, context, animation, secondaryAnimation, child);
}

final Animatable<double> _scaleTween = Tween<double>(begin: 0.5, end: 1);
final Animatable<double> _constTween = Tween<double>(begin: 0, end: 1);
final Animatable<Offset> _kBottomUpTween = Tween<Offset>(
  begin: const Offset(0, 1),
  end: Offset.zero,
);

class CustomHeroFullScreenDialogTransition extends StatelessWidget {
  CustomHeroFullScreenDialogTransition({
    Key? key,
    required Animation<double> animation,
    required this.child,
  })  : _positionAnimation =
            animation.drive(CurveTween(curve: Curves.easeInOut)).drive(_kBottomUpTween),
        super(key: key);

  final Animation<Offset> _positionAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) => SlideTransition(
        position: _positionAnimation,
        child: child,
      );
}

class CustomHeroPageTransition extends StatelessWidget {
  CustomHeroPageTransition({
    Key? key,
    required Animation<double> primaryRouteAnimation,
    required Animation<double> secondaryRouteAnimation,
    this.route,
    required this.child,
  })  : _primaryPositionAnimation = CurvedAnimation(
          parent: primaryRouteAnimation,
          curve: Curves.linearToEaseOut,
          reverseCurve: Curves.easeInCirc,
        ).drive(_scaleTween),
        _secondaryPositionAnimation = CurvedAnimation(
          parent: secondaryRouteAnimation,
          curve: Curves.linearToEaseOut,
          reverseCurve: Curves.easeInToLinear,
        ).drive(_constTween),
        super(key: key);

  final Animation<double> _primaryPositionAnimation;
  final Animation<double> _secondaryPositionAnimation;

  final Route? route;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: (1 - _secondaryPositionAnimation.value) * 5,
                sigmaY: (1 - _secondaryPositionAnimation.value) * 5,
              ),
              child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
              ),
            ),
          ),
          ScaleTransition(
            scale: _primaryPositionAnimation,
            child: child,
          ),
        ],
      );
}
