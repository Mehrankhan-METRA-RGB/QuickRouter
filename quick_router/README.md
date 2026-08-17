# flutter_quick_router

[![pub package](https://img.shields.io/pub/v/flutter_quick_router.svg)](https://pub.dev/packages/flutter_quick_router)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A lightweight `BuildContext` extension for the Flutter `Navigator` that removes
the boilerplate from pushing, replacing, and popping routes - with built-in,
ready-to-use page transitions (slide, fade, scale, rotate, size) that you can
drop onto any route with a single named parameter.

No `MaterialPageRoute` ceremony, no hand-rolled `PageRouteBuilder`s. Just:

```dart
context.to(const DetailsPage());
```

or, with a transition:

```dart
context.to(const DetailsPage(), transitions: const QuickSlide());
```

## Features

- **Simple, chainable navigation API** via a `BuildContext` extension -
  `context.to()`, `context.back()`, `context.pushReplacement()`, and more.
- **Five built-in transitions** - `QuickSlide`, `QuickRotate`, `QuickScale`,
  `QuickSize`, and `QuickFade` - each fully configurable, with `QuickFade`
  used as the sensible default when none is specified.
- **Full Navigator 1.0 coverage** - push, pop, replace, remove-until, and
  their *restorable* (state-restoration) counterparts are all supported.
- **Named routes** through `QuickNamedRoute` and `QuickRouter.onGenerateRoute`,
  so named navigation can still use custom transitions and typed arguments.
- **Zero dependencies** beyond Flutter itself - it's a thin, predictable
  layer over `Navigator`, not a replacement for it.
- 


 
  <img src="https://cdn.cyberbrox.com/packages/flutter_quick_routes.gif" alt="Flutter Quick Routes Demo" width="350">


## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_quick_router: ^1.0.0
```

Then import it wherever you navigate:

```dart
import 'package:flutter_quick_router/quick_router.dart';
```

## MaterialApp setup

For plain, unnamed navigation (`context.to()`, `context.back()`,
`context.pushReplacement()`, etc.) **no special `MaterialApp` setup is
required** - the extension methods call `Navigator.of(context)` directly, so
they work with any standard `MaterialApp` / `WidgetsApp` / `CupertinoApp`.

```dart
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}
```

Wiring is only needed if you use **named routes**, and it depends on whether
those named routes need a `QuickTransition`:

### Named routes without a custom transition

If your named routes don't need a `QuickTransition`, the plain
`MaterialApp.routes` map still works - no extra setup:

```dart
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const HomePage(),
    '/settings': (context) => const SettingsPage(),
  },
);
```

`context.pushNamed('/settings')` will work as normal.

### Named routes with a custom transition

If you want a named route to animate with `QuickSlide`, `QuickFade`, etc.,
define your routes as `QuickNamedRoute`s and register them with
`MaterialApp.onGenerateRoute` via `QuickRouter.onGenerateRoute`. This is
**required** for `QuickNamedRoute`'s `transitions` to take effect - routes
registered through `MaterialApp.routes` alone ignore it.

```dart
final List<QuickNamedRoute> appRoutes = [
  QuickNamedRoute(
    name: '/',
    builder: (context, arguments) => const HomePage(),
  ),
  QuickNamedRoute(
    name: '/details',
    builder: (context, arguments) => const DetailsPage(),
    transitions: const QuickSlide(),
  ),
  QuickNamedRoute(
    name: '/settings',
    builder: (context, arguments) => const SettingsPage(),
    transitions: const QuickFade(),
  ),
];

MaterialApp(
  initialRoute: '/',
  onGenerateRoute: QuickRouter.onGenerateRoute(appRoutes),
);
```

With this in place, `context.pushNamed('/details')`,
`context.pushReplacementNamed('/settings')`,
`context.pushNamedAndRemoveUntil('/', (route) => false)`, and their
restorable equivalents will all resolve through `appRoutes` and animate with
each route's configured `QuickTransition`.

> **Don't mix the two for the same route name.** Register each named
> route through either `MaterialApp.routes` *or*
> `MaterialApp.onGenerateRoute: QuickRouter.onGenerateRoute(...)`, not both -
> `onGenerateRoute` is only consulted when `routes` doesn't already resolve
> the name.

### State restoration (optional)

If you use the `restorable*` methods, your app also needs a
`restorationScopeId` on `MaterialApp` (standard Flutter requirement, not
specific to this package) and any restorable route builder must be a
top-level or static function annotated with `@pragma('vm:entry-point')`,
matching the `RestorableRouteBuilder` signature - see
`MyAppRoutes.myRestorableRouteBuilder` in the package source for an example:

```dart
MaterialApp(
  restorationScopeId: 'app',
  onGenerateRoute: QuickRouter.onGenerateRoute(appRoutes),
);
```

## Usage

### Push a route

Replace this:

```dart
Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => const DetailsPage()),
);
```

with this:

```dart
context.to(const DetailsPage());
```

### Push with a transition

Pick one of the five built-in transitions and pass it to `transitions:`.
Only one transition can be active per call.

```dart
// Slide in from the right
context.to(const DetailsPage(), transitions: const QuickSlide());

