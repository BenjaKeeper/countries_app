import 'package:countries_app/core/error/failures.dart';
import 'package:countries_app/features/countries/presentation/providers/countries_provider.dart';
import 'package:countries_app/features/countries/presentation/widgets/country_list_item.dart';
import 'package:countries_app/features/countries/presentation/widgets/country_list_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CountriesListScreen extends ConsumerWidget {
  const CountriesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesAsync = ref.watch(filteredCountriesProvider);
    final searchQuery = ref.watch(countriesSearchProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SearchBar(
              hintText: 'Search countries...',
              leading: const Icon(Icons.search),
              trailing: searchQuery.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          ref.read(countriesSearchProvider.notifier).clear();
                        },
                      ),
                    ]
                  : null,
              onChanged: (value) {
                ref.read(countriesSearchProvider.notifier).update(value);
              },
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(countriesListProvider);
        },
        child: countriesAsync.when(
          data: (countries) {
            if (countries.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.travel_explore,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No countries found',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try a different search term',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: countries.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final country = countries[index];
                return CountryListItem(
                  country: country,
                  onTap: () {
                    context.push(
                      '/country/${country.code}',
                      extra: {'emoji': country.emoji, 'name': country.name},
                    );
                  },
                );
              },
            );
          },
          loading: () => const CountryListSkeleton(),
          error: (error, stack) {
            // Handle specific Failure types
            final String errorMessage;
            final IconData errorIcon;

            if (error is Failure) {
              errorMessage = error.when(
                server: (message) => 'Server error: $message',
                network: () =>
                    'No internet connection.\nPlease check your network.',
                unknown: (message) => 'An unexpected error occurred.\n$message',
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
                        color: Theme.of(
                          context,
                        ).colorScheme.errorContainer.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        errorIcon,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Error loading countries',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      errorMessage,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () {
                        ref.invalidate(countriesListProvider);
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
    );
  }
}
