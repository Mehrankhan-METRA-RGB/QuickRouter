import 'package:flutter/widgets.dart';
import 'package:flutter_quick_router/quick_router.dart';

typedef QuickRouteWidgetBuilder = Widget Function(
  BuildContext context,
  Object? arguments,
);

/// Defines a named route that can be used with `MaterialApp.routes` or
/// `MaterialApp.onGenerateRoute`.
class QuickNamedRoute {
  const QuickNamedRoute({
    required this.name,
    required this.builder,
    this.transitions,
  });

  final String name;
  final QuickRouteWidgetBuilder builder;
  final QuickTransition? transitions;
}

class QuickRouter {
  static PageRouteBuilder<T> defaultTransition<T>(
    Widget child, {
    RouteSettings? settings,
  }) =>
      QuickTransition.fade<T>(
        child,
        settings: settings,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        opaque: true,
        barrierDismissible: false,
        maintainState: true,
        fullscreenDialog: false,
        allowSnapshotting: true,
      );

  static PageRouteBuilder<T> builder<T>(
    Widget child,
    QuickTransition? transitions, {
    RouteSettings? settings,
  }) {
    if (transitions == null) {
      return defaultTransition<T>(child, settings: settings);
    }

    return switch (transitions) {
      QuickSlide() => QuickTransition.slide<T>(child,
          settings: settings,
          end: transitions.end,
          begin: transitions.start,
          textDirection: transitions.textDirection,
          transformHitTests: transitions.transformHitTests,
          curve: transitions.animate,
          transitionDuration: transitions.transitionDuration,
          reverseTransitionDuration: transitions.reverseTransitionDuration,
          opaque: transitions.opaque,
          barrierDismissible: transitions.barrierDismissible,
          barrierColor: transitions.barrierColor,
          barrierLabel: transitions.barrierLabel,
          maintainState: transitions.maintainState,
          fullscreenDialog: transitions.fullscreenDialog,
          allowSnapshotting: transitions.allowSnapshotting),
      QuickRotate() => QuickTransition.rotation<T>(child,
          settings: settings,
          turns: transitions.turns,
          alignment: transitions.alignment,
          filterQuality: transitions.filterQuality,
          transitionDuration: transitions.transitionDuration,
          reverseTransitionDuration: transitions.reverseTransitionDuration,
          opaque: transitions.opaque,
          barrierDismissible: transitions.barrierDismissible,
          barrierColor: transitions.barrierColor,
          barrierLabel: transitions.barrierLabel,
          maintainState: transitions.maintainState,
          fullscreenDialog: transitions.fullscreenDialog,
          allowSnapshotting: transitions.allowSnapshotting),
      QuickScale() => QuickTransition.scale<T>(child,
          settings: settings,
          scale: transitions.scale,
          alignment: transitions.alignment,
          filterQuality: transitions.filterQuality,
          transitionDuration: transitions.transitionDuration,
          reverseTransitionDuration: transitions.reverseTransitionDuration,
          opaque: transitions.opaque,
          barrierDismissible: transitions.barrierDismissible,
          barrierColor: transitions.barrierColor,
          barrierLabel: transitions.barrierLabel,
          maintainState: transitions.maintainState,
          fullscreenDialog: transitions.fullscreenDialog,
          allowSnapshotting: transitions.allowSnapshotting),
      QuickSize() => QuickTransition.size<T>(child,
          settings: settings,
          axis: transitions.axis ?? Axis.vertical,
          sizeFactor: transitions.sizeFactor,
          axisAlignment: transitions.axisAlignment ?? 0.0,
          fixedCrossAxisSizeFactor: transitions.fixedCrossAxisSizeFactor,
          transitionDuration: transitions.transitionDuration,
          reverseTransitionDuration: transitions.reverseTransitionDuration,
          opaque: transitions.opaque,
          barrierDismissible: transitions.barrierDismissible,
          barrierColor: transitions.barrierColor,
          barrierLabel: transitions.barrierLabel,
          maintainState: transitions.maintainState,
          fullscreenDialog: transitions.fullscreenDialog,
          allowSnapshotting: transitions.allowSnapshotting),
      QuickFade() => QuickTransition.fade<T>(child,
          settings: settings,
          opacity: transitions.opacity,
          alwaysIncludeSemantics: transitions.alwaysIncludeSemantics,
          transitionDuration: transitions.transitionDuration,
          reverseTransitionDuration: transitions.reverseTransitionDuration,
          opaque: transitions.opaque,
          barrierDismissible: transitions.barrierDismissible,
          barrierColor: transitions.barrierColor,
          barrierLabel: transitions.barrierLabel,
          maintainState: transitions.maintainState,
          fullscreenDialog: transitions.fullscreenDialog,
          allowSnapshotting: transitions.allowSnapshotting),
    };
  }

  static Route<T> named<T extends Object?>(
    QuickNamedRoute route, {
    Object? arguments,
    RouteSettings? settings,
  }) {
    final RouteSettings routeSettings =
        settings ?? RouteSettings(name: route.name, arguments: arguments);

    return builder<T>(
      Builder(
        builder: (BuildContext context) =>
            route.builder(context, routeSettings.arguments),
      ),
      route.transitions,
      settings: routeSettings,
    );
  }

  static Map<String, WidgetBuilder> routes(Iterable<QuickNamedRoute> routes) {
    return <String, WidgetBuilder>{
      for (final QuickNamedRoute route in routes)
        route.name: (BuildContext context) => route.builder(context, null),
    };
  }

  static RouteFactory onGenerateRoute(Iterable<QuickNamedRoute> routes) {
    final Map<String, QuickNamedRoute> routesByName = <String, QuickNamedRoute>{
      for (final QuickNamedRoute route in routes) route.name: route,
    };

    return (RouteSettings settings) {
      final String? routeName = settings.name;
      if (routeName == null) {
        return null;
      }

      final QuickNamedRoute? route = routesByName[routeName];
      if (route == null) {
        return null;
      }

      return named<dynamic>(
        route,
        arguments: settings.arguments,
        settings: settings,
      );
    };
  }
}
