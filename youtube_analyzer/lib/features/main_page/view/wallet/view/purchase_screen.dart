import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/repositories/models/wallet.dart';
import 'package:youtube_analyzer/repositories/payment_repository.dart';
import 'package:youtube_analyzer/repositories/widgets/handle_verified_auth_token.dart';

import 'package:youtube_analyzer/features/main_page/view/wallet/view/payment_screen.dart';
import 'package:youtube_analyzer/features/main_page/view/wallet/view/select_payment_screen.dart';

import 'package:qr_flutter/qr_flutter.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({
    super.key,
    required this.avaliableCurrency,
  });
  final List<PaymentCurrency> avaliableCurrency;

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<PaymentCurrency> _avaliableCurrency = [];

  int? _value = 0;
  int _currentStep = 0;

  // int _remainingSeconds = 20; // 20 minutes in seconds
  int _remainingSeconds = 1200; // 20 minutes in seconds
  Timer? _timer;
  bool _isTimerStarted = false;
  Payment? _paymentOrder;
  bool _isSetPaymentOrder = false;


  void _printTextInDebugMode(String text){
  if (!kReleaseMode) {
    debugPrint(text);
  }  
}

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          Database.set(Database.timerSeconds, _remainingSeconds);
        });
      } else {
        timer.cancel();
        setState(() {
          _isTimerStarted = false; // Додаємо цей рядок!
        });
        _showTimeUpDialog();
      }
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Payment Time Expired"),
        content: const Text(
            "The allowed time for payment has ended. Your order can no longer be processed."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> handlePurchase(
      {required bool isLoading,
      required String payCurrency,
      required String priceUsd}) async {
    setState(() {
      isLoading = true;
      _isSetPaymentOrder = false;
    });

    final Payment? payment = await PaymentRepository().postPayment(
      payCurrency,
      priceUsd,
    );
    _printTextInDebugMode('Payment from handlePurchase: $payment');

    if (payment != null) {
      _paymentOrder = payment;
      setState(() {
        _isSetPaymentOrder = true;
        isLoading = false;
      });
      _onChanged();
    }
  }

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
              _printTextInDebugMode('Vladus is the best');
              // Code to execute.
            },
          ),
        ),
      );
    }
  }

  Future<void> _onChanged() async {
    if (_value != null) {
      setState(() {
        _currentStep = 1;

        if (!_isTimerStarted) {
          _startTimer();
          _isTimerStarted = true;
        }
      });
    }
  }

  _onSelected(int selected) {
    setState(() {
      _value = selected;
    });
    // Validate the form after the state has been updated
    // This is necessary to ensure that the validation runs after the state change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.validate();
    });
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _avaliableCurrency = widget.avaliableCurrency;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme clrScreme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Purchase Wallet'),
      ),
      body: Center(
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: clrScreme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep == 0 && _value != null) {
                setState(() {
                  _currentStep = 1;
                });
              } else if (_currentStep == 1) {
                Navigator.pop(context, _paymentOrder);
                // Navigator.pop(context, _avaliableCurrency[_value!]);
                //переконатись чи дійсно нам потрібно передавати значення
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep = 0;
                });
              }
            },
            steps: [
              Step(
                title: const Text('Choose asset'),
                isActive: _currentStep >= 0,
                state:
                    _currentStep > 0 ? StepState.complete : StepState.indexed,
                content: SelectPaymentScreen(
                  handlePurchase: handlePurchase,
                  value: _value,
                  avaliableCurrency: _avaliableCurrency,
                  // onChanged: _onChanged,
                  onSelected: _onSelected,
                  minAmountController: _amountController,
                  formKey: _formKey,
                  // postPayment: _postPayment,
                ),
              ),
              Step(
                  title: Row(
                    children: [
                      const Text('Send deposit'),
                      const Spacer(),
                      if (_currentStep != 0) Text(_formattedTime),
                    ],
                  ),
                  isActive: _currentStep >= 1,
                  state: StepState.indexed,
                  content: _isSetPaymentOrder
                      ? PaymentScreen(
                          paymentOrder: _paymentOrder,
                          copyToClipboard: _copyToClipboard,
                        )
                      : const SizedBox.shrink()),
            ],
            controlsBuilder: (context, details) {
              // hide the default buttons
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
