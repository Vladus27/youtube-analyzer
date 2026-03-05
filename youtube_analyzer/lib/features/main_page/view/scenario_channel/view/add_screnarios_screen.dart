import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/main_page/view/scenario_channel/widgets/empty_propety_placeholder.dart';

// import 'package:youtube_analyzer/features/main_page/widgets/form_buttons.dart';
import 'package:youtube_analyzer/features/main_page/view/scenario_channel/widgets/input_scenario_description.dart';
import 'package:youtube_analyzer/features/main_page/view/scenario_channel/widgets/input_scenario_title.dart';

import 'package:youtube_analyzer/features/main_page/view/scenario_channel/widgets/propetry_listview.dart';
import 'package:youtube_analyzer/features/main_page/view/scenario_channel/widgets/scenario_buttons.dart';

class AddScrenariosScreen extends StatefulWidget {
  const AddScrenariosScreen({super.key});

  @override
  State<AddScrenariosScreen> createState() =>
      _AddScrenariosScreenState();
}

class _AddScrenariosScreenState
    extends State<AddScrenariosScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleTextControler = TextEditingController();
  final TextEditingController descriptionTextControler =
      TextEditingController();

  bool _isLoading = false;
  List propertiesList = [
    'is_positive_mood',
    'is_negative_mood',
    'is_mood',
    'is_altseasonsdfs_mood',
    'is_positive_mood',
  ];

  Future<void> _handleCreateScenario() async {
    setState(() {
      _isLoading = true;
    });
    debugPrint('isLoading: $_isLoading');

    if (_formKey.currentState?.validate() ?? false) {
      await Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
          debugPrint('isLoading: $_isLoading');
        });
      });
    } else {
      await Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
          debugPrint('isLoading: $_isLoading');
        });
      });
    }
  }

  @override
  void dispose() {
    titleTextControler.dispose();
    descriptionTextControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWight = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Scenario'),
      ),
      body: Center(
        child: Container(
          height: screenHeight * 0.8,
          width: screenWight * 0.6,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: colorTheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputSingleLine(
                      textControler: titleTextControler,
                    ),
                    const SizedBox(height: 16),
                    InputMultiLine(
                      textControler: descriptionTextControler,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Divider(
                color: Theme.of(context).dividerColor,
              ),
              propertiesList.isNotEmpty
                  ? PropetryListview(propertiesList: propertiesList)
                  : const Expanded(
                      child: EmptyPropetyPlaceholder(),
                    ),
              Divider(
                color: Theme.of(context).dividerColor,
              ),
              const SizedBox(
                height: 12,
              ),
              ScenarioButtons(
                isLoading: _isLoading,
                onCreateScenario: _handleCreateScenario,
              )
            ],
          ),
        ),
      ),
    );
  }
}
