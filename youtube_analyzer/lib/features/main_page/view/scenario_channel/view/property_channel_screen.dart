import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/main_page/view/scenario_channel/widgets/input_scenario_description.dart';
import 'package:youtube_analyzer/features/main_page/view/scenario_channel/widgets/input_scenario_title.dart';
import 'package:youtube_analyzer/features/main_page/view/scenario_channel/widgets/scenario_buttons.dart';
import 'package:youtube_analyzer/repositories/models/youtube_analysis.dart';

class PropertyChannelScreen extends StatefulWidget {
  const PropertyChannelScreen({
    super.key,
    this.title = 'Create new property',
  });
  final String title;

  @override
  State<PropertyChannelScreen> createState() => _PropertyChannelScreenState();
}

class _PropertyChannelScreenState extends State<PropertyChannelScreen> {
  final TextEditingController keyTextControler = TextEditingController();
  final TextEditingController promptTextControler = TextEditingController();
  bool isLoading = false;
  bool light = false;
  bool isSelectedType = true;
  int value = 0;

  final propertyValues = Properties.values;

  @override
  void dispose() {
    keyTextControler.dispose();
    promptTextControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        children: [
          InputSingleLine(
            title: 'Property key',
            label: 'Key',
            textControler: keyTextControler,
          ),
          const SizedBox(
            height: 8,
          ),
          const Text('Please select property type:'),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: List<Widget>.generate(propertyValues.length, (int index) {
              // get enum value by index
              final propertyKey = propertyValues[index];
              return ChoiceChip(
                showCheckmark: false,
                avatar: Icon(
                  propertyKey.icon, // use the icon from the enum
                ),
                label: Text(propertyKey.name), // use the name from the enum
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                selected: value == index,
                onSelected: (bool selected) {
                  setState(() {
                    value = index;
                    debugPrint('ChoiceChip ${index + 1} selected: $selected');
                  });
                },
              );
            }),
          ),
          Row(
            children: [
              const Text('Is aray enabled:'),
              const SizedBox(width: 8),
              Switch(
                value: light,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (bool value) {
                  setState(
                    () {
                      light = value;
                    },
                  );
                },
              ),
            ],
          ),
          InputMultiLine(
              hint: 'Enter property prompt',
              label: 'Prompt',
              textControler: promptTextControler),
          ScenarioButtons(
              label: 'Create property',
              isLoading: isLoading,
              onCreateScenario: () {
                debugPrint('Create property button pressed');
              })
        ],
      ),
    );
  }
}
