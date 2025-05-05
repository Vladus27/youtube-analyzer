import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_analyzer/features/login_page/platform_features/widgets/platform_feature_card_item.dart';
import 'package:youtube_analyzer/repositories/models/features.dart';

class AnimatedFeatureCard extends StatefulWidget {
  const AnimatedFeatureCard({
    super.key,
    required this.feature,
    required this.delay,
  });
  final Features feature;
  final Duration delay;

  @override
  State<AnimatedFeatureCard> createState() => _AnimatedFeatureCardState();
}

class _AnimatedFeatureCardState extends State<AnimatedFeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;
  bool _hasAnimated = false;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _handleVisibility(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction > 0.2) {
      _controller.forward();
      _hasAnimated = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('feature-${widget.feature.title}'),
      onVisibilityChanged: _handleVisibility,
      child: SlideTransition(
        position: _offsetAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SizedBox(
              height: 256,
              width: 400,
              child: PlatformFeatureCardItem(feature: widget.feature)),
        ),
      ),
    );
  }
}
