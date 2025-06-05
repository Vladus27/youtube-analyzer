import 'package:flutter/material.dart';
import 'package:youtube_analyzer/repositories/models/wallet.dart';

class WalletHistoryList extends StatelessWidget {
  const WalletHistoryList({
    super.key,
    required this.isLoadingHistory,
    required this.historyOrders,
    required this.openSecondaryPurchaseScreen,
  });
  final bool isLoadingHistory;
  final List<OrderHistory> historyOrders;
  final void Function() openSecondaryPurchaseScreen;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.only(right: 24),
      // padding: EdgeInsets.zero,
      children: [
        isLoadingHistory
            ? Center(
                heightFactor: 8,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colorTheme.primary),
                ),
              )
            : historyOrders.isNotEmpty && !isLoadingHistory
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: historyOrders.length,
                    itemBuilder: (context, index) {
                      String name = historyOrders[index].name;
                      String status = historyOrders[index].status;
                      String itemType = historyOrders[index].itemType;
                      String amount = historyOrders[index].amount.toString();
                      String updateAt = historyOrders[index].formattedData;

                      if (status != 'Done') {
                        return InkWell(
                          onTap: status == 'InProgress' ||
                                  status == 'Fail' ||
                                  status == 'Cancel'
                              ? null
                              : openSecondaryPurchaseScreen,
                          child: ListTile(
                              contentPadding: (status == 'New' ||
                                      status == 'Waiting' ||
                                      status == 'InProgress')
                                  ? const EdgeInsets.only(left: 3)
                                  : const EdgeInsets.only(left: 0),
                              leading: (status == 'New' ||
                                      status == 'Waiting' ||
                                      status == 'InProgress')
                                  ? Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: 1.0, // 100%
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  colorTheme.onPrimary),
                                        ),
                                        CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  colorTheme.primary),
                                        ),
                                        Icon(
                                            Icons
                                                .account_balance_wallet_outlined,
                                            color: colorTheme.primary),
                                      ],
                                    )
                                  : status == 'Fail'
                                      ? Icon(
                                          Icons.warning_amber_rounded,
                                          color: colorTheme.error,
                                          size: 36,
                                        )
                                      : status == 'Cancel'
                                          ? Icon(
                                              Icons.cancel_outlined,
                                              color: colorTheme.error,
                                              size: 36,
                                            )
                                          :
                                          // Icon(Icons.check_circle_outline_outlined);
                                          Icon(
                                              Icons
                                                  .account_balance_wallet_outlined,
                                              color: colorTheme.primary),
                              title: Row(
                                children: [
                                  Text(name, style: textTheme.bodyMedium),
                                  (status == 'Fail' ||
                                          status == 'Cancel' ||
                                          status == 'InProgress')
                                      ? const SizedBox.shrink()
                                      : Expanded(
                                          child: Text(
                                            ' +\$$amount',
                                            style: textTheme.bodySmall!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: colorTheme.primary),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                ],
                              ),
                              subtitle: status == 'Waiting' || status == 'New'
                                  ? const Text('Waiting for payment')
                                  : status == 'InProgress'
                                      ? const Text('In progress')
                                      : status == 'Fail'
                                          ? const Text('Payment failed')
                                          : status == 'Cancel'
                                              ? const Text('Payment cancelled')
                                              : Text(updateAt),
                              trailing: (status == 'InProgress' ||
                                      status == 'Fail' ||
                                      status == 'Cancel')
                                  ? Text(
                                      ' +\$$amount',
                                      style: textTheme.bodySmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: (status == 'Fail' ||
                                                  status == 'Cancel')
                                              ? colorTheme.error
                                              : colorTheme.primary),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const Icon(Icons.arrow_forward_ios)),
                        );
                      } else {
                        return ListTile(
                          title: Text(itemType),
                          subtitle: Text(updateAt),
                          trailing: Text(
                            '\$$amount',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        );
                      }
                    },
                  )
                : Opacity(
                    opacity: 0.5,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text("Wallet history is empty.",
                            style: textTheme.bodySmall),
                      ),
                    ),
                  ),
      ],
    );
  }
}
