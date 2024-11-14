import 'package:flutter/material.dart';

///[QuickTransition] is a class providing quick implementations of
///various transition animations for routing between screens.
///
/// The [_transitionRoute] function is a generic helper function creating
/// a [PageRouteBuilder] with a specified transition builder.
///
/// Each transition method (slide, rotation, scale, size, fade) uses
/// [_transitionRoute] and provides a specific transition builder for the
/// desired animation effect.
///
sealed class QuickTransition<T> {
  const QuickTransition({
    this.transitionDuration = const Duration(milliseconds: 100),
    this.reverseTransitionDuration = const Duration(milliseconds: 100),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.allowSnapshotting = true,
  });

  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final bool opaque;
  final bool barrierDismissible;
  final Color? barrierColor;
  final String? barrierLabel;
  final bool maintainState;
  final bool fullscreenDialog;
  final bool allowSnapshotting;

  static PageRouteBuilder<T> _transitionRoute<T>(
    Widget child,
    Widget Function(Animation<double> animation) transitionBuilder, {
    required Duration transitionDuration,
    required Duration reverseTransitionDuration,
    required bool opaque,
    required bool barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    required bool maintainState,
    required bool fullscreenDialog,
    required bool allowSnapshotting,
  }) {
    return PageRouteBuilder<T>(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          currentChild,
        ) {
          // Invoke the specified transition builder
          return transitionBuilder(animation);
        },
        transitionDuration: transitionDuration,
        reverseTransitionDuration: transitionDuration,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        allowSnapshotting: allowSnapshotting);
  }

  // Slide transition
  static PageRouteBuilder<T> slide<T>(
    Widget child, {
    Offset? begin,
    Offset? end,
    Animatable<double>? curve,
    bool transformHitTests = true,
    TextDirection? textDirection,
    required Duration transitionDuration,
    required Duration reverseTransitionDuration,
    required bool opaque,
    required bool barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    required bool maintainState,
    required bool fullscreenDialog,
    required bool allowSnapshotting,
  }) {
    return _transitionRoute<T>(child, (animation) {
      Offset start = begin ?? const Offset(1.0, 0.0);
      Offset finish = end ?? Offset.zero;
      Animatable<double> animate = curve ?? CurveTween(curve: Curves.easeInOut);

      var tween = Tween(begin: start, end: finish).chain(animate);
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        transformHitTests: transformHitTests,
        textDirection: textDirection,
        child: child,
      );
    },
        transitionDuration: transitionDuration,
        reverseTransitionDuration: transitionDuration,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        allowSnapshotting: allowSnapshotting);
  }

  // Rotation transition
  static PageRouteBuilder<T> rotation<T>(
    Widget child, {
    Animation<double>? turns,
    Alignment? alignment,
    FilterQuality? filterQuality,
    required Duration transitionDuration,
    required Duration reverseTransitionDuration,
    required bool opaque,
    required bool barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    required bool maintainState,
    required bool fullscreenDialog,
    required bool allowSnapshotting,
  }) {
    return _transitionRoute<T>(
        child,
        (animation) => RotationTransition(
              turns:
                  turns ?? Tween<double>(begin: 0, end: 1).animate(animation),
              alignment: alignment!,
              filterQuality: filterQuality,
              child: child,
            ),
        transitionDuration: transitionDuration,
        reverseTransitionDuration: transitionDuration,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        allowSnapshotting: allowSnapshotting);
  }

  // Scale transition
  static PageRouteBuilder<T> scale<T>(
    Widget child, {
    Animation<double>? scale,
    Alignment? alignment,
    FilterQuality? filterQuality,
    required Duration transitionDuration,
    required Duration reverseTransitionDuration,
    required bool opaque,
    required bool barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    required bool maintainState,
    required bool fullscreenDialog,
    required bool allowSnapshotting,
  }) {
    return _transitionRoute<T>(
        child,
        (animation) => ScaleTransition(
              alignment: alignment!,
              filterQuality: filterQuality,
              scale:
                  scale ?? Tween<double>(begin: 0, end: 1).animate(animation),
              child: child,
            ),
        transitionDuration: transitionDuration,
        reverseTransitionDuration: transitionDuration,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        allowSnapshotting: allowSnapshotting);
  }

  // Size transition
  static PageRouteBuilder<T> size<T>(
    Widget child, {
    Axis axis = Axis.vertical,
    Animation<double>? sizeFactor,
    double axisAlignment = 0.0,
    double? fixedCrossAxisSizeFactor,
    required Duration transitionDuration,
    required Duration reverseTransitionDuration,
    required bool opaque,
    required bool barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    required bool maintainState,
    required bool fullscreenDialog,
    required bool allowSnapshotting,
  }) {
    return _transitionRoute<T>(
        child,
        (animation) => SizeTransition(
              axisAlignment: axisAlignment,
              fixedCrossAxisSizeFactor: fixedCrossAxisSizeFactor,
              axis: axis,
              sizeFactor: sizeFactor ??
                  Tween<double>(begin: 0, end: 1).animate(animation),
              child: child,
            ),
        transitionDuration: transitionDuration,
        reverseTransitionDuration: transitionDuration,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        allowSnapshotting: allowSnapshotting);
  }

  // Fade transition
  static PageRouteBuilder<T> fade<T>(
    Widget child, {
    Animation<double>? opacity,
    bool alwaysIncludeSemantics = false,
    required Duration transitionDuration,
    required Duration reverseTransitionDuration,
    required bool opaque,
    required bool barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    required bool maintainState,
    required bool fullscreenDialog,
    required bool allowSnapshotting,
  }) {
    return _transitionRoute<T>(
        child,
        (animation) => FadeTransition(
              opacity:
                  opacity ?? Tween<double>(begin: 0, end: 1).animate(animation),
              alwaysIncludeSemantics: alwaysIncludeSemantics,
              child: child,
            ),
        transitionDuration: transitionDuration,
        reverseTransitionDuration: transitionDuration,
        opaque: opaque,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        allowSnapshotting: allowSnapshotting);
  }

  // Slide transition for named routes
  static PageRouteBuilder<T> slideNamed<T>(
      String routeName, {
        Offset begin = const Offset(1.0, 0.0),
        Offset end = Offset.zero,
        Curve curve = Curves.easeInOut,
        Object? arguments,
        Duration duration = const Duration(milliseconds: 300),
      }) {
    return PageRouteBuilder<T>(
      settings: RouteSettings(name: routeName, arguments: arguments),
      pageBuilder: (context, animation, secondaryAnimation) {
        final builder = _getRouteBuilder(context, routeName);
        return builder != null ? builder(context) : const SizedBox.shrink();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: curve))
            .animate(animation);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: duration,
    );
  }

  // Rotation transition for named routes
  static PageRouteBuilder<T> rotationNamed<T>(
      String routeName, {
        double turnsBegin = 0,
        double turnsEnd = 1,
        Alignment alignment = Alignment.center,
        Object? arguments,
        Duration duration = const Duration(milliseconds: 300),
      }) {
    return PageRouteBuilder<T>(
      settings: RouteSettings(name: routeName, arguments: arguments),
      pageBuilder: (context, animation, secondaryAnimation) {
        final builder = _getRouteBuilder(context, routeName);
        return builder != null ? builder(context) : const SizedBox.shrink();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: Tween(begin: turnsBegin, end: turnsEnd).animate(animation),
          alignment: alignment,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  // Scale transition for named routes
  static PageRouteBuilder<T> scaleNamed<T>(
      String routeName, {
        double scaleBegin = 0,
        double scaleEnd = 1,
        Alignment alignment = Alignment.center,
        Object? arguments,
        Duration duration = const Duration(milliseconds: 300),
      }) {
    return PageRouteBuilder<T>(
      settings: RouteSettings(name: routeName, arguments: arguments),
      pageBuilder: (context, animation, secondaryAnimation) {
        final builder = _getRouteBuilder(context, routeName);
        return builder != null ? builder(context) : const SizedBox.shrink();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween(begin: scaleBegin, end: scaleEnd).animate(animation),
          alignment: alignment,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  // Size transition for named routes
  static PageRouteBuilder<T> sizeNamed<T>(
      String routeName, {
        Axis axis = Axis.vertical,
        double axisAlignment = 0.0,
        Object? arguments,
        Duration duration = const Duration(milliseconds: 300),
      }) {
    return PageRouteBuilder<T>(
      settings: RouteSettings(name: routeName, arguments: arguments),
      pageBuilder: (context, animation, secondaryAnimation) {
        final builder = _getRouteBuilder(context, routeName);
        return builder != null ? builder(context) : const SizedBox.shrink();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SizeTransition(
          sizeFactor: animation,
          axis: axis,
          axisAlignment: axisAlignment,
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  // Fade transition for named routes
  static PageRouteBuilder<T> fadeNamed<T>(
      String routeName, {
        Object? arguments,
        Duration duration = const Duration(milliseconds: 300),
      }) {
    return PageRouteBuilder<T>(
      settings: RouteSettings(name: routeName, arguments: arguments),
      pageBuilder: (context, animation, secondaryAnimation) {
        final builder = _getRouteBuilder(context, routeName);
        return builder != null ? builder(context) : const SizedBox.shrink();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: duration,
    );
  }

  // Helper method to get the route builder for a named route
  static WidgetBuilder? _getRouteBuilder(BuildContext context, String routeName) {
    final appState = context.findAncestorWidgetOfExactType<MaterialApp>();
    return appState?.routes?[routeName];
  }

}

/// Slide transition: Moving the screen in from the side.
class QuickSlide extends QuickTransition {
  const QuickSlide(
      {this.start,
      this.end,
      this.animate,
      this.transformHitTests = false,
      this.textDirection,
      super.transitionDuration,
      super.reverseTransitionDuration,
      super.opaque,
      super.barrierDismissible,
      super.barrierColor,
      super.barrierLabel,
      super.maintainState,
      super.fullscreenDialog,
      super.allowSnapshotting});
  final Offset? start;
  final Offset? end;

  ///Default Value is: CurveTween(curve: Curves.easeInOut)
  final Animatable<double>? animate;
  final bool transformHitTests;
  final TextDirection? textDirection;
}

/// Rotate transition: Rotating the screen during the transition.
class QuickRotate extends QuickTransition {
  const QuickRotate(
      {this.turns,
      this.alignment,
      this.filterQuality,
      super.transitionDuration,
      super.reverseTransitionDuration,
      super.opaque,
      super.barrierDismissible,
      super.barrierColor,
      super.barrierLabel,
      super.maintainState,
      super.fullscreenDialog,
      super.allowSnapshotting});
  final Animation<double>? turns;
  final Alignment? alignment;
  final FilterQuality? filterQuality;
}

/// Scale transition: Scaling the screen during the transition.
class QuickScale extends QuickTransition {
  const QuickScale(
      {this.scale,
      this.alignment,
      this.filterQuality,
      super.transitionDuration,
      super.reverseTransitionDuration,
      super.opaque,
      super.barrierDismissible,
      super.barrierColor,
      super.barrierLabel,
      super.maintainState,
      super.fullscreenDialog,
      super.allowSnapshotting});

  final Animation<double>? scale;
  final Alignment? alignment;
  final FilterQuality? filterQuality;
}

/// Size transition: Changing the size of the screen during the transition.
class QuickSize extends QuickTransition {
  const QuickSize(
      {this.sizeFactor,
      this.fixedCrossAxisSizeFactor,
      this.axisAlignment,
      this.axis,
      super.transitionDuration,
      super.reverseTransitionDuration,
      super.opaque,
      super.barrierDismissible,
      super.barrierColor,
      super.barrierLabel,
      super.maintainState,
      super.fullscreenDialog,
      super.allowSnapshotting});
  final Axis? axis;
  final Animation<double>? sizeFactor;
  final double? axisAlignment;
  final double? fixedCrossAxisSizeFactor;
}

/// Fade transition: Changing the opacity of the screen during the transition.
class QuickFade extends QuickTransition {
  const QuickFade(
      {this.opacity,
      this.alwaysIncludeSemantics = false,
      super.transitionDuration,
      super.reverseTransitionDuration,
      super.opaque,
      super.barrierDismissible,
      super.barrierColor,
      super.barrierLabel,
      super.maintainState,
      super.fullscreenDialog,
      super.allowSnapshotting});
  final Animation<double>? opacity;
  final bool alwaysIncludeSemantics;
}
