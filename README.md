

## Features
The `QuickRouter` extension provides handy methods for navigating between routes
using Flutter's `Navigator`. It supports widget routes, named routes,
restorable routes, and transition helpers.

## Named routes

QuickRouter supports Flutter's current named-route APIs through `BuildContext`
extensions and `QuickNamedRoute` definitions.

### Available named-route methods

- `context.pushNamed(...)`
- `context.popAndPushNamed(...)`
- `context.pushReplacementNamed(...)`
- `context.pushNamedAndRemoveUntil(...)`
- `context.restorablePushNamed(...)`
- `context.restorablePopAndPushNamed(...)`
- `context.restorablePushReplacementNamed(...)`
- `context.restorablePushNamedAndRemoveUntil(...)`

### `QuickNamedRoute`

Use `QuickNamedRoute` to define a route name, its screen builder, and an
optional `QuickTransition`.

```dart
QuickNamedRoute(
  name: '/details',
  builder: (context, arguments) => DetailsScreen(
    message: arguments as String?,
  ),
  transitions: const QuickSlide(),
)
```

### Choose the right setup

| Use case | Setup |
| --- | --- |
| Simple named routes without custom transitions or arguments | `routes: QuickRouter.routes(...)` |
| Named routes with `QuickTransition` animations or route arguments | `onGenerateRoute: QuickRouter.onGenerateRoute(...)` |

Do **not** register the same route names in both `routes` and
`onGenerateRoute`. Flutter resolves `routes` first, so those entries will skip
the custom transition route builder.

### Recommended setup for transitions and arguments

```dart
final List<QuickNamedRoute> appRoutes = <QuickNamedRoute>[
  QuickNamedRoute(
    name: '/',
    builder: (context, arguments) => const HomeScreen(),
  ),
  QuickNamedRoute(
    name: '/second',
    builder: (context, arguments) => const SecondScreen(),
    transitions: const QuickFade(),
  ),
  QuickNamedRoute(
    name: '/third',
    builder: (context, arguments) => ThirdScreen(
      message: arguments as String?,
    ),
    transitions: const QuickSlide(),
  ),
];

MaterialApp(
  restorationScopeId: 'app',
  initialRoute: '/',
  onGenerateRoute: QuickRouter.onGenerateRoute(appRoutes),
);
```

### Simple named routes

```dart
MaterialApp(
  routes: QuickRouter.routes(<QuickNamedRoute>[
    QuickNamedRoute(
      name: '/',
      builder: (context, arguments) => const HomeScreen(),
    ),
    QuickNamedRoute(
      name: '/about',
      builder: (context, arguments) => const AboutScreen(),
    ),
  ]),
);
```

### Navigating to named routes

```dart
context.pushNamed('/second');

context.pushNamed(
  '/third',
  arguments: 'Hello from home',
);

context.pushReplacementNamed(
  '/third',
  arguments: 'Replacement message',
);

context.popAndPushNamed('/fourth');

context.pushNamedAndRemoveUntil(
  '/home',
  (route) => route.isFirst,
);
```

### Reading route arguments

Arguments passed with named routes are available in the `QuickNamedRoute`
builder as the second parameter.

```dart
QuickNamedRoute(
  name: '/profile',
  builder: (context, arguments) {
    final String? userId = arguments as String?;
    return ProfileScreen(userId: userId);
  },
)
```

### Restorable named routes

If your app uses state restoration, add a `restorationScopeId` to
`MaterialApp`, then use the restorable named-route helpers.

```dart
MaterialApp(
  restorationScopeId: 'app',
  onGenerateRoute: QuickRouter.onGenerateRoute(appRoutes),
);

context.restorablePushNamed('/details', arguments: 'payload');
context.restorablePopAndPushNamed('/details');
context.restorablePushReplacementNamed('/details');
context.restorablePushNamedAndRemoveUntil('/details', (route) => false);
```

### Named-route API summary

| Method | Description |
| --- | --- |
| `pushNamed` | Push a named route. |
| `popAndPushNamed` | Pop the current route, then push a named route. |
| `pushReplacementNamed` | Replace the current route with a named route. |
| `pushNamedAndRemoveUntil` | Push a named route and remove previous routes until the predicate returns `true`. |
| `restorablePushNamed` | Push a named route with state restoration support. |
| `restorablePopAndPushNamed` | Pop then push a restorable named route. |
| `restorablePushReplacementNamed` | Replace the current route with a restorable named route. |
| `restorablePushNamedAndRemoveUntil` | Push a restorable named route and clear previous routes until the predicate returns `true`. |


### context.to(NewScreen()) : 
This method pushes a new route to the Navigator with the given child widget and transition type. It returns a ```Future<T?>``` that completes when the pushed route is popped off the navigator.

For example: 
```dart
context.to(const SecondScreen())
```
will navigate to the second screen using the default fade transition.

### context.back(result):
 This method pops the current route from the Navigator and returns an optional result. The result can be of any type and it will be passed to the previous route.

  For example:
  ```dart
  context.back('Hello from second')
  ```
will return to the previous screen with the string result.



### context.pushReplacement(child, result) : 
This method pushes a new route to the Navigator with the given child widget and transition type, and replaces the current route with the new one. It also returns an optional result to the previous route. 

For example: 
```dart
context.pushReplacement(const ThirdScreen(), result: 'Hello from home')
```
 will replace the current screen with the third screen and pass the string result to the home screen.



#### context.pushAndRemoveUntil(child, predicate):
 This method pushes a new route to the ```Navigator``` with the given child widget and transition type, and removes all the previous routes until the predicate is satisfied. The predicate is a function that takes a route as an argument and returns a boolean value.
  For example: 
  ```dart
   context.pushAndRemoveUntil(const FourthScreen(), (route) => route.isFirst)
  ```
will remove all the routes except the first one and navigate to the fourth screen.



### context.restorablePushAndRemoveUntil(newRouteBuilder, predicate, arguments): 
This method pushes a new restorable route to the Navigator with the given route builder and arguments, and removes all the previous routes until the predicate is satisfied. It returns a restoration ID that can be used to restore the state of the route. The route builder is a function that takes a context and arguments as arguments and returns a route. 

For example:
 ```dart
 context.restorablePushAndRemoveUntil((context, arguments)
=> MaterialPageRoute(builder: (context)
 => const FifthScreen(),
 settings: const RouteSettings(name: '/fifth')),
 (route) => false, arguments: 'Some arguments')
 ```
 will remove all the routes and navigate to the fifth screen with restoration and arguments.



### context.replace(old, to): 
This method replaces the current route with a new one with the given child widget and transition type. It also preserves the type parameter of the current route.
 For example: 
 ```
 context.replace(old: this, to: const ThirdScreen())
 ```
  will replace the current screen with the third screen and keep the same result type.



### context.restorableReplace(old, to, arguments):
 This method replaces the current route with a new restorable route with the given route builder and arguments. It also preserves the type parameter of the current route and returns a restoration ID that can be used to restore the state of the route.
  For example:

 ```dart
  context.restorableReplace(old: this, to: (context, arguments) => MaterialPageRoute(builder: (context) => const FifthScreen(), settings: const RouteSettings(name: '/fifth')), arguments: 'Some arguments') 
 ```

  will replace the current screen with the fifth screen with restoration and arguments and keep the same result type.



### context.replaceRouteBelow(anchor, to): 
This method replaces the route below the current one with a new one with the given child widget and transition type. It also preserves the type parameter of the route below the current one.
 For example:
 ```dart 
 context.replaceRouteBelow(anchor: this, to: const FourthScreen())
```
  will replace the route below the current one with the fourth screen and keep the same result type.


# Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
