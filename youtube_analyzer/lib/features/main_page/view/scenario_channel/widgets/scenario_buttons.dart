import 'package:flutter/material.dart';

class ScenarioButtons extends StatelessWidget {
  const ScenarioButtons({
    super.key,
    this.label = 'Create scenario',
    required this.isLoading,
    required this.onCreateScenario,
  });
  final String label;
  final bool isLoading;
  final void Function() onCreateScenario;

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          height: 48,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: SizedBox(
            height: 48,
            child: FilledButton.icon(
              icon: isLoading ? null : const Icon(Icons.upload_rounded),
              label: isLoading
                  ? CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colorTheme.primary),
                    )
                  : Text(label),
              onPressed: isLoading ? null : onCreateScenario,
              style: FilledButton.styleFrom(
                backgroundColor: colorTheme.onPrimary,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
