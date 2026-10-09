import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_swg/core/supabase/supabase_config.dart';
import 'package:ride_swg/features/auth/presentation/login_screen.dart';
import 'package:ride_swg/features/auth/presentation/signup_screen.dart';
import 'package:ride_swg/features/garage/presentation/garage_screen.dart';
import 'package:ride_swg/features/garage/data/car_model.dart';
import 'package:ride_swg/features/mod_builder/presentation/mod_builder_screen.dart';
import 'package:ride_swg/features/mod_catalog/presentation/mod_catalog_screen.dart';
import 'package:ride_swg/shared/widgets/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/auth/login',
  redirect: (context, state) {
    final session = SupabaseConfig.client.auth.currentSession;
    final isAuth = session != null;
    final isOnAuth = state.matchedLocation.startsWith('/auth');

    if (!isAuth && !isOnAuth) return '/auth/login';
    if (isAuth && isOnAuth) return '/garage';
    return null;
  },
  refreshListenable: GoRouterRefreshStream(
    SupabaseConfig.client.auth.onAuthStateChange,
  ),
  routes: [
    // Auth routes (no shell)
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => const SignUpScreen(),
    ),

    // Main app with bottom nav shell
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/garage',
          builder: (context, state) => const GarageScreen(),
        ),
        GoRoute(
          path: '/garage/mod-builder',
          builder: (context, state) {
            final car = state.extra as CarModel?;
            return ModBuilderScreen(car: car);
          },
        ),
        GoRoute(
          path: '/catalog',
          builder: (context, state) => const ModCatalogScreen(),
        ),
      ],
    ),
  ],
);

/// Makes GoRouter react to Supabase auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
