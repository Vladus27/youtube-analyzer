import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/main_page/widgets/form_buttons.dart';
import 'package:youtube_analyzer/repositories/widgets/show_snack_bar.dart';
import 'package:youtube_analyzer/repositories/youtube_repository.dart';

class PromptChannelModalScreen extends StatefulWidget {
  const PromptChannelModalScreen({
    super.key,
    required this.channelId,
  });
  final String channelId;

  @override
  State<PromptChannelModalScreen> createState() =>
      _PromptChannelModalScreenState();
}

class _PromptChannelModalScreenState extends State<PromptChannelModalScreen> {
  final TextEditingController _promptControler = TextEditingController();
  bool isLoading = false;

  void _setChannelPrompt() async {
    final channelId = widget.channelId;
    final prompt = _promptControler.text;
    setState(() {
      isLoading = true;
    });
    await YoutubeRepository().setChannelPrompt(channelId, prompt);
    setState(() {
      isLoading = false;
    });
    if (mounted) {
      Navigator.pop(context);
      showSnackBar(context, 'Prompt has been successfully set for the channel');
    }
  }

  void excecuteSetChannelPrompt() {}

  @override
  void dispose() {
    _promptControler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textThemeTitleL = Theme.of(context).textTheme.titleLarge!;
    final textThemeTitleM = Theme.of(context).textTheme.titleMedium!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Set channel Prompt',
            textAlign: TextAlign.center,
            style: textThemeTitleL.copyWith(color: colorScheme.primary),
          ),
              const SizedBox(
            height: 24,
          ),
            Text('Set a prompt for the selected YouTube channel to guide AI-driven analysis and recommendations',
            style: textThemeTitleM.copyWith(color: colorScheme.secondary),
            ),
          const SizedBox(
            height: 12,
          ),
          TextField(
            controller: _promptControler,
            keyboardType: TextInputType.text,
            maxLength: 500,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Enter your prompt here",
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainer,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          FormButtons(
              func: _setChannelPrompt,
              btnLabel: 'Set the prompt',
              btnIcon: Icons.add,
              isLoading: isLoading),
        ],
      ),
    );
  }
}
