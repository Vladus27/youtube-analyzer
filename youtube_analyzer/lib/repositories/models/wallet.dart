import 'dart:ui';
import 'package:intl/intl.dart';

class OrderHistory {
  OrderHistory({
    this.name = 'Wallet Refill',
    required this.itemType,
    required this.amount,
    required this.currency,
    required this.status,
    required this.updateAt,
  });
  final String name;
  final String itemType;

  final double amount;
  final String currency;
  final String status;
  final int updateAt;

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      itemType: json['itemType'] as String,
      amount: json['amount'] as double,
      currency: json['currency'] as String,
      status: json['status'] as String,
      updateAt: json['updateAt'] as int,
    );
  }

  String get formattedData {
    final dateUtc = DateTime.fromMillisecondsSinceEpoch(updateAt, isUtc: true);
    final dateLocal = dateUtc.toLocal();
    final formatted = DateFormat('dd MMM yyyy, HH:mm').format(dateLocal);

    return formatted;
  }
}

class Payment {
  Payment({
    required this.payAddress,
    required this.priceUsd,
    required this.priceAmount,
    required this.priceCurrency,
    required this.payCurrency,
    required this.logoUrl,
    required this.network,
    required this.networkColor,
    required this.updatedAt,
  });
  final String payAddress;
  final String priceUsd;
  final String priceAmount;
  final String priceCurrency;
  final String payCurrency;
  final String logoUrl;
  final String network;
  final String networkColor;
  final int updatedAt;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      payAddress: json['payAddress'] as String,
      priceAmount: json['priceAmount'] as String,
      priceCurrency: json['priceCurrency'] as String,
      priceUsd: json['priceUsd'] as String,
      payCurrency: json['payCurrency'] as String,
      logoUrl: json['logoUrl'] as String,
      network: json['network'] as String,
      networkColor: json['networkColor'] as String,
      updatedAt: json['updatedAt'] as int,
    );
  }
  Payment copyWith(
      {String? payAddress,
      String? priceUsd,
      String? priceAmount,
      String? priceCurrency,
      String? payCurrency,
      String? logoUrl,
      String? network,
      String? networkColor,
      int? updatedAt}) {
    return Payment(
        payAddress: payAddress ?? this.payAddress,
        priceUsd: priceUsd ?? this.priceUsd,
        priceAmount: priceAmount ?? this.priceAmount,
        priceCurrency: priceCurrency ?? this.priceCurrency,
        payCurrency: payCurrency ?? this.payCurrency,
        logoUrl: logoUrl ?? this.logoUrl,
        network: network ?? this.network,
        networkColor: networkColor ?? this.networkColor,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  Color getNetworkColor() {
    return Color(int.parse('FF${networkColor.replaceAll('#', '')}', radix: 16));
  }

  @override
  String toString() {
    return 'Payment('
        'payAddress: $payAddress, '
        'priceUsd: $priceUsd, '
        'priceAmount: $priceAmount, '
        'priceCurrency: $priceCurrency, '
        'payCurrency: $payCurrency, '
        'logoUrl: $logoUrl,'
        'network: $network, '
        'networkColor: $networkColor,) ';
  }
}

class PaymentStatus {
  PaymentStatus({
    required this.status,
    required this.payAddress,
    required this.priceUsd,
    required this.priceAmount,
    required this.priceCurrency,
    required this.payCurrency,
    required this.logoUrl,
    required this.network,
    required this.networkColor,
    required this.updatedAt,
    this.text,
  });
  final String status;
  final String payAddress;
  final String priceUsd;
  final String priceAmount;
  final String priceCurrency;
  final String payCurrency;
  final String logoUrl;
  final String network;
  final String networkColor;
  final int updatedAt;
  final String? text;

  factory PaymentStatus.fromJson(Map<String, dynamic> json) {
    return PaymentStatus(
      status: json['status'] as String,
      payAddress: json['payAddress'] as String,
      priceAmount: json['priceAmount'] as String,
      priceCurrency: json['priceCurrency'] as String,
      priceUsd: json['priceUsd'] as String,
      payCurrency: json['payCurrency'] as String,
      logoUrl: json['logoUrl'] as String,
      network: json['network'] as String,
      networkColor: json['networkColor'] as String,
      updatedAt: json['updatedAt'] as int,
      text: json['text'] as String?,
    );
  }
  PaymentStatus copyWith({
    String? status,
    String? payAddress,
    String? priceUsd,
    String? priceAmount,
    String? priceCurrency,
    String? payCurrency,
    String? logoUrl,
    String? network,
    String? networkColor,
    int? updatedAt,
    String? text,
  }) {
    return PaymentStatus(
        status: status ?? this.status,
        payAddress: payAddress ?? this.payAddress,
        priceUsd: priceUsd ?? this.priceUsd,
        priceAmount: priceAmount ?? this.priceAmount,
        priceCurrency: priceCurrency ?? this.priceCurrency,
        payCurrency: payCurrency ?? this.payCurrency,
        logoUrl: logoUrl ?? this.logoUrl,
        network: network ?? this.network,
        networkColor: networkColor ?? this.networkColor,
        updatedAt: updatedAt ?? this.updatedAt,
        text: text ?? this.text);
  }

  String get statusValue => status;

  Color getNetworkColor() {
    return Color(int.parse('FF${networkColor.replaceAll('#', '')}', radix: 16));
  }

  int get secondsUntilCancel {
    const int cancelDelaySeconds = 1200; // 20 min
    // Час оновлення ордера в UTC
    final updateUtc =
        DateTime.fromMillisecondsSinceEpoch(updatedAt, isUtc: true);
    // Поточний час в UTC
    final nowUtc = DateTime.now().toUtc();
    // Скільки секунд минуло з моменту updateAt
    final elapsedSeconds = nowUtc.difference(updateUtc).inSeconds;
    // Обчислюємо, скільки секунд залишилось до автоскасування
    final remaining = cancelDelaySeconds - elapsedSeconds;
    // Повертаємо або залишок, або 0 (щоб не було від’ємного значення)
    return remaining > 0 ? remaining : 0;
  }
}

class PaymentCurrency {
  PaymentCurrency({
    required this.code,
    required this.name,
    required this.minAmount,
    required this.logoUrl,
    required this.network,
    required this.networkColor,
  });
  final String code;
  final String name;
  final int minAmount;
  final String logoUrl;
  final String network;
  final String networkColor;

  factory PaymentCurrency.fromJson(Map<String, dynamic> json) {
    return PaymentCurrency(
      code: json['code'] as String,
      name: json['name'] as String,
      minAmount: json['minAmount'] as int,
      logoUrl: json['logoUrl'] as String,
      network: json['network'] as String,
      networkColor: json['networkColor'] as String,
    );
  }

  PaymentCurrency copyWith({
    String? code,
    String? name,
    int? minAmount,
    String? logoUrl,
    String? network,
    String? networkColor,
  }) {
    return PaymentCurrency(
      code: code ?? this.code,
      name: name ?? this.name,
      minAmount: minAmount ?? this.minAmount,
      logoUrl: logoUrl ?? this.logoUrl,
      network: network ?? this.network,
      networkColor: networkColor ?? this.networkColor,
    );
  }

  Color getNetworkColor() {
    return Color(int.parse('FF${networkColor.replaceAll('#', '')}', radix: 16));
  }
}
