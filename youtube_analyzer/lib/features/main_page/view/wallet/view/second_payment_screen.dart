import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/repositories/models/wallet.dart';
import 'package:youtube_analyzer/features/main_page/view/wallet/view/payment_screen.dart';

class SecondPaymentScreen extends StatefulWidget {
  const SecondPaymentScreen({
    super.key,
    required this.payment
    
  });
  final PaymentStatus payment;

  @override
  State<SecondPaymentScreen> createState() => _SecondPaymentScreenState();
}

class _SecondPaymentScreenState extends State<SecondPaymentScreen> {
  Timer? _timer;
  bool _isTimerStarted = false;

  late int _remainingSeconds;

  void _startTimer() {
    setState(() => _isTimerStarted = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          Database.set(Database.timerSeconds, _remainingSeconds);
          debugPrint('second left in SecondPaymentScreen $_remainingSeconds');
        });
      } else {
        timer.cancel();
        setState(() {
          _isTimerStarted = false; // Додаємо цей рядок!
        });
        // _showTimeUpDialog();
      }
    });
  }

  void isTimerStarted() {
    if (!_isTimerStarted) {
      _startTimer();
    }
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void initState() {
    isTimerStarted();
    _remainingSeconds = Database.get(Database.timerSeconds);
    super.initState();

    // _remainingSeconds = widget.remainSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme clrScreme = Theme.of(context).colorScheme;
        final logo = widget.payment.logoUrl;
    final payAddress = widget.payment.payAddress;
    final priceUsd = widget.payment.priceUsd.toString();
    final priceAmount = widget.payment.priceAmount.toString();
    final currency = widget.payment.payCurrency;
    final networkColor = widget.payment.networkColor;
    final network = widget.payment.network;
    final updatedAt = widget.payment.updatedAt;


    
     Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('The element is copied to clipboard'),
          action: SnackBarAction(
            label: 'ok',
            onPressed: () {
              debugPrint('Vladus is the best');
              // Code to execute.
            },
          ),
        ),
      );
    }
  }


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Purchase Wallet'),
      ),
      body: Center(
        child: Container(
            width: 750,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: clrScreme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text('Send deposit',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const Spacer(),
                    Text(_formattedTime)
                  ],
                ),
                const SizedBox(height: 16),
                PaymentScreen(
                  paymentOrder: Payment(
                      payAddress: payAddress,
                      priceUsd: priceUsd,
                      priceAmount: priceAmount,
                      priceCurrency: priceUsd,
                      payCurrency: currency,
                      logoUrl: logo,
                      network: network,
                      networkColor: networkColor,
                      updatedAt: updatedAt,
                      ),
                  copyToClipboard: _copyToClipboard,
                ),
              ],
            )),
      ),
    );
  }
}
