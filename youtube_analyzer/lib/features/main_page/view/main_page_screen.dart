import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_analyzer/common/database.dart';

import 'package:youtube_analyzer/features/main_page/view/content_channel/view/content_channel_grid_view_screen.dart';
import 'package:youtube_analyzer/features/main_page/view/subscription_channels/view/subscription_channels_screen.dart';
import 'package:youtube_analyzer/features/main_page/view/wallet/view/second_payment_screen.dart';
import 'package:youtube_analyzer/features/main_page/view/wallet/view/purchase_screen.dart';
import 'package:youtube_analyzer/features/main_page/view/wallet/widgets/wallet_history_list.dart';

import 'package:youtube_analyzer/repositories/models/subscription_channel.dart'; //model
import 'package:youtube_analyzer/repositories/models/wallet.dart';
import 'package:youtube_analyzer/repositories/payment_repository.dart';
import 'package:youtube_analyzer/repositories/widgets/handle_verified_auth_token.dart';
import 'package:youtube_analyzer/repositories/youtube_repository.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<VideoContent> selectedContent = [];
  bool isLoading = false;
  String idChannel = '';
  String contentAuthor = '';

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

  void _disableButtonPurchase() {
    if (_remainingSeconds > 1080 || _isLoadingPurchase == false) {
      setState(() {
        _isLoadingPurchase = true;
      });
    } else {
      setState(() {
        _isLoadingPurchase = false;
      });
    }
  }


  void _printTextInDebugMode(String text){
  if (!kReleaseMode) {
    debugPrint(text);
  }  
}

  Future<void> _getPaymentStatus() async {
    final PaymentStatus? payment = await PaymentRepository().getPaymentStatus();
    if (payment == null) {
      // _timerPayment?.cancel();
      _isLoadingHistory = true;
      _updateHistoryOrders();
      return;
    } else {
      final paymnetUpdatedAt = payment.secondsUntilCancel;
      Database.set(Database.timerSeconds, paymnetUpdatedAt);
      final paymentStatus = payment.status;
      _printTextInDebugMode('Payment seconds until cancel: $paymnetUpdatedAt');
      _remainingSeconds = paymnetUpdatedAt;
      _printTextInDebugMode('check last payment status: $paymentStatus');

      bool statusWaiting = paymentStatus == 'Waiting' || paymentStatus == 'New';
      bool statusInProgress = paymentStatus == 'InProgress';
      bool statusResult = paymentStatus == 'Done';

      bool statusTracker = statusWaiting || statusInProgress;
      _printTextInDebugMode('_isTimerPaymentStarted: $_isTimerPaymentStarted');
      if (statusTracker) {
        _getStarterTimer();
        _isLoadingHistory = true;
        _updateHistoryOrders();
      } else {
        _timerPayment?.cancel();
        setState(() {
          _isLoadingHistory = true;
          _isTimerPaymentStarted = false;
        });
        _updateHistoryOrders();
        if (statusResult) {
          _timerPayment?.cancel();
          _getBallance();
          _isLoadingHistory = true;
          _updateHistoryOrders();
        }
      }
    }
  }

  void _startTimerPayment() {
    setState(() {
      // _printTextInDebugMode('')
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

        _printTextInDebugMode('seconds left in testTempFile: $_remainingSeconds');
        _printTextInDebugMode(' _isLoadingPurchase = $_isLoadingPurchase');
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
      _printTextInDebugMode('call startTimerPayment');
      _startTimerPayment();
    }
  }

  void _updateHistoryOrders() {
    _printTextInDebugMode('update history orders was called');
    if (_isLoadingHistory) {
      _printTextInDebugMode('get history was called');
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
      _printTextInDebugMode('Currency load error: $e');
    }
  }

  void _openPurchaseScreen() async {
    _closeEndDrawer();

    Payment? isPurchased = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurchaseScreen(
          avaliableCurrency: _avaliableCurrency,
        ),
      ),
    );

    if (isPurchased != null) {
      setState(() {
        _isLoadingPurchase = true;
      });
      _remainingSeconds = Database.get(Database.timerSeconds);
      _getStarterTimer();
      // _isLoadingHistory = isPurchased;
      _updateHistoryOrders();
    }
  }

  void _openSecondaryPurchaseScreen() async {
    _closeEndDrawer();

    PaymentStatus payment = await PaymentRepository().getPaymentStatus();
    _printTextInDebugMode('sdksdlfdslf');
    if (_remainingSeconds > 2) {
      if (mounted) {
        Payment? isPurchased = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondPaymentScreen(
              payment: payment,
            ),
          ),
        );

        _printTextInDebugMode(
            ' check isPurchased after close SecondPaymentScreen: $isPurchased');
        _getStarterTimer();
        // if (!_isTimerPaymentStarted) {
        //   _isTimerPaymentStarted = isPurchased;
        //   _startTimerPayment();
        // }
      }
    } else {
      _isLoadingPurchase = false;
      // _getPaymentStatus();
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
      _printTextInDebugMode('History load error: $e');
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
      _printTextInDebugMode('Balance load error: $e');
      setState(() {
        _walletBalance = '--/--';
      });
    }
  }

  void _selectedContent(String selectedYoutuber, [String channelName = '']) {
    setState(() {
      selectedContent = [];
      isLoading = true;
    });
    _loadVideos(selectedYoutuber, channelName);
  }

  Future<void> _loadVideos(String channelId, String channelName) async {
    await handleVerifiedAuthTokenAsync(ctx: context);
    List<VideoContent> videos =
        await YoutubeRepository().getChannelVideos(channelId);
    setState(() {
      idChannel = channelId;
      selectedContent = videos;
      isLoading = false;
      contentAuthor = channelName;
    });
  }

  void _handleVerifCode() async {
    await handleVerifiedAuthTokenAsync(ctx: context);
  }

  @override
  void initState() {
    _handleVerifCode();
    _getBallance();
    _disableButtonPurchase();
    _getHistoryOrders();
    _getCurrenciesList();
    _getPaymentStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    _printTextInDebugMode('user auth token: ${Database.get(Database.personAuthTokenKey)}');
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
                  style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Balance:'),
              Text(
                '\$ $_walletBalance ',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
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
        title: const Text('Analyzer'),
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
      body: Row(
        children: [
          Expanded(
              flex: 2,
              child: SubscriptionsChannelsScreen(
                onSelectedChannelsContent: _selectedContent,
              )),
          Expanded(
            flex: 9,
            child: ContentChannelGridViewScreen(
              youtubersContent: selectedContent,
              channelId: idChannel,
              isLoading: isLoading,
              contentAuthor: contentAuthor,
            ),
          ),
        ],
      ),
    );
  }
}
