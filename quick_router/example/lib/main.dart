// Example app for `flutter_quick_router`.
//
// This app wires up every screen through `MaterialApp.onGenerateRoute` via
// `QuickRouter.onGenerateRoute`, then exercises (almost) every extension
// method on `BuildContext` that the package provides.
//
// All five built-in transitions (`QuickFade`, `QuickSlide`, `QuickScale`,
// `QuickRotate`, `QuickSize`) are used TWICE each: once on a *named* route
// (registered in `appRoutes` below, so it's reused every time that route
// name is pushed) and once on a *normal* / unnamed push (passed inline to
// `context.to()`, `pushReplacement()`, `pushAndRemoveUntil()`, or a manual
// `QuickRouter.builder()` call), each time with different constructor
// parameters to show how each transition can be tuned. Each transition also
// gets its own accent color + icon (see `fadeStyle`, `slideStyle`, etc.
// below) purely for visual polish — that part has nothing to do with the
// package itself.
//
//   Transition   | Named route     | Unnamed / normal push
//   ------------ | ---------------- | -----------------------------------
//   QuickFade    | FadeScreen       | temporary auto-removed toast route
//   QuickSlide   | SlideScreen      | Home -> UnnamedDetailScreen (slide up)
//   QuickScale   | ScaleScreen      | RotateScreen -> UnnamedDetailScreen
//   QuickRotate  | RotateScreen     | Home -> pushAndRemoveUntil()
//   QuickSize    | SizeScreen       | ScaleScreen -> pushReplacement()
//
// (The restorable custom-route-builder demo and the Login -> Dashboard
// flow both omit `transitions` entirely, showing that `context.to()` and
// friends fall back to `QuickFade` by default when no transition is given.)
//
// NOT demonstrated here: `replace()`, `restorableReplace()`,
// `replaceRouteBelow()`, and `restorableReplaceRouteBelow()`. As currently
// implemented, these build a brand-new route for `old`/`anchor` instead of
// reusing the route object that is actually in the Navigator's history, so
// `Navigator` cannot find a match and throws an assertion error at runtime.
// (`replace()` also passes `old` instead of `to` when building the
// replacement route, so it would show the wrong screen even if the lookup
// succeeded.) Avoid these four methods until that's fixed upstream.
import 'package:flutter/material.dart';
import 'package:flutter_quick_router/Routers/router_builders.dart';
import 'package:flutter_quick_router/quick_router.dart';

// -----------------------------------------------------------------------
// Visual theme for each transition. Purely cosmetic — maps a transition
// name to an accent color + icon so every screen that uses it (named or
// unnamed) looks consistent.
// -----------------------------------------------------------------------

class TransitionStyle {
  const TransitionStyle(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}

const TransitionStyle fadeStyle =
    TransitionStyle('Fade', Icons.blur_on_rounded, Color(0xFFEF6C00));
const TransitionStyle slideStyle =
    TransitionStyle('Slide', Icons.swipe_rounded, Color(0xFF1E88E5));
const TransitionStyle scaleStyle =
    TransitionStyle('Scale', Icons.zoom_out_map_rounded, Color(0xFF00897B));
const TransitionStyle rotateStyle =
    TransitionStyle('Rotate', Icons.rotate_right_rounded, Color(0xFFD81B60));
const TransitionStyle sizeStyle =
    TransitionStyle('Size', Icons.unfold_more_rounded, Color(0xFF5E35B1));
const TransitionStyle authStyle =
    TransitionStyle('Auth flow', Icons.lock_person_rounded, Color(0xFF2E7D32));

final List<QuickNamedRoute> appRoutes = <QuickNamedRoute>[
  QuickNamedRoute(
    name: HomeScreen.routeName,
    builder: (context, arguments) => const HomeScreen(),
  ),
  QuickNamedRoute(
    name: FadeScreen.routeName,
    builder: (context, arguments) => const FadeScreen(),
    transitions: const QuickFade(),
  ),
  QuickNamedRoute(
    name: SlideScreen.routeName,
    builder: (context, arguments) => SlideScreen(message: arguments as String?),
    transitions: const QuickSlide(),
  ),
  QuickNamedRoute(
    name: ScaleScreen.routeName,
    builder: (context, arguments) => const ScaleScreen(),
    transitions: const QuickScale(),
  ),
  QuickNamedRoute(
    name: RotateScreen.routeName,
    builder: (context, arguments) =>
        RotateScreen(message: arguments as String?),
    transitions: const QuickRotate(),
  ),
  QuickNamedRoute(
    name: SizeScreen.routeName,
    builder: (context, arguments) => const SizeScreen(),
    transitions: const QuickSize(),
  ),
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme =
        ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4));

    return MaterialApp(
      title: 'Quick Router',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF5F3FA),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: scheme.surfaceContainerHighest,
          labelStyle: TextStyle(
              color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          shape: const StadiumBorder(),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      restorationScopeId: 'quick_router_example',
      initialRoute: HomeScreen.routeName,
      // Required for QuickNamedRoute.transitions to take effect.
      onGenerateRoute: QuickRouter.onGenerateRoute(appRoutes),
    );
  }
}

