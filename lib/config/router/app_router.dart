import 'package:countries_app/features/countries/presentation/screens/countries_list_screen.dart';
import 'package:countries_app/features/countries/presentation/screens/country_details_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: kDebugMode, // Only enable in debug mode
  routes: [
    GoRoute(
      path: '/',
      name: 'countries',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CountriesListScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/country/:code',
      name: 'countryDetails',
      pageBuilder: (context, state) {
        final code = state.pathParameters['code'];

        // Validate code parameter
        if (code == null || code.isEmpty) {
          return MaterialPage(
            key: state.pageKey,
            child: _buildErrorScreen(
              context,
              'Invalid country code',
              'The country code is missing.',
            ),
          );
        }

        // Validate code format (2 uppercase letters)
        if (!RegExp(r'^[A-Z]{2}$').hasMatch(code)) {
          return MaterialPage(
            key: state.pageKey,
            child: _buildErrorScreen(
              context,
              'Invalid country code format',
              'Country code must be 2 uppercase letters. Got: $code',
            ),
          );
        }

        // Get optional extra data for hero animation
        final extra = state.extra as Map<String, dynamic>?;
        final emoji = extra?['emoji'] as String?;
        final name = extra?['name'] as String?;

        return CustomTransitionPage(
          key: state.pageKey,
          child: CountryDetailsScreen(
            countryCode: code,
            initialEmoji: emoji,
            initialName: name,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            final offsetAnimation = animation.drive(tween);
            final fadeAnimation = CurveTween(
              curve: Curves.easeIn,
            ).animate(animation);

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(opacity: fadeAnimation, child: child),
            );
          },
        );
      },
    ),
  ],
  errorBuilder: (context, state) =>
      _buildErrorScreen(context, 'Page not found', state.uri.toString()),
);

/// Helper function to build error screens
Widget _buildErrorScreen(BuildContext context, String title, String message) {
  return Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Use Navigator if context is available, otherwise use GoRouter
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                GoRouter.of(context).go('/');
              }
            },
            child: const Text('Go to Home'),
          ),
        ],
      ),
    ),
  );
}
