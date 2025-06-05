import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_analyzer/common/database.dart';

import 'package:youtube_analyzer/repositories/models/wallet.dart';
import 'package:youtube_analyzer/repositories/payment_repository.dart';
import 'package:youtube_analyzer/features/main_page/view/wallet/view/second_payment_screen.dart';
import 'package:youtube_analyzer/features/main_page/view/wallet/view/purchase_screen.dart';

import 'package:youtube_analyzer/w_dummy_test/dummy_test_data.dart';
import 'package:youtube_analyzer/features/main_page/view/wallet/widgets/wallet_history_list.dart';

class TempTestFile extends StatefulWidget {
  const TempTestFile({
    super.key,
  });

  @override
  State<TempTestFile> createState() => _TempTestFileState();
}

class _TempTestFileState extends State<TempTestFile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<OrderHistory> _historyOrders = [];
  // List<OrderHistory> _historyOrders = DummyTestData.getHistoryOrders();
  List<PaymentCurrency> _avaliableCurrency = [];
  String _walletBalance = '--/--';

  bool _isLoadingPurchase = false;
  bool _isLoadingHistory = false;

  Timer? _timerPayment;
  bool _isTimerPaymentStarted = false;
  // int _remainingSeconds = 20; // 20 minutes in seconds
  int _remainingSeconds =
      Database.get(Database.timerSeconds); // 20 minutes in seconds

  Timer? _timerPaymentStatus;

  Future<void> _getPaymentStatus() async {
    final PaymentStatus? payment = await PaymentRepository().getPaymentStatus();
    if (payment != null) {
      final paymnetUpdatedAt = payment.secondsUntilCancel;
      Database.set(Database.timerSeconds, paymnetUpdatedAt);
      final paymentStatus = payment.status;
      debugPrint('Payment seconds until cancel: $paymnetUpdatedAt');
      _remainingSeconds = paymnetUpdatedAt;
      debugPrint('check last payment status: $paymentStatus');

      bool statusWaiting = paymentStatus == 'Waiting' || paymentStatus == 'New';
      bool statusInProgress = paymentStatus == 'InProgress';
      bool statusResult = paymentStatus == 'Done';

      bool statusTracker = statusWaiting || statusInProgress;
      debugPrint('_isTimerPaymentStarted: $_isTimerPaymentStarted');
      if (statusTracker) {
        if (!_isTimerPaymentStarted) {
          debugPrint('Start timer from _getPaymentStatus');
          _startTimerPayment();
        }
        _isLoadingHistory = true;
        _updateHistoryOrders();
      } else {
        _timerPayment?.cancel();
        setState(() {
          _isLoadingHistory = true;
          _isTimerPaymentStarted = false;
        });
        _updateHistoryOrders();
        if(statusResult){
          _getBallance();
        }


      }
    } else {
      _timerPayment?.cancel();
      _isLoadingHistory = true;
      _updateHistoryOrders();
    }
  }

  void _startTimerPayment() {
    setState(() {
      _isTimerPaymentStarted = true;
      _isLoadingPurchase = true;
    });
    _timerPayment = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        bool callPaymentStatus = _remainingSeconds % 5 == 0;

        if (callPaymentStatus) {
          _getPaymentStatus();
        }

        debugPrint('seconds left in testTempFile: $_remainingSeconds');
        if (_remainingSeconds < 1080 && _isLoadingPurchase == true) {
          //if two minutes passed
          setState(() {
            _isLoadingPurchase = false;
          });
        }
      } else {
        timer.cancel();
        setState(() {
          _isTimerPaymentStarted = false;
        });
        _showTimeUpDialog();
        _updateHistoryOrders();
      }
    });
  }

  void _getStarterTimer() {
    if (!_isTimerPaymentStarted) {
      _startTimerPayment();
    }
  }

  void _updateHistoryOrders() {
    debugPrint('update history orders was called');
    if (_isLoadingHistory) {
      debugPrint('get history was called');
      _getHistoryOrders();
    }
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("The waiting time has expired!"),
        content: const Text("The timer is over."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrenciesList() async {
    try {
      setState(() => _isLoadingPurchase = true);
      // await handleVerifiedAuthTokenAsync(ctx: context);
      final currencies = await PaymentRepository().getPaymentCurrency();

      setState(() {
        _avaliableCurrency = currencies;
        _isLoadingPurchase = false;
      });
    } catch (e) {
      debugPrint('Currency load error: $e');
    }
  }

  void _openPurchaseScreen() async {
    _closeEndDrawer();
    bool isPurchased = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseScreen(
          avaliableCurrency: _avaliableCurrency,
        ),
      ),
    );
    if (isPurchased) {
      _remainingSeconds = Database.get(Database.timerSeconds);
      _getStarterTimer();
      // _isLoadingHistory = isPurchased;
      _updateHistoryOrders();
    }
  }

  void _openSecondaryPurchaseScreen() async {
    _closeEndDrawer();

    PaymentStatus payment = await PaymentRepository().getPaymentStatus();
    debugPrint('sdksdlfdslf');
    if (_remainingSeconds > 2) {
      if (mounted) {
        bool isPurchased = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondPaymentScreen(
              payment: payment,
            ),
          ),
        );

        debugPrint(
            ' check isPurchased after close SecondPaymentScreen: $isPurchased');
        _getStarterTimer();
        // if (!_isTimerPaymentStarted) {
        //   _isTimerPaymentStarted = isPurchased;
        //   _startTimerPayment();
        // }
      }
    }
    else{
      _isLoadingHistory = true;
      _updateHistoryOrders();
    }
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  Future<void> _getHistoryOrders() async {
    try {
      final historyOrders = await PaymentRepository().getOrdersHistory();
      setState(() {
        _historyOrders = historyOrders;
        _isLoadingHistory = false;
      });
    } catch (e) {
      debugPrint('History load error: $e');
      setState(() {
        _isLoadingHistory = false;
      });
    }
  }

  Future<void> _getBallance() async {
    try {
      setState(() => _isLoadingHistory = true);
      // await handleVerifiedAuthTokenAsync(ctx: context);
      final balance = await PaymentRepository().getWalletBalance();
      setState(() {
        _walletBalance = balance.toString();
      });
    } catch (e) {
      // опціонально: обробка помилки
      debugPrint('Balance load error: $e');
      setState(() {
        _walletBalance = '--/--';
        
      });
    }
  }

  @override
  void initState() {
    // _getStarterTimer();
    _getBallance();
    _getHistoryOrders();
    _getCurrenciesList();
    _getPaymentStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Wallet',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Balance:'),
              Text(
                '\$ $_walletBalance ',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoadingPurchase ? null : _openPurchaseScreen,
                  icon: const Icon(Icons.arrow_downward),
                  label: const Text('New Purchase'),
                  iconAlignment: IconAlignment.end,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorTheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Wallet History'),
              Divider(
                color: colorTheme.primary,
              ),
              Expanded(
                  child: WalletHistoryList(
                      isLoadingHistory: _isLoadingHistory,
                      historyOrders: _historyOrders,
                      openSecondaryPurchaseScreen:
                          _openSecondaryPurchaseScreen)),
              ElevatedButton.icon(
                onPressed: () {
                  _closeEndDrawer();                 
                },
                icon: const Icon(Icons.close),
                label: const Text('Close Wallet'),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Temp Test File'),
        actions: [
          SizedBox(
            width: 50,
            child: IconButton(
              onPressed: () {
                _openEndDrawer();
              },
              icon: const Icon(Icons.wallet),
            ),
          ),
          SizedBox(
            width: 50,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is a temporary test file.'),
            ElevatedButton(
              onPressed: () {
                _openEndDrawer();
                // Add your action here
              },
              child: const Text('Click Me'),
            ),
            Container(
              height: 100,
              width: 100,
              color: colorTheme.onSecondary,
            )
          ],
        ),
      ),
    );
  }
}
