import 'package:countries_app/features/countries/presentation/widgets/skeleton_loader.dart';
import 'package:flutter/material.dart';

class CountryDetailsSkeleton extends StatelessWidget {
  const CountryDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Detail cards
          _DetailCardSkeleton(),
          _DetailCardSkeleton(),
          _DetailCardSkeleton(),
          _DetailCardSkeleton(),

          // Languages section
          _LanguagesSectionSkeleton(),
        ],
      ),
    );
  }
}

class _DetailCardSkeleton extends StatelessWidget {
  const _DetailCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon skeleton
            SkeletonLoader(
              width: 48,
              height: 48,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(width: 16),

            // Content skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  SkeletonLoader(
                    width: 80,
                    height: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  // Value
                  SkeletonLoader(
                    width: 150,
                    height: 18,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguagesSectionSkeleton extends StatelessWidget {
  const _LanguagesSectionSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
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
            // Header
            Row(
              children: [
                SkeletonLoader(
                  width: 48,
                  height: 48,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(width: 16),
                SkeletonLoader(
                  width: 100,
                  height: 18,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Language items
            const _LanguageItemSkeleton(),
            const SizedBox(height: 8),
            const _LanguageItemSkeleton(),
            const SizedBox(height: 8),
            const _LanguageItemSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _LanguageItemSkeleton extends StatelessWidget {
  const _LanguageItemSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SkeletonLoader(
            width: 8,
            height: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SkeletonLoader(
              width: double.infinity,
              height: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          SkeletonLoader(
            width: 40,
            height: 20,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      ),
    );
  }
}
