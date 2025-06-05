import 'package:youtube_analyzer/repositories/models/wallet.dart';
import 'package:youtube_analyzer/repositories/payment_repository.dart';

Future<bool> _getPaymentStatus() async {
  final payment = await PaymentRepository().getPaymentStatus();
  if (payment != null) {
    PaymentStatus paymentStatus = payment;
    final String status = paymentStatus.statusValue;

    bool statusWaiting = status == 'Waiting' || status == 'New';

    bool statusInProgress = status == 'InProgress';

    bool statusDone = status == 'Done';
    // _isTimerStarted = statusWaiting ? true : false;

    if (statusWaiting) {
      // _timer?.cancel();
      // _isTimerStarted = false;
      return true;
    }
    if (statusInProgress) {
      // _isTimerStarted = true;
      // setState(() {
      //   _isLoadingPurchase = false;
      // });
      return true;
    }
    if (statusDone) {
      return true;
    }
    return false;
  }
  return false;
}

void _dummyFunc(bool check)  {
  String statusWaiting = 'Waiting';
  String statusInProgress = 'InProgress';
  String statusDone = 'Done';

  String status = 'Done';

  bool checkPaymentStatus = check;

  while (checkPaymentStatus) {
    Future.delayed(const Duration(seconds: 5), () async {
      bool statusPayment =
          status == statusWaiting || status == statusInProgress;

      if (statusPayment) {
        checkPaymentStatus = await _getPaymentStatus();
      }
      else{
        checkPaymentStatus = false;
      }
      
    });
  }
}

class DummyTestData {
  static List<PaymentCurrency> getAvailableCurrencies() {
    return [
      PaymentCurrency(
        code: 'USD',
        name: 'United States Dollar',
        minAmount: 10,
        logoUrl: 'lib/assets/image.png',
        network: 'Ethereum',
        networkColor: '#53AED4',
      ),
      PaymentCurrency(
        code: 'EUR',
        name: 'Euro',
        minAmount: 10,
        logoUrl: 'lib/assets/image.png',
        network: 'Ethereum',
        networkColor: '#53AED4',
      ),
      PaymentCurrency(
        code: 'GBP',
        name: 'British Pound Sterling',
        minAmount: 10,
        logoUrl: 'lib/assets/image.png',
        network: 'Ethereum',
        networkColor: '#53AED4',
      ),
      PaymentCurrency(
        code: 'JPY',
        name: 'Japanese Yen',
        minAmount: 10,
        logoUrl: 'lib/assets/image.png',
        network: 'Ethereum',
        networkColor: '#53AED4',
      ),
      PaymentCurrency(
        code: 'AUD',
        name: 'Australian Dollar',
        minAmount: 39,
        // logoUrl: 'lib/assets/image.png',
        logoUrl: 'https://nowpayments.io/images/coins/dai.svg',
        network: 'Ethereum',
        networkColor: '#53AED4',
      ),
    ];
  }

  static List<OrderHistory> getHistoryOrders() {
    return [
      OrderHistory(
        itemType: 'Wallet Reliff',
        amount: 999999.99,
        currency: 'USD',
        status: 'New',
        updateAt: 1748450089376,
      ),
      OrderHistory(
        itemType: 'Wallet Reliff',
        amount: 100.99,
        currency: 'USD',
        status: 'Done',
        updateAt: 1748450089376,
      ),
      OrderHistory(
        itemType: 'Wallet Reliff',
        amount: 323.99,
        currency: 'USD',
        status: 'Fail',
        updateAt: 1748450089376,
      ),
      OrderHistory(
        itemType: 'Wallet Reliff',
        amount: 324.99,
        currency: 'USD',
        status: 'Cancel',
        updateAt: 1748450089376,
      ),
      OrderHistory(
        itemType: 'Wallet Reliff',
        amount: 34.99,
        currency: 'USD',
        status: 'Cancel',
        updateAt: 1748450089376,
      ),
      OrderHistory(
        itemType: 'Wallet Reliff',
        amount: 932499.99,
        currency: 'USD',
        status: 'Cancel',
        updateAt: 1748450089376,
      ),
      OrderHistory(
        itemType: 'Wallet Reliff',
        amount: 200.99,
        currency: 'USD',
        status: 'InProgress',
        updateAt: 1748450089376,
      ),
      OrderHistory(
        itemType: 'Subscription',
        amount: 10.0,
        currency: 'USD',
        status: 'Waiting',
        updateAt: 1748450089376,
      ),
      // OrderHistory(
      //   itemType: 'Subscription',
      //   amount: 20.0,
      //   currency: 'USD',
      //   status: 'Completed',
      //   updateAt: 2023 - 10 - 02,
      // ),
      // OrderHistory(
      //   itemType: 'Subscription',
      //   amount: 30.0,
      //   currency: 'USD',
      //   status: 'Completed',
      //   updateAt: 2023 - 10 - 03,
      // ),
      // OrderHistory(
      //   itemType: 'Subscription',
      //   amount: 40.0,
      //   currency: 'USD',
      //   status: 'Completed',
      //   updateAt: 2023 - 10 - 04,
      // ),
      // OrderHistory(
      //   itemType: 'Subscription',
      //   amount: 50.0,
      //   currency: 'USD',
      //   status: 'Completed',
      //   updateAt: 2023 - 10 - 05,
      // ),
      // OrderHistory(
      //   itemType: 'Subscription',
      //   amount: 10.0,
      //   currency: 'USD',
      //   status: 'Completed',
      //   updateAt: 2023 - 10 - 01,
      // ),
      // OrderHistory(
      //   itemType: 'Subscription',
      //   amount: 10.0,
      //   currency: 'USD',
      //   status: 'Completed',
      //   updateAt: 2023 - 10 - 01,
      // ),
      // OrderHistory(
      //   itemType: 'Subscription',
      //   amount: 10.0,
      //   currency: 'USD',
      //   status: 'Completed',
      //   updateAt: 2023 - 10 - 01,
      // ),
      // OrderHistory(
      //   itemType: 'Subscription',
      //   amount: 10.0,
      //   currency: 'USD',
      //   status: 'Completed',
      //   updateAt: 2023 - 10 - 01,
      // ),
      // OrderHistory(
      //   itemType: 'Subscription',
      //   amount: 10.0,
      //   currency: 'USD',
      //   status: 'Completed',
      //   updateAt: 2023 - 10 - 01,
      // ),
      // OrderHistory(
      //   itemType: 'Subscription',
      //   amount: 10.0,
      //   currency: 'USD',
      //   status: 'Completed',
      //   updateAt: 2023 - 10 - 01,
      // ),
    ];
  }
}
