import 'package:countries_app/core/error/failures.dart';
import 'package:countries_app/features/countries/domain/entities/language.dart';
import 'package:countries_app/features/countries/presentation/providers/country_details_provider.dart';
import 'package:countries_app/features/countries/presentation/widgets/country_detail_card.dart';
import 'package:countries_app/features/countries/presentation/widgets/country_details_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CountryDetailsScreen extends ConsumerWidget {
  final String countryCode;
  final String? initialEmoji;
  final String? initialName;

  const CountryDetailsScreen({
    required this.countryCode,
    this.initialEmoji,
    this.initialName,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countryAsync = ref.watch(countryDetailsProvider(countryCode));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Details'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primaryContainer.withValues(alpha: 0.3),
                colorScheme.surface,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Header with flag and name - always visible for hero animation
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  // Hero animation for the flag
                  Hero(
                    tag: 'flag_$countryCode',
                    flightShuttleBuilder:
                        (
                          BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext,
                        ) {
                          final Hero toHero = toHeroContext.widget as Hero;
                          return ScaleTransition(
                            scale: animation,
                            child: toHero.child,
                          );
                        },
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: countryAsync.maybeWhen(
                          data: (country) => Text(
                            country.emoji,
                            style: const TextStyle(fontSize: 56),
                          ),
                          orElse: () => Text(
                            initialEmoji ?? '🌍',
                            style: const TextStyle(fontSize: 56),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  countryAsync.maybeWhen(
                    data: (country) => Column(
                      children: [
                        Text(
                          country.name,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer.withValues(
                              alpha: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            country.code,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    orElse: () => Column(
                      children: [
                        if (initialName != null)
                          Text(
                            initialName!,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer.withValues(
                              alpha: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            countryCode,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Details section with loading state
          Expanded(
            child: countryAsync.when(
              data: (country) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Country information cards
                    CountryDetailCard(
                      icon: Icons.public,
                      title: 'Continent',
                      value: country.continent.name,
                    ),
                    if (country.capital != null)
                      CountryDetailCard(
                        icon: Icons.location_city,
                        title: 'Capital',
                        value: country.capital!,
                      ),
                    if (country.currency != null)
                      CountryDetailCard(
                        icon: Icons.attach_money,
                        title: 'Currency',
                        value: country.currency!,
                      ),
                    if (country.phone != null)
                      CountryDetailCard(
                        icon: Icons.phone,
                        title: 'Phone Code',
                        value: '+${country.phone}',
                      ),

                    // Languages section with Show More
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.grey.shade200,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.brightness == Brightness.dark
                                ? Colors.black.withValues(alpha: 0.2)
                                : Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorScheme.secondaryContainer,
                                        colorScheme.secondaryContainer
                                            .withValues(alpha: 0.6),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.secondary.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.language,
                                    color: colorScheme.secondary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Languages',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _LanguagesList(
                              countryCode: countryCode,
                              languages: country.languages ?? [],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const CountryDetailsSkeleton(),
              error: (error, stack) {
                // Handle specific Failure types
                final String errorMessage;
                final IconData errorIcon;

                if (error is Failure) {
                  errorMessage = error.when(
                    server: (message) => 'Server error: $message',
                    network: () =>
                        'No internet connection.\nPlease check your network.',
                    unknown: (message) =>
                        'An unexpected error occurred.\n$message',
                  );
                  errorIcon = error.when(
                    server: (_) => Icons.error_outline,
                    network: () => Icons.wifi_off,
                    unknown: (_) => Icons.warning_amber,
                  );
                } else {
                  errorMessage = error.toString();
                  errorIcon = Icons.error_outline;
                }

                final theme = Theme.of(context);
                final colorScheme = theme.colorScheme;

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer.withValues(
                              alpha: 0.3,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            errorIcon,
                            size: 64,
                            color: colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Error loading country details',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          errorMessage,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        FilledButton.icon(
                          onPressed: () {
                            ref.invalidate(countryDetailsProvider(countryCode));
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguagesList extends ConsumerWidget {
  final String countryCode;
  final List<Language> languages;

  const _LanguagesList({required this.countryCode, required this.languages});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMore = ref.watch(showMoreStateProvider(countryCode));
    final displayedLanguages = showMore
        ? languages
        : languages.take(3).toList();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...displayedLanguages.map(
          (language) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      language.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      language.code,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (languages.length > 3) ...[
          const SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              onPressed: () {
                ref.read(showMoreStateProvider(countryCode).notifier).toggle();
              },
              icon: Icon(showMore ? Icons.expand_less : Icons.expand_more),
              label: Text(showMore ? 'Show Less' : 'Show More'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
