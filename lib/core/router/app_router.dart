import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_pages/features/detailed_view/presentation/pages/details_view_screen.dart';
import 'package:hotel_pages/features/detailed_view/presentation/pages/map_view_screen.dart';
import 'package:hotel_pages/features/home/data/models/hotel_model.dart';
import 'package:hotel_pages/features/splash/presentation/splash_screen.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  redirect: (context, state) {
    final currentLocation = state.matchedLocation;

    // Always allow splash screen to load first
    if (currentLocation == '/splash') {
      return null;
    }

    try {
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;

      final isAuthenticated = authState is AuthAuthenticated;
      final isUnauthenticated = authState is AuthUnauthenticated;
      final isLoading = authState is AuthLoading || authState is AuthInitial;

      // If auth state is still loading, don't redirect yet
      if (isLoading) {
        return null;
      }

      // Redirect authenticated users away from login
      if (isAuthenticated && currentLocation == '/login') {
        return '/home';
      }

      // Redirect unauthenticated users to login (except from splash)
      if (isUnauthenticated && currentLocation != '/login') {
        return '/login';
      }

    } catch (e) {
      // If BLoC not available yet, allow current route
      return null;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/detailedView',
      builder: (context, state) {
        final HotelModel hotel = state.extra as HotelModel;
        return DetailedViewScreen(hotel: hotel);
      },
    ),
    GoRoute(
      path: '/mapView',
      builder: (context, state) {
        final extra = state.extra as Map<String, String>;
        final String title = extra['title']!;
        final String address = extra['address']!;
        final String longitude = extra['longitude']!;
        final String latitude = extra['latitude']!;

        return MapViewScreen(
          longitude: longitude,
          latitude: latitude,
          title: title,
          address: address,
        );
      },
    ),
  ],
);

class AppNavigation {
  static void goToLogin(BuildContext context) {
    context.go('/login');
  }

  static void goToHome(BuildContext context) {
    context.go('/home');
  }

  static void goToSplash(BuildContext context) {
    context.go('/splash');
  }

  static void goToDetailedView(BuildContext context, hotel) {
    context.push('/detailedView', extra: hotel);
  }

  static void goToMapView(
      BuildContext context, {
        required String title,
        required String address,
        required String latitude,
        required String longitude,
      }) {
    context.push('/mapView', extra: {
      'title': title,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    });
  }
}