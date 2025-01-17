import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:monalisa_app_001/config/router/app_router_notifier.dart';
import 'package:monalisa_app_001/features/auth/auth.dart';
import 'package:monalisa_app_001/features/auth/presentation/providers/auth_provider.dart';
import 'package:monalisa_app_001/features/home/presentation/screens/home_screen.dart';
import 'package:monalisa_app_001/features/template/presentation/screens/template_buttons_screen.dart';
import 'package:monalisa_app_001/features/template/presentation/screens/template_cards_screen.dart';
import 'package:monalisa_app_001/features/template/presentation/screens/template_home_screen.dart';
import '../../features/auth/presentation/screens/auth_data_screen.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      ///* Role Routes
      GoRoute(
        path: '/authData',
        builder: (context, state) => AuthDataScreen(),
      ),

      ///* Home Routes
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      ///* Template Routes
      GoRoute(
        path: '/templateHome',
        builder: (context, state) => const TemplateHomeScreen(),
      ),
      GoRoute(
        path: '/templateButtons',
        builder: (context, state) => const TemplateButtonsScreen(),
      ),
      GoRoute(
        path: '/templateCards',
        builder: (context, state) => const TemplateCardsScreen(),
      ),

    ],
    redirect: (context, state) {
      final isGoingTo = state.uri.toString();
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login') return null;
        return '/login';
      }

      if (authStatus == AuthStatus.login) {
        return '/authData';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/splash' || isGoingTo == '/authData') {
          return '/home';
        }
      }

      return null;
    },
  );
});