// Slide in from a custom offset with a custom curve
context.to(
  const DetailsPage(),
  transitions: QuickSlide(
    start: const Offset(0, 1), // enter from the bottom
    end: Offset.zero,
    animate: CurveTween(curve: Curves.easeOutCubic),
  ),
);

// Rotate in
context.to(const DetailsPage(), transitions: const QuickRotate());

// Scale in
context.to(const DetailsPage(), transitions: const QuickScale());

// Resize in
context.to(const DetailsPage(), transitions: const QuickSize());

// Fade in (this is also the default when `transitions` is omitted)
context.to(const DetailsPage(), transitions: const QuickFade());
```

Every transition class shares the same underlying `PageRoute` options -
`transitionDuration`, `reverseTransitionDuration`, `opaque`,
`barrierDismissible`, `barrierColor`, `barrierLabel`, `maintainState`,
`fullscreenDialog`, and `allowSnapshotting` - so you can fine-tune timing and
route behavior alongside the animation itself:

```dart
context.to(
  const DetailsPage(),
  transitions: const QuickFade(
    transitionDuration: Duration(milliseconds: 500),
    barrierDismissible: true,
    fullscreenDialog: true,
  ),
);
```

### Pop / go back

```dart
context.back(); // pop()
context.back('result'); // pop with a result
context.canPop(); // whether the current route can be popped
context.maybePop(); // pop if possible, returns a Future<bool>
```

### Replace routes

```dart
// Replace the current route
context.pushReplacement(const NewPage(), transitions: const QuickFade());

// Replace the route *below* the current one
context.replaceRouteBelow(
  anchor: const CurrentPage(),
  to: const NewBelowPage(),
);
```

### Push and remove until

Push a route and clear the stack beneath it - handy for “log out” or
“onboarding complete” flows:

```dart
context.pushAndRemoveUntil(
  const HomePage(),
  (route) => false, // remove everything below the new route
  transitions: const QuickFade(),
);
```

### Named routes

`QuickNamedRoute` lets named routes carry a `QuickTransition`, something the
standard `MaterialApp.routes` map can't express. Register your routes with
`onGenerateRoute` to unlock this:

```dart
final routes = <QuickNamedRoute>[
  QuickNamedRoute(
    name: '/details',
    builder: (context, arguments) => const DetailsPage(),
    transitions: const QuickSlide(),
  ),
  QuickNamedRoute(
    name: '/settings',
    builder: (context, arguments) => const SettingsPage(),
  ),
];

