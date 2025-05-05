import 'package:flutter/material.dart';

class TempTestFile extends StatelessWidget {
  const TempTestFile({super.key, required this.verifCode});
  final String verifCode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: Text(
              'OUR FEATURES',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              


            ],
          ),
          const SizedBox(
            height: 140,
          )
        ],
      ),
    );
  }
}
