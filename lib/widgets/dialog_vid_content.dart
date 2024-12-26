import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

class DialogVidContent extends StatefulWidget {
  const DialogVidContent({
    super.key,
    required this.authorVid,
    required this.titleVid,
    required this.originalText,
    required this.modifiedText,
  });
  final String titleVid;
  final String authorVid;
  final String originalText;
  final String modifiedText;

  @override
  State<DialogVidContent> createState() {
    return _DialogVidContentState();
  }
}

class _DialogVidContentState extends State<DialogVidContent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SizedBox(
        width: 700,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Formated',
                  icon: Icon(Icons.format_align_center),
                ),
                Tab(
                  text: 'Original',
                  icon: Icon(Icons.text_fields),
                )
              ],
            ),
            title: Text('${widget.authorVid} — ${widget.titleVid}'),
          ),
          body: TabBarView(
            children: [
              Container(
                color: Colors.amber,
                child: const MarkdownBody(
                    data:
                        "### Analysis of Recent Bitcoin and Cryptocurrency Market Updates\n\nThe author presents a detailed and emotionally charged overview of recent developments in the cryptocurrency market, emphasizing the interplay of macroeconomic factors and crypto-specific news:\n\n1. **Macroeconomic Impact:** Jerome Powell's announcement of tighter monetary policies and strong GDP growth figures indicate potential inflation risks. This led to market fear as it suggests interest rates might remain high or increase further.\n2. **US Government Shutdown Drama:** Political disagreements over the debt ceiling evoke uncertainty, causing market jitters reminiscent of previous scenarios where resolutions emerged last-minute.\n3. **USDT Delistings in Europe:** The news about delisting USDT pairs on European exchanges is analyzed as largely symbolic, driven by USDC's regulatory favoritism, with limited immediate impact according to market makers.\n4. **Market Reactions:** Significant price drops across Bitcoin, altcoins, and the broader crypto market are highlighted. Despite emotional challenges, the author maintains a cautiously bullish stance, focusing on key support levels and potential rebounds.\n5. **Psychological Factors:** The author emphasizes the importance of staying rational during market volatility, suggesting that extreme fear often creates buying opportunities.\n6. **Trading Recommendations:** References to trading setups, tools, and bots are shared for managing volatility and identifying profitable opportunities.\n\nThe author encourages the audience to remain engaged with the market and offers community resources and tools for navigating such challenging conditions."),
              ),
              SingleChildScrollView(
                child: Container(
                  color: Colors.green,
                  child: Text(widget.originalText == ''
                      ? 'original text is coming soon'
                      : widget.originalText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
