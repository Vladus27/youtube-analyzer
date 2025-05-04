import 'package:flutter/material.dart';

class FormButtons extends StatelessWidget {
  const FormButtons({
    super.key,
    required this.func,
    required this.btnLabel,
    required this.btnIcon,
    required this.isLoading,
  });
  final void Function() func;
  final String btnLabel;
  final IconData btnIcon;
  final bool isLoading;

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
              icon: isLoading ? null : Icon(btnIcon),
              label: isLoading
                  ? CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colorTheme.primary),
                    )
                  : Text(btnLabel),
              onPressed: isLoading ? null : func,
              style: FilledButton.styleFrom(
                backgroundColor: colorTheme.onPrimary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
