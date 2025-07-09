import 'package:flutter/material.dart';

class PropertyRichtext extends StatelessWidget {
  const PropertyRichtext({super.key, required this.propertyType});
  final String propertyType;

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return RichText(
      text: TextSpan(style: Theme.of(context).textTheme.bodySmall, children: [
        TextSpan(
          text: 'type: ',
          style: TextStyle(
            color: Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.7),
          ),
        ),
        TextSpan(
          text: propertyType,
          style: TextStyle(
            color: colorTheme.primary,
          ),
        ),
      ]),
    );
  }
}
