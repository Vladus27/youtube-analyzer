import 'package:flutter/material.dart';
import 'package:youtube_analyzer/repositories/models/features.dart';

class PlatformFeatureCardItem extends StatelessWidget {
  const PlatformFeatureCardItem({super.key, required this.feature});
  final Features feature;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              feature.icon,
              size: 64,
              color: colorTheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              feature.title,
              style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorTheme.onPrimaryContainer),
            ),
            const SizedBox(height: 8),
            Text(
              feature.description,
              style: textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
