import 'package:flutter/material.dart';

class PropertyCreateButton extends StatelessWidget {
  const PropertyCreateButton({super.key, required this.showPropertyDialog});
  final void Function() showPropertyDialog;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FilledButton.icon(
        icon: const Icon(Icons.video_settings),
        onPressed: () {
          showPropertyDialog();          
        },
        label: const Text('Create new property'),
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
    );
  }
}
