import 'package:flutter/widgets.dart';
import 'package:flutter_quick_router/quick_router.dart';

class QuickRouter {
  static PageRouteBuilder<T> builder<T>(
    Widget child,
    QuickTransition? transitions,
  ) {
    if (transitions == null) {
      return QuickTransition.fade<T>(
        child,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        opaque: true,
        barrierDismissible: false,
        maintainState: true,
        fullscreenDialog: false,
        allowSnapshotting: true,
      );
    }

    return switch (transitions) {
      QuickSlide() => QuickTransition.slide<T>(child,
          end: transitions.end,
          begin: transitions.start,
          textDirection: transitions.textDirection,
          transformHitTests: transitions.transformHitTests,
          curve: transitions.animate,
          transitionDuration: transitions.transitionDuration,
          reverseTransitionDuration: transitions.transitionDuration,
          opaque: transitions.opaque,
          barrierDismissible: transitions.barrierDismissible,
          barrierColor: transitions.barrierColor,
          barrierLabel: transitions.barrierLabel,
          maintainState: transitions.maintainState,
          fullscreenDialog: transitions.fullscreenDialog,
          allowSnapshotting: transitions.allowSnapshotting),
      QuickRotate() => QuickTransition.rotation<T>(child,
          turns: transitions.turns,
          alignment: transitions.alignment,
          filterQuality: transitions.filterQuality,
          transitionDuration: transitions.transitionDuration,
          reverseTransitionDuration: transitions.transitionDuration,
          opaque: transitions.opaque,
          barrierDismissible: transitions.barrierDismissible,
          barrierColor: transitions.barrierColor,
          barrierLabel: transitions.barrierLabel,
          maintainState: transitions.maintainState,
          fullscreenDialog: transitions.fullscreenDialog,
          allowSnapshotting: transitions.allowSnapshotting),
      QuickScale() => QuickTransition.scale<T>(child,
          scale: transitions.scale,
          alignment: transitions.alignment,
          filterQuality: transitions.filterQuality,
          transitionDuration: transitions.transitionDuration,
          reverseTransitionDuration: transitions.transitionDuration,
          opaque: transitions.opaque,
          barrierDismissible: transitions.barrierDismissible,
          barrierColor: transitions.barrierColor,
          barrierLabel: transitions.barrierLabel,
          maintainState: transitions.maintainState,
          fullscreenDialog: transitions.fullscreenDialog,
          allowSnapshotting: transitions.allowSnapshotting),
      QuickSize() => QuickTransition.size<T>(child,
          axis: transitions.axis ?? Axis.vertical,
          sizeFactor: transitions.sizeFactor,
          axisAlignment: transitions.axisAlignment ?? 0.0,
          fixedCrossAxisSizeFactor: transitions.fixedCrossAxisSizeFactor,
          transitionDuration: transitions.transitionDuration,
          reverseTransitionDuration: transitions.transitionDuration,
          opaque: transitions.opaque,
          barrierDismissible: transitions.barrierDismissible,
          barrierColor: transitions.barrierColor,
          barrierLabel: transitions.barrierLabel,
          maintainState: transitions.maintainState,
          fullscreenDialog: transitions.fullscreenDialog,
          allowSnapshotting: transitions.allowSnapshotting),
      QuickFade() => QuickTransition.fade<T>(child,
          opacity: transitions.opacity,
          alwaysIncludeSemantics: transitions.alwaysIncludeSemantics,
          transitionDuration: transitions.transitionDuration,
          reverseTransitionDuration: transitions.transitionDuration,
          opaque: transitions.opaque,
          barrierDismissible: transitions.barrierDismissible,
          barrierColor: transitions.barrierColor,
          barrierLabel: transitions.barrierLabel,
          maintainState: transitions.maintainState,
          fullscreenDialog: transitions.fullscreenDialog,
          allowSnapshotting: transitions.allowSnapshotting),
    };
  }


  // Updated builderNamed method for named routes with transitions
  static PageRouteBuilder<T> builderNamed<T>(
      String routeName,
      QuickTransition? transitions, {
        Object? arguments,
      }) {
    if (transitions is QuickSlide) {
      return QuickTransition.slideNamed<T>(
        routeName,
        begin: transitions.start ?? const Offset(1.0, 0.0),
        end: transitions.end ?? Offset.zero,
        curve:  Curves.easeInOut,
        arguments: arguments,
      );
    } else if (transitions is QuickRotate) {
      return QuickTransition.rotationNamed<T>(
        routeName,
        turnsBegin: transitions.turns?.value ?? 0,
        turnsEnd: 1,
        alignment: transitions.alignment ?? Alignment.center,
        arguments: arguments,
      );
    } else if (transitions is QuickScale) {
      return QuickTransition.scaleNamed<T>(
        routeName,
        scaleBegin: 0,
        scaleEnd: 1,
        alignment: transitions.alignment ?? Alignment.center,
        arguments: arguments,
      );
    } else if (transitions is QuickSize) {
      return QuickTransition.sizeNamed<T>(
        routeName,
        axis: transitions.axis ?? Axis.vertical,
        axisAlignment: transitions.axisAlignment ?? 0.0,
        arguments: arguments,
      );
    } else {
      // Default to fade if no transition is specified
      return QuickTransition.fadeNamed<T>(
        routeName,
        arguments: arguments,
      );
    }
  }
}
