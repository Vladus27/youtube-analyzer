import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:youtube_analyzer/repositories/models/wallet.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({
    super.key,
    required this.paymentOrder,

    required this.copyToClipboard,
  });
  final Payment? paymentOrder;
  final void Function(String copiedText) copyToClipboard;

  @override
  Widget build(BuildContext context) {
    final ColorScheme clrScreme = Theme.of(context).colorScheme;
    final TextTheme txtTheme = Theme.of(context).textTheme;
    final logo = paymentOrder!.logoUrl;
    final payAddress = paymentOrder!.payAddress;
    final priceUsd = paymentOrder!.priceUsd.toString();
    final priceAmount = paymentOrder!.priceAmount.toString();
    final currency = paymentOrder!.payCurrency.toUpperCase();
    final network = paymentOrder!.network;
    final networkColor = paymentOrder!.getNetworkColor();



    return Column(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            QrImageView(
              embeddedImage: AssetImage(logo),              
              data: payAddress,
              errorCorrectionLevel: QrErrorCorrectLevel.H,

              size: 240,
              version: QrVersions.auto,
              backgroundColor: clrScreme.primary,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Row(
                      children: [
                        Text(
                          'Deposit amount',
                          style: txtTheme.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          '~\$$priceUsd',
                          // style: Theme.of(context).textTheme.bodySmall,
                          style: txtTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      SelectableText(
                        '$priceAmount $currency',
                        style: txtTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              // color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: networkColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          network.toUpperCase(),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          copyToClipboard(
                            priceAmount,
                          );
                        },
                        icon: Icon(
                          Icons.copy,
                          size: Theme.of(context).iconTheme.size,
                          color: clrScreme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      'Wallet address',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SelectableText(
                              payAddress,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    // color: Theme.of(context).colorScheme.primary,
                                  ),
                              // maxLines: 3,
                              // softWrap: true,
                              //  overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          copyToClipboard(payAddress);
                        },
                        icon: Icon(
                          Icons.copy,
                          size: Theme.of(context).iconTheme.size,
                          color: clrScreme.primary,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton.icon(
            iconAlignment: IconAlignment.start,
            icon: const Icon(Icons.home),
            label: const Text('Home Page'),
            onPressed: () {
              Navigator.of(context).pop(paymentOrder);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: clrScreme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
