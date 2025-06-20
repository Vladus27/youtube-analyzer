import 'package:flutter/material.dart';

class ViewEmptyContent extends StatelessWidget {
  const ViewEmptyContent({
    super.key,
    required this.emptyContent,
    this.isLoading = false,
  });
  final String emptyContent;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return Center(
      child: isLoading
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorTheme.primary),
            )
          : Text(
              emptyContent,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: colorTheme.primary),
            ),
    );
  }
}
