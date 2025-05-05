import 'package:flutter/material.dart';
import 'package:youtube_analyzer/repositories/models/features.dart';

const List<Features> features = [
  Features(
    icon: Icons.analytics_outlined,
    title: 'Deep Analysis of YouTube Videos & Channels',
    description: 'Instantly understand the core message of any video or entire channel — no need to watch it.',
  ),
  Features(
    icon: Icons.summarize_outlined,
    title: 'Smart Content Summaries',
    description: 'Our neural network extracts key points, sentiment, market mentions, asset references, and more.',
  ),
  Features(
    icon: Icons.tune_outlined,
    title: 'Custom Parameters for Targeted Queries',
    description: 'Define your own prompts like: “Is Bitcoin mentioned?”, “What’s the sentiment around Tesla stock?”',
  ),
  Features(
    icon: Icons.attach_money_outlined,
    title: 'Pay-as-you-go Model',
    description: 'You only pay for what you actually analyze. No subscriptions, no hidden fees — full flexibility.',
  ),
  Features(
    icon: Icons.account_balance_wallet_outlined,
    title: 'Virtual Wallet System',
    description: 'Top up your wallet (e.g. with \$10), and the system deducts only what you use — based on token consumption. Full cost transparency and control.',
  ),
];
