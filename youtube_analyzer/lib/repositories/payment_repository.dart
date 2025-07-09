import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_analyzer/assets/currency_images.dart';

import 'package:youtube_analyzer/repositories/models/environment.dart';
import 'package:youtube_analyzer/common/database.dart';
import 'package:youtube_analyzer/repositories/models/wallet.dart';






class PaymentRepository {
void _printTextInDebugMode(String text){
  if (!kReleaseMode) {
    debugPrint(text);
  }  
}

  final String _basicUrl = Environment.apiUrl;
  final Map<String, String> _localLogos = {
    'DAI': CurrencyImages.dai,
    'USDTERC20': CurrencyImages.usdtErc,
    'USDC': CurrencyImages.usdc,
    'USDTBSC': CurrencyImages.usdtBsc,
    'USDTSOL': CurrencyImages.usdtSol,
    'USDCBSC': CurrencyImages.usdcBsc,
  };

  Future<List<OrderHistory>> getOrdersHistory() async {
    List<OrderHistory> historyOrders = [];
    final token = await Database.get(Database.personAuthTokenKey);  
    final url = Uri.https(_basicUrl, "/api/Wallet/orders-history");

    final response = await http.get(
      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': token,
      },
    );
    final data = json.decode(response.body);
    if (data['isOk']) {
      final dataValue = data['value']['items'] as List<dynamic>;
      historyOrders = dataValue.map<OrderHistory>((e) {
        return OrderHistory.fromJson(e as Map<String, dynamic>);
      }).toList();
      return historyOrders;
    } else {
      _printTextInDebugMode('Failed to fetch orders history');
      return historyOrders;
    }
  }

  Future<double> getWalletBalance() async {
    final token = await Database.get(Database.personAuthTokenKey);
    
    final url = Uri.https(_basicUrl, "/api/Wallet/balance");
    final response = await http.get(
      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': token,
      },
    );
    final data = json.decode(response.body);

    final dataBalance = data['value']['balance'] as double;
    _printTextInDebugMode('Wallet balance: $dataBalance');
    return dataBalance;
  }

  Future<Payment?> postPayment(String payCurrency, String priceUsd) async {
    final token = await Database.get(Database.personAuthTokenKey);
    final url = Uri.https(_basicUrl, "/api/Wallet/payment");
    try {
      final response = await http.post(
        url,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Origin': 'nowpayments.io',
          'x-service-name': 'SocialMediaApi',
          'x-token': token,
          'Content-Type': 'application/json', // Додаємо цей заголовок!
        },
        body: json.encode({
          'payCurrency': payCurrency,
          'priceUsd': double.tryParse(priceUsd), // якщо сервер хоче число
        }),
      );
      if (response.statusCode == 429) {
        return null;
      }
      final data = json.decode(response.body);
      final dataValue = data['value'];
      if (data['isOk']) {
        final Payment payment = Payment.fromJson(dataValue);

        final localLogo = _localLogos[payment.payCurrency.toUpperCase()];
        return localLogo != null
            ? payment.copyWith(
                logoUrl: localLogo,
              )
            : payment;
      }
    } catch (e) {
      _printTextInDebugMode('post payment error: $e');
      return null;
    }
    return null;
  }

  Future getPaymentStatus() async {
    final token = await Database.get(Database.personAuthTokenKey);
    final url = Uri.https(_basicUrl, "/api/Wallet/payment-status");
    try{
    final response = await http.get(  

      url,
      headers: {
        'x-service-name': 'SocialMediaApi',
        'x-token': token,
      },
    );

    if (response.statusCode != 200) {
      _printTextInDebugMode('getPaymentStatus error: ${response.statusCode}');
      _printTextInDebugMode('getPaymentStatus body: ${response.body}'); // <-- тут буде причина
      return null;
    }

    final data = json.decode(response.body);
    final dataValue = data['value'];
    if (dataValue == null) {
      return null;
    } else {
      final PaymentStatus paymentStatus = PaymentStatus.fromJson(dataValue);
      final localLogo = _localLogos[paymentStatus.payCurrency.toUpperCase()];
      return localLogo != null
          ? paymentStatus.copyWith(
              logoUrl: localLogo,
            )
    
          : paymentStatus;
      // PaymentCurrency(
      //     code: currency.code,
      //     name: currency.name,
      //     minAmount: currency.minAmount,
      //     logoUrl: localLogo,
      //     network: currency.network,
      //     networkColor: currency.networkColor,
      //   )
    }} catch(e){
      _printTextInDebugMode('get payment status error: $e');
    }
  }

  Future<List<PaymentCurrency>> getPaymentCurrency() async {
    List<PaymentCurrency> paymentCurrencies = [];
    final token = await Database.get(Database.personAuthTokenKey);
    
    final url = Uri.https(_basicUrl, "/api/Wallet/payment-currency");
    final response = await http.get(
      url,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Origin': 'nowpayments.io',
        'x-service-name': 'SocialMediaApi',
        'x-token': token,
      },
    );
    final data = json.decode(response.body);
    if (!data['isOk']) {
      _printTextInDebugMode('getting payment currency failed');
      return paymentCurrencies;
    }

    final dataValue = data['value'] as Map<String, dynamic>;
    final dataItems = dataValue['items'] as List<dynamic>;
    paymentCurrencies = dataItems.map<PaymentCurrency>((e) {
      final currency = PaymentCurrency.fromJson(e);

      final localLogo = _localLogos[currency.code.toUpperCase()];
      return localLogo != null
          ? currency.copyWith(
              logoUrl: localLogo,
            )
          // PaymentCurrency(
          //     code: currency.code,
          //     name: currency.name,
          //     minAmount: currency.minAmount,
          //     logoUrl: localLogo,
          //     network: currency.network,
          //     networkColor: currency.networkColor,
          //   )
          : currency;
    }).toList();
    _printTextInDebugMode('Payment currencies loaded: ${paymentCurrencies.length}');
    _printTextInDebugMode(
        'Payment currencies: ${paymentCurrencies.map((e) => e.name).join(', ')}');

    return paymentCurrencies;
  }
}