/// Route builder used with `restorablePushAndRemoveUntil`. Restorable route
/// builders must be top-level or static functions annotated with
/// `@pragma('vm:entry-point')` so they survive tree-shaking / AOT builds.
class AppRouteBuilders {
  @pragma('vm:entry-point')
  static Route<Object?> unnamedDetailRouteBuilder(
    BuildContext context,
    Object? arguments,
  ) {
    return QuickRouter.builder<Object?>(
      UnnamedDetailScreen(
        title: 'Restorable detail screen',
        subtitle:
            arguments as String? ?? 'Pushed via restorablePushAndRemoveUntil',
        style: fadeStyle,
      ),
      // Passing `null` here falls back to QuickRouter's default transition,
      // which is a QuickFade().
      null,
    );
  }
}

// ---------------------------------------------------------------------------
// Home screen: unnamed navigation, "remove until", and restorable pushes.
// ---------------------------------------------------------------------------

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: scheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Quick Router',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [scheme.primary, scheme.tertiary],
                  ),
                ),
                child: const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8, bottom: 56),
                    child: Icon(Icons.route_rounded,
                        size: 90, color: Colors.white24),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
            sliver: SliverList.list(
              children: [
                const Text(
                  'Tap around to try every navigation method the package '
                  'ships with, each paired with a distinctly styled transition.',
                  style: TextStyle(color: Colors.black54, height: 1.4),
                ),
                const SizedBox(height: 20),
                _SectionCard(
                  icon: Icons.label_rounded,
                  iconColor: scheme.primary,
                  title: 'Named navigation',
                  subtitle:
                      'Routes registered in appRoutes via onGenerateRoute',
                  children: [
                    _DemoButton(
                      icon: fadeStyle.icon,
                      color: fadeStyle.color,
                      label: 'Push named fade screen',
                      onPressed: () => context.pushNamed(FadeScreen.routeName),
                    ),
                    _DemoButton(
                      icon: rotateStyle.icon,
                      color: rotateStyle.color,
                      label: 'Push named rotate screen (restorable)',
                      onPressed: () => context.restorablePushNamed(
                        RotateScreen.routeName,
                        arguments: 'Pushed via restorablePushNamed',
                      ),
                    ),
                    _DemoButton(
                      icon: slideStyle.icon,
                      color: slideStyle.color,
                      label:
                          'Push named slide, dropping this stack (restorable)',
                      onPressed: () =>
                          context.restorablePushNamedAndRemoveUntil(
                        SlideScreen.routeName,
                        (route) => false,
                        arguments:
                            'Pushed via restorablePushNamedAndRemoveUntil',
                      ),
                    ),
                    _DemoButton(
                      icon: sizeStyle.icon,
                      color: sizeStyle.color,
                      label: 'Push named size, keep only Home below it',
                      onPressed: () => context.pushNamedAndRemoveUntil(
                        SizeScreen.routeName,
                        (route) => route.isFirst,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  icon: Icons.widgets_rounded,
                  iconColor: scheme.tertiary,
                  title: 'Unnamed navigation',
                  subtitle: 'Widgets pushed directly — no route name required',
                  children: [
                    _DemoButton(
                      icon: slideStyle.icon,
                      color: slideStyle.color,
                      label: 'context.to() an unnamed screen (Slide)',
                      onPressed: () => context.to(
                        const UnnamedDetailScreen(
                          title: 'Unnamed detail screen',
                          subtitle:
                              'Pushed directly with context.to(), no named route required.',
                          style: slideStyle,
                        ),
                        transitions: const QuickSlide(start: Offset(0, 1)),
                      ),
                    ),
                    _DemoButton(
                      icon: rotateStyle.icon,
                      color: rotateStyle.color,
                      label: 'pushAndRemoveUntil() an unnamed screen (Rotate)',
                      onPressed: () => context.pushAndRemoveUntil(
                        const UnnamedDetailScreen(
                          title: 'Unnamed detail screen',
                          subtitle: 'The whole stack below it was cleared.',
                          style: rotateStyle,
                        ),
                        (route) => false,
                        transitions: const QuickRotate(),
                      ),
                    ),
                    _DemoButton(
                      icon: Icons.restore_rounded,
                      color: scheme.secondary,
                      label:
                          'Restorable push & remove until (custom builder, default Fade)',
                      onPressed: () => context.restorablePushAndRemoveUntil(
                        AppRouteBuilders.unnamedDetailRouteBuilder,
                        (route) => false,
                        arguments: 'Pushed via restorablePushAndRemoveUntil',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  icon: Icons.layers_clear_rounded,
                  iconColor: fadeStyle.color,
                  title: 'removeRoute()',
                  subtitle:
                      'Drops a route from history directly, without popping',
                  children: [
                    _DemoButton(
                      icon: Icons.timer_outlined,
                      color: fadeStyle.color,
                      label:
                          'Push a temporary screen that removes itself after 2s',
                      onPressed: () {
                        // removeRoute() needs the actual Route object, which
                        // context.to() does not expose. Build and push it
                        // manually with QuickRouter.builder() to keep a
                        // reference.
                        final Route<void> tempRoute = QuickRouter.builder<void>(
                          const UnnamedDetailScreen(
                            title: 'Temporary screen',
                            subtitle:
                                'This route calls context.removeRoute() on itself '
                                'after 2 seconds \u2014 no back button needed.',
                            style: fadeStyle,
                          ),
                          const QuickFade(),
                        );
                        Navigator.of(context).push(tempRoute);
                        Future.delayed(const Duration(seconds: 2), () {
                          if (context.mounted) {
                            context.removeRoute(tempRoute);
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  icon: Icons.vertical_align_bottom_rounded,
                  iconColor: authStyle.color,
                  title: 'removeRouteBelow()',
                  subtitle:
                      'A realistic login flow that drops itself from history',
                  children: [
                    _DemoButton(
                      icon: authStyle.icon,
                      color: authStyle.color,
                      label: 'Login \u2192 Dashboard flow',
                      onPressed: () => context.to(const LoginDemoScreen()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Fade screen: back(), pushReplacementNamed(), popAndPushNamed(), maybePop().
// ---------------------------------------------------------------------------

class FadeScreen extends StatelessWidget {
  static const String routeName = '/fade';

  const FadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _TransitionScaffold(
      style: fadeStyle,
      title: 'Fade Screen',
      description: 'Registered as a named route with QuickFade().',
      children: [
        _CanPopBadge(canPop: context.canPop()),
        const SizedBox(height: 20),
        _DemoButton(
          icon: Icons.arrow_back_rounded,
          color: fadeStyle.color,
          label: 'Go back with a result',
          onPressed: () => context.back('Hello from FadeScreen'),
        ),
        _DemoButton(
          icon: slideStyle.icon,
          color: slideStyle.color,
          label: 'Replace with named slide screen',
          onPressed: () => context.pushReplacementNamed(
            SlideScreen.routeName,
            arguments: 'Hello from FadeScreen',
          ),
        ),
        _DemoButton(
          icon: scaleStyle.icon,
          color: scaleStyle.color,
          label: 'Pop and push named scale screen',
          onPressed: () => context.popAndPushNamed(ScaleScreen.routeName),
        ),
        _DemoButton(
          icon: Icons.exit_to_app_rounded,
          color: fadeStyle.color,
          label: 'maybePop()',
          onPressed: () async {
            final bool popped = await context.maybePop('Hello from FadeScreen');
            if (!popped && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nothing left to pop.')),
              );
            }
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Slide screen: reads arguments, restorable replace/pop-and-push.
// ---------------------------------------------------------------------------

class SlideScreen extends StatelessWidget {
  static const String routeName = '/slide';

  const SlideScreen({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return _TransitionScaffold(
      style: slideStyle,
      title: 'Slide Screen',
      description: 'Registered as a named route with QuickSlide().',
      children: [
        if (message != null) ...[
          _MessageBanner(message: message!, color: slideStyle.color),
          const SizedBox(height: 20),
        ],
        _DemoButton(
          icon: Icons.home_rounded,
          color: slideStyle.color,
          label: 'Push named home screen',
          onPressed: () => context.pushNamed(HomeScreen.routeName),
        ),
        _DemoButton(
          icon: rotateStyle.icon,
          color: rotateStyle.color,
          label: 'Replace with named rotate screen (restorable)',
          onPressed: () => context.restorablePushReplacementNamed(
            RotateScreen.routeName,
            arguments: 'Hello from SlideScreen',
          ),
        ),
        _DemoButton(
          icon: sizeStyle.icon,
          color: sizeStyle.color,
          label: 'Pop and push named size screen (restorable)',
          onPressed: () =>
              context.restorablePopAndPushNamed(SizeScreen.routeName),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Scale screen: pushReplacement() with an unnamed widget, popUntil().
// ---------------------------------------------------------------------------

class ScaleScreen extends StatelessWidget {
  static const String routeName = '/scale';

  const ScaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _TransitionScaffold(
      style: scaleStyle,
      title: 'Scale Screen',
      description: 'Registered as a named route with QuickScale().',
      children: [
        _DemoButton(
          icon: Icons.arrow_back_rounded,
          color: scaleStyle.color,
          label: 'Go back with a result',
          onPressed: () => context.back('Hello from ScaleScreen'),
        ),
        _DemoButton(
          icon: sizeStyle.icon,
          color: sizeStyle.color,
          label: 'Replace with an unnamed screen (pushReplacement, Size)',
          onPressed: () => context.pushReplacement(
            const UnnamedDetailScreen(
              title: 'Unnamed detail screen',
              subtitle: 'Reached via context.pushReplacement() with a '
                  'horizontal QuickSize transition.',
              style: sizeStyle,
            ),
            transitions:
                const QuickSize(axis: Axis.horizontal, axisAlignment: -1.0),
          ),
        ),
        _DemoButton(
          icon: Icons.first_page_rounded,
          color: scaleStyle.color,
          label: 'Pop back to the first route (popUntil)',
          onPressed: () => context.popUntil((route) => route.isFirst),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Rotate screen: reads arguments, context.to() with the QuickScale transition.
// ---------------------------------------------------------------------------

class RotateScreen extends StatelessWidget {
  static const String routeName = '/rotate';

  const RotateScreen({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return _TransitionScaffold(
      style: rotateStyle,
      title: 'Rotate Screen',
      description: 'Registered as a named route with QuickRotate().',
      children: [
        if (message != null) ...[
          _MessageBanner(message: message!, color: rotateStyle.color),
          const SizedBox(height: 20),
        ],
        _DemoButton(
          icon: Icons.arrow_back_rounded,
          color: rotateStyle.color,
          label: 'Go back with a result',
          onPressed: () => context.back('Hello from RotateScreen'),
        ),
        _DemoButton(
          icon: scaleStyle.icon,
          color: scaleStyle.color,
          label: 'context.to() an unnamed screen (Scale)',
          onPressed: () => context.to(
            const UnnamedDetailScreen(
              title: 'Unnamed detail screen',
              subtitle: 'Reached via context.to() with a QuickScale '
                  'transition anchored to the top-right corner.',
              style: scaleStyle,
            ),
            transitions: const QuickScale(alignment: Alignment.topRight),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Size screen: just showcases the QuickSize transition + canPop().
// ---------------------------------------------------------------------------

class SizeScreen extends StatelessWidget {
  static const String routeName = '/size';

  const SizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _TransitionScaffold(
      style: sizeStyle,
      title: 'Size Screen',
      description: 'Registered as a named route with QuickSize().',
      children: [
        _CanPopBadge(canPop: context.canPop()),
        const SizedBox(height: 20),
        _DemoButton(
          icon: Icons.arrow_back_rounded,
          color: sizeStyle.color,
          label: 'Go back with a result',
          onPressed: () => context.back('Hello from SizeScreen'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// A plain, unnamed screen reused by several context.to() / pushReplacement()
// / pushAndRemoveUntil() / removeRoute() demos above. It is never registered
// in `appRoutes` \u2014 unnamed navigation doesn't require that. It takes a
// `style` so it visually matches whichever transition pushed it.
// ---------------------------------------------------------------------------

class UnnamedDetailScreen extends StatelessWidget {
  const UnnamedDetailScreen({
    super.key,
    required this.title,
    this.subtitle,
    this.style = fadeStyle,
  });

  final String title;
  final String? subtitle;
  final TransitionStyle style;

  @override
  Widget build(BuildContext context) {
    return _TransitionScaffold(
      style: style,
      title: title,
      description: 'An unnamed widget, not a registered named route.',
      children: [
        if (subtitle != null) ...[
          _MessageBanner(message: subtitle!, color: style.color),
          const SizedBox(height: 20),
        ],
        _CanPopBadge(canPop: context.canPop()),
        const SizedBox(height: 20),
        _DemoButton(
          icon: Icons.arrow_back_rounded,
          color: style.color,
          label: 'Go back',
          onPressed: () => context.back(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Login \u2192 Dashboard flow: demonstrates removeRouteBelow() with a real
// anchor route (the current, already-on-the-stack ModalRoute), used to drop
// the Login screen from history once the user is signed in.
// ---------------------------------------------------------------------------

class LoginDemoScreen extends StatelessWidget {
  const LoginDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _TransitionScaffold(
      style: authStyle,
      title: 'Login (demo)',
      description:
          'Pushed with context.to() and no transitions argument \u2014 '
          'falls back to the default QuickFade().',
      children: [
        _DemoButton(
          icon: Icons.login_rounded,
          color: authStyle.color,
          label: 'Log in',
          onPressed: () => context.to(const DashboardDemoScreen()),
        ),
      ],
    );
  }
}

class DashboardDemoScreen extends StatelessWidget {
  const DashboardDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _TransitionScaffold(
      style: authStyle,
      title: 'Dashboard (demo)',
      description: 'You are logged in.',
      children: [
        _DemoButton(
          icon: Icons.layers_clear_rounded,
          color: authStyle.color,
          label: 'Drop Login screen from history',
          onPressed: () {
            final Route<dynamic>? current = ModalRoute.of(context);
            if (current != null) {
              // The Login screen sits directly below this Dashboard route
              // in the stack, so a system back / context.back() from here
              // will now return straight to Home.
              context.removeRouteBelow(current);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Login screen removed from history.')),
              );
            }
          },
        ),
        const SizedBox(height: 4),
        _DemoButton(
          icon: Icons.home_rounded,
          color: authStyle.color,
          label: 'Back to Home',
          onPressed: () => context.popUntil((route) => route.isFirst),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared, styled scaffold for every screen reached through a transition: a
// colored gradient header with a back button + icon avatar sitting above a
// rounded white sheet holding the demo content. Purely cosmetic.
// ---------------------------------------------------------------------------

class _TransitionScaffold extends StatelessWidget {
  const _TransitionScaffold({
    required this.style,
    required this.title,
    required this.description,
    required this.children,
  });

  final TransitionStyle style;
  final String title;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: style.color,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 24),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.maybePop(),
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white.withValues(alpha: 0.22),
                    child: Icon(style.icon, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          description,
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                child: ListView(children: children),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Small shared widgets used across the demo screens.
// ---------------------------------------------------------------------------

/// A rounded, elevated group of related demo buttons with an icon + title
/// header, used on the Home screen.
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(subtitle,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 12.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

/// A full-width, icon-leading button used for every navigation demo.
class _DemoButton extends StatelessWidget {
  const _DemoButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color.withValues(alpha: 0.35)),
            backgroundColor: color.withValues(alpha: 0.06),
            alignment: Alignment.centerLeft,
          ),
          onPressed: onPressed,
          icon: Icon(icon, size: 20),
          label: Text(label, textAlign: TextAlign.left),
        ),
      ),
    );
  }
}

/// Shows the arguments string received by a screen in a soft, colored banner.
class _MessageBanner extends StatelessWidget {
  const _MessageBanner({required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.mail_outline_rounded, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Argument received: "$message"',
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small badge reporting the live result of `context.canPop()`.
class _CanPopBadge extends StatelessWidget {
  const _CanPopBadge({required this.canPop});

  final bool canPop;

  @override
  Widget build(BuildContext context) {
    final Color color =
        canPop ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(canPop ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
              color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            'context.canPop() == $canPop',
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}
