import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/login_page/platform_features/data/features_data.dart';
import 'package:youtube_analyzer/features/login_page/platform_features/widgets/animated_feature_card.dart';
// import 'package:youtube_analyzer/features/login_page/platform_features/widgets/platform_feature_card_item.dart';

class PlatformFeaturesScreen extends StatelessWidget {
  const PlatformFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const featureList = features;
    final screen = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return SizedBox(
      height: screen.height * 2,
      width: screen.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Plarform Features',
              style: theme.textTheme.displayMedium!
                  .copyWith(color: theme.colorScheme.primary),
            ),
            const SizedBox(
              height: 24,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: List.generate(featureList.length, (index) {
                return AnimatedFeatureCard(
                  feature: featureList[index],
                  delay: Duration(milliseconds: 100 * index), // gradual appearance
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