MaterialApp(
  onGenerateRoute: QuickRouter.onGenerateRoute(routes),
  // ...
);
```

Then navigate with the extension's named-route helpers:

```dart
context.pushNamed('/details', arguments: {'id': 42});
context.pushReplacementNamed('/settings');
context.popAndPushNamed('/details');
context.pushNamedAndRemoveUntil('/home', (route) => false);
```

> **Note:** If a named route doesn't need a custom `QuickTransition` or typed
> arguments, plain `MaterialApp.routes` still works fine - `onGenerateRoute`
> is only required when you want per-route transitions via `QuickNamedRoute`.

### Restorable routes

For screens that participate in Flutter's state restoration, every
restorable `Navigator` method has a matching extension method:

```dart
context.restorablePushNamed('/details', arguments: {'id': 42});
context.restorablePopAndPushNamed('/settings');
context.restorablePushReplacementNamed('/settings');
context.restorablePushNamedAndRemoveUntil('/home', (route) => false);
context.restorablePushAndRemoveUntil(
  MyAppRoutes.myRestorableRouteBuilder,
  (route) => false,
);
context.restorableReplace(
  old: const CurrentPage(),
  toBuilder: (context, arguments) => MaterialPageRoute(
    builder: (context) => const NewPage(),
  ),
);
context.restorableReplaceRouteBelow(
  anchor: const CurrentPage(),
  newRouteBuilder: MyAppRoutes.myRestorableRouteBuilder,
);
```

### Removing routes directly

```dart
context.removeRoute(someRoute);
context.removeRouteBelow(anchorRoute);
context.popUntil((route) => route.isFirst);
```

## API overview

| Method                                                  | Description                                |
|---------------------------------------------------------|--------------------------------------------|
| `to(child, {transitions})`                              | Push a new route                           |
| `pushNamed(name, {arguments})`                          | Push a named route                         |
| `back([result])`                                        | Pop the current route                      |
| `pushReplacement(child, {transitions, result})`         | Replace the current route                  |
| `popAndPushNamed(name, {result, arguments})`            | Pop then push a named route                |
| `pushReplacementNamed(name, {result, arguments})`       | Replace with a named route                 |
| `pushAndRemoveUntil(child, predicate, {transitions})`   | Push and clear the stack until `predicate` |
| `pushNamedAndRemoveUntil(name, predicate, {arguments})` | Named version of the above                 |
| `replace({old, to, transitions})`                       | Replace a specific route                   |
| `replaceRouteBelow({anchor, to, transitions})`          | Replace the route below a specific route   |
| `canPop()`                                              | Whether the current route can be popped    |
| `maybePop([result])`                                    | Pop if possible                            |
| `popUntil(predicate)`                                   | Pop routes until `predicate` is true       |
| `removeRoute(route)` / `removeRouteBelow(route)`        | Remove a route without popping             |
| `restorablePush*`, `restorableReplace*`                 | Restoration-aware equivalents of the above |

`QuickRouter` (the underlying route factory) also exposes static helpers if
you need them directly:

- `QuickRouter.builder(child, transitions)` - build a `PageRouteBuilder` for any widget.
- `QuickRouter.defaultTransition(child)` - the default fade transition used when none is passed.
- `QuickRouter.named(route, {arguments, settings})` - build a route from a `QuickNamedRoute`.
- `QuickRouter.routes(routes)` - build a `Map<String, WidgetBuilder>` for `MaterialApp.routes`.
- `QuickRouter.onGenerateRoute(routes)` - build a `RouteFactory` for `MaterialApp.onGenerateRoute`.

## Available transitions

| Class         | Effect                            | Key parameters                                                          |
|---------------|-----------------------------------|-------------------------------------------------------------------------|
| `QuickSlide`  | Slides the new screen in          | `start`, `end`, `animate` (curve), `transformHitTests`, `textDirection` |
| `QuickRotate` | Rotates the new screen in         | `turns`, `alignment`, `filterQuality`                                   |
| `QuickScale`  | Scales the new screen in          | `scale`, `alignment`, `filterQuality`                                   |
| `QuickSize`   | Resizes the new screen in         | `axis`, `sizeFactor`, `axisAlignment`, `fixedCrossAxisSizeFactor`       |
| `QuickFade`   | Fades the new screen in (default) | `opacity`, `alwaysIncludeSemantics`                                     |

All transitions also accept the shared `PageRoute` options listed above
(`transitionDuration`, `reverseTransitionDuration`, `opaque`,
`barrierDismissible`, `barrierColor`, `barrierLabel`, `maintainState`,
`fullscreenDialog`, `allowSnapshotting`).

## Why flutter_quick_router?

Flutter's `Navigator` API is powerful but verbose - every push means writing
a `MaterialPageRoute` or a full `PageRouteBuilder` if you want a custom
transition, and it's easy for that boilerplate to end up duplicated across a
codebase. `flutter_quick_router` keeps the exact same underlying `Navigator`
semantics (nothing is hidden or reinvented) while collapsing the call sites
down to one-liners, and gives you five ready-made transitions so you're not
reaching for a custom `PageRouteBuilder` for common cases.

## Additional information

Found a bug or want a feature? Please file an issue or open a pull request
on the [GitHub repository](https://github.com/Mehrankhan-METRA-RGB/QuickRouter.git).

Contributions are welcome - see `CONTRIBUTING.md` for guidelines before
submitting a pull request.

## License

This project is licensed under the MIT License - see the `LICENSE` file for
details.
