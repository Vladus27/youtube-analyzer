import 'package:flutter/material.dart';

class EmptyPropetyPlaceholder extends StatelessWidget {
  const EmptyPropetyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        )),
        onPressed: () {},
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_settings, size: 48),
            SizedBox(
              height: 8,
            ),
            Text("You don't have any properties, click to create them"),
          ],
        ),
      ),
    );
  }
}
