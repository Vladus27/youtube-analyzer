import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/main_page/view/scenario_channel/widgets/property_create_button.dart';
import 'package:youtube_analyzer/features/main_page/view/scenario_channel/widgets/property_list_item.dart';

class PropetryListview extends StatelessWidget {
  const PropetryListview({super.key, required this.propertiesList});
  final List propertiesList;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: propertiesList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              PropertyListItem(
                  propertiesList: propertiesList, index: index),
              const Divider(
                endIndent: 16,
              ),
              index == propertiesList.length - 1
                  ? const PropertyCreateButton()
                  : const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}
