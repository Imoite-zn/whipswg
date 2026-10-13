import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_swg/core/auth/auth_service.dart';
import 'package:ride_swg/features/auth/presentation/login_screen.dart';
import 'package:ride_swg/features/auth/presentation/signup_screen.dart';
import 'package:ride_swg/features/garage/presentation/garage_screen.dart';
import 'package:ride_swg/features/garage/presentation/upload_car_screen.dart';
import 'package:ride_swg/features/garage/data/car_model.dart';
import 'package:ride_swg/features/mod_builder/presentation/mod_builder_screen.dart';
import 'package:ride_swg/features/mod_catalog/presentation/mod_catalog_screen.dart';
import 'package:ride_swg/features/mechanics/data/mechanic_model.dart';
import 'package:ride_swg/features/mechanics/presentation/mechanics_directory_screen.dart';
import 'package:ride_swg/features/mechanics/presentation/mechanic_detail_screen.dart';
import 'package:ride_swg/features/mechanics/presentation/mechanic_portal_screen.dart';
import 'package:ride_swg/shared/widgets/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/auth/login',
  redirect: (context, state) {
    final isAuth = AuthService.instance.isAuthenticated;
    final isOnAuth = state.matchedLocation.startsWith('/auth');

    if (!isAuth && !isOnAuth) return '/auth/login';
    if (isAuth && isOnAuth) return '/garage';
    return null;
  },
  refreshListenable: AuthService.instance,
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
          path: '/garage/upload-car',
          builder: (context, state) => const UploadCarScreen(),
        ),
        GoRoute(
          path: '/catalog',
          builder: (context, state) => const ModCatalogScreen(),
        ),
        GoRoute(
          path: '/mechanics',
          builder: (context, state) => const MechanicsDirectoryScreen(),
        ),
        GoRoute(
          path: '/mechanics/portal',
          builder: (context, state) => const MechanicPortalScreen(),
        ),
        GoRoute(
          path: '/mechanics/:id',
          builder: (context, state) {
            final mechanic = state.extra as MechanicModel?;
            return MechanicDetailScreen(
              mechanic: mechanic ?? MechanicModel.demo.first,
            );
          },
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
