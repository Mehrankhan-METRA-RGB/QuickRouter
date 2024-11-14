import 'package:flutter/material.dart';
import 'package:flutter_quick_router/Routers/router_builders.dart';
import 'package:flutter_quick_router/quick_router.dart';

/// An extension that provides some handy methods for navigating between routes
/// using the Navigator widget. It supports both regular and restorable routes,
/// as well as different transition types.
extension QuickRouters on BuildContext {
  /// A method that pushes a new route to the Navigator with the given child widget
  /// and transition type.
  /// Defines the available transition options for animations.
  /// Only one transition can be selected at a time.
  ///
  /// Available transitions:
  /// - [QuickSlide]: Quickly slides the content.
  /// - [QuickRotate]: Rapidly rotates the content.
  /// - [QuickScale]: Swiftly scales the content.
  /// - [QuickSize]: Rapidly resizes the content.
  /// - [QuickFade]: Swiftly fades the content.
  ///
  /// The default transition is [QuickFade].
  Future<T?> to<T extends Object?>(
    Widget child, {
    QuickTransition? transitions,
  }) {
    return Navigator.of(this).push(QuickRouter.builder(child, transitions));
  }

  /// A method that pops the current route and returns an optional result to the
  /// previous route.
  void back<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }

  /// A method that pushes a new route to the Navigator with the given child widget
  /// and transition type, and replaces the current route with the new one.
  /// It also returns an optional result to the previous route.
  ///
  /// Defines the available transition options for animations.
  /// Only one transition can be selected at a time.
  ///
  /// Available transitions:
  /// - [QuickSlide]: Quickly slides the content.
  /// - [QuickRotate]: Rapidly rotates the content.
  /// - [QuickScale]: Swiftly scales the content.
  /// - [QuickSize]: Rapidly resizes the content.
  /// - [QuickFade]: Swiftly fades the content.
  ///
  /// The default transition is [QuickFade].

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
      Widget child,
      {QuickTransition? transitions,
      TO? result}) {
    return Navigator.of(this).pushReplacement<T, TO>(
        QuickRouter.builder(child, transitions),
        result: result);
  }

  /// A method that pushes a new route to the Navigator with the given child widget
  /// and transition type, and removes all the previous routes until the predicate
  /// is satisfied.
  ///
  /// Defines the available transition options for animations.
  /// Only one transition can be selected at a time.
  ///
  /// Available transitions:
  /// - [QuickSlide]: Quickly slides the content.
  /// - [QuickRotate]: Rapidly rotates the content.
  /// - [QuickScale]: Swiftly scales the content.
  /// - [QuickSize]: Rapidly resizes the content.
  /// - [QuickFade]: Swiftly fades the content.
  ///
  /// The default transition is [QuickFade].
  Future<T?> pushAndRemoveUntil<T extends Object?>(
    Widget child,
    RoutePredicate predicate, {
    QuickTransition? transitions,
  }) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
        QuickRouter.builder(child, transitions), predicate);
  }

  /// A method that pushes a new restorable route to the Navigator with the given
  /// route builder and arguments, and removes all the previous routes until the
  /// predicate is satisfied. It returns a restoration ID that can be used to
  /// restore the state of the route.
  ///
  /// - Parameters:
  ///   - `newRouteBuilder`: A `RestorableRouteBuilder<T>` function that creates the route to be pushed.
  ///   - `predicate`: A `RoutePredicate` to determine when to stop removing routes.
  ///   - `arguments`: Optional arguments to pass to the new route.
  ///
  /// The `predicate` may be applied to the same route more than once if `Route.willHandlePopInternally` is true.
  /// To remove routes until a route with a certain name, use the `RoutePredicate` returned from `ModalRoute.withName`.
  /// To remove all the routes below the pushed route, use a `RoutePredicate` that always returns false.
  ///
  /// The removed routes are removed without being completed, so this method does not take a return value argument.
  /// The newly pushed route and its preceding route are notified for `Route.didPush`.
  /// After removal, the new route and its new preceding route are notified through `Route.didChangeNext`.
  ///
  /// - Returns: An opaque ID for the pushed route that can be used by the `RestorableRouteFuture`
  ///   to gain access to the actual `Route` object added to the navigator and its return value.
  ///
  /// Example usage:
  /// ```dart
  /// context.restorablePushAndRemoveUntil(
  ///   (BuildContext context) => MaterialPageRoute(builder: (BuildContext context) => YourNewPage()),
  ///   (Route<dynamic> route) => false, // This will remove all routes below the new route
  ///   arguments: <String, String>{
  ///     'key': 'value',
  ///   },
  /// );
  /// ```

  String restorablePushAndRemoveUntil<T extends Object?>(
      RestorableRouteBuilder<T> newRouteBuilder, RoutePredicate predicate,
      {Object? arguments}) {
    return Navigator.of(this).restorablePushAndRemoveUntil<T>(
        newRouteBuilder, predicate,
        arguments: arguments);
  }

  /// A method that replaces the current route with a new one with the given child
  /// widget and transition type. It also preserves the type parameter of the
  /// current route.
  ///
  /// Defines the available transition options for animations.
  /// Only one transition can be selected at a time.
  ///
  /// Available transitions:
  /// - [QuickSlide]: Quickly slides the content.
  /// - [QuickRotate]: Rapidly rotates the content.
  /// - [QuickScale]: Swiftly scales the content.
  /// - [QuickSize]: Rapidly resizes the content.
  /// - [QuickFade]: Swiftly fades the content.
  ///
  /// The default transition is [QuickFade].
  @optionalTypeArgs
  void replace<T extends Object?>(
      {required Widget old, required Widget to, QuickTransition? transitions}) {
    return Navigator.of(this).replace<T>(
        oldRoute: QuickRouter.builder(old, transitions),
        newRoute: QuickRouter.builder(old, transitions));
  }

  /// A method that replaces the current route with a new restorable route with
  /// the given route builder and arguments. It also preserves the type parameter
  /// of the current route and returns a restoration ID that can be used to
  /// restore the state of the route.
  ///
  /// Defines the available transition options for animations.
  /// Only one transition can be selected at a time.
  ///
  /// Available transitions:
  /// - [QuickSlide]: Quickly slides the content.
  /// - [QuickRotate]: Rapidly rotates the content.
  /// - [QuickScale]: Swiftly scales the content.
  /// - [QuickSize]: Rapidly resizes the content.
  /// - [QuickFade]: Swiftly fades the content.
  ///
  /// The default transition is [QuickFade].
  String restorableReplace<T extends Object?>(
      {required Widget old,
      required RestorableRouteBuilder<T> to,
      QuickTransition? transitions,
      Object? arguments}) {
    return Navigator.of(this).restorableReplace<T>(
        oldRoute: QuickRouter.builder(old, transitions),
        newRouteBuilder: to,
        arguments: arguments);
  }

  /// A method that replaces the route below the current one with a new one with
  /// the given child widget and transition type. It also preserves the type
  /// parameter of the route below the current one.
  ///
  /// Defines the available transition options for animations.
  /// Only one transition can be selected at a time.
  ///
  /// Available transitions:
  /// - [QuickSlide]: Quickly slides the content.
  /// - [QuickRotate]: Rapidly rotates the content.
  /// - [QuickScale]: Swiftly scales the content.
  /// - [QuickSize]: Rapidly resizes the content.
  /// - [QuickFade]: Swiftly fades the content.
  ///
  /// The default transition is [QuickFade].
  void replaceRouteBelow<T extends Object?>({
    required Widget anchor,
    required Widget to,
    QuickTransition? transitions,
  }) {
    return Navigator.of(this).replaceRouteBelow<T>(
      anchorRoute: QuickRouter.builder(anchor, transitions),
      newRoute: QuickRouter.builder<T>(to, transitions),
    );
  }

  /// A method that replaces the route below the current one with a new restorable
  /// route with the given route builder and arguments. It also preserves the type
  /// parameter of the route below the current one and returns a restoration ID
  /// that can be used to restore the state of the route.
  ///
  /// Defines the available transition options for animations.
  /// Only one transition can be selected at a time.
  ///
  /// Available transitions:
  /// - [QuickSlide]: Quickly slides the content.
  /// - [QuickRotate]: Rapidly rotates the content.
  /// - [QuickScale]: Swiftly scales the content.
  /// - [QuickSize]: Rapidly resizes the content.
  /// - [QuickFade]: Swiftly fades the content.
  ///
  /// The default transition is [QuickFade].
  String restorableReplaceRouteBelow<T extends Object?>({
    required Widget anchor,
    required RestorableRouteBuilder<T> newRouteBuilder,
    Object? arguments,
    QuickTransition? transitions,
  }) {
    return Navigator.of(this).restorableReplaceRouteBelow<T>(
        anchorRoute: QuickRouter.builder(anchor, transitions),
        newRouteBuilder: newRouteBuilder,
        arguments: arguments);
  }

  /// A method that returns true if the Navigator can pop the current route.
  bool canPop() {
    final NavigatorState? navigator = Navigator.maybeOf(this);
    return navigator != null && navigator.canPop();
  }

  /// A method that tries to pop the current route and returns a future that
  /// completes with true if the pop succeeded, and false otherwise. It also
  /// returns an optional result to the previous route.
  Future<bool> maybePop<T extends Object?>([T? result]) {
    return Navigator.of(this).maybePop<T>(result);
  }

  /// A method that pops all the routes until the predicate is satisfied.
  void popUntil(bool Function(Route<dynamic> route) predicate) {
    Navigator.of(this).popUntil(predicate);
  }

  /// A method that removes the given route from the Navigator.
  void removeRoute(Route<dynamic> route) {
    return Navigator.of(this).removeRoute(route);
  }

  /// A method that removes the route below the given one from the Navigator.
  void removeRouteBelow(Route<dynamic> anchorRoute) {
    return Navigator.of(this).removeRouteBelow(anchorRoute);
  }
  /// Navigate to a new named route with a specified transition.
  Future<T?> toNamed<T extends Object?>(
      String routeName, {
        Object? arguments,
        QuickTransition? transitions,
      }) {
    return Navigator.of(this).push(
      QuickRouter.builderNamed(routeName, transitions, arguments: arguments),
    );
  }

  /// Replace the current route with a new named route.
  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      String routeName, {
        TO? result,
        Object? arguments,
        QuickTransition? transitions,
      }) {
    return Navigator.of(this).pushReplacement(
      QuickRouter.builderNamed(routeName, transitions, arguments: arguments),
      result: result,
    );
  }

  /// Remove all previous routes and push a new named route.
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
      String routeName,
      RoutePredicate predicate, {
        Object? arguments,
        QuickTransition? transitions,
      }) {
    return Navigator.of(this).pushAndRemoveUntil(
      QuickRouter.builderNamed(routeName, transitions, arguments: arguments),
      predicate,
    );
  }


}
