// import 'package:flutter/material.dart';

// class WalletDrawer extends StatefulWidget {
//   const WalletDrawer({super.key, required this.walletBalance});

//   final String walletBalance;

//   @override
//   State<WalletDrawer> createState() => _WalletDrawerState();
// }

// class _WalletDrawerState extends State<WalletDrawer> {
//   bool isLoadingPurchase = false;


//   @override
//   Widget build(BuildContext context) {
//     final colorTheme = Theme.of(context).colorScheme;
//     return Drawer(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text('Wallet',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//             const Text('Balance:'),
//             Text(
//               '\$ ${widget.walletBalance} ',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 48,
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: isLoadingPurchase ? null : _openPurchaseScreen,
//                 icon: const Icon(Icons.arrow_downward),
//                 label: const Text('New Purchase'),
//                 iconAlignment: IconAlignment.end,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: colorTheme.onPrimary,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text('Wallet History'),
//             Divider(
//               color: colorTheme.primary,
//             ),
//             Expanded(
//                 child: WalletHistoryList(
//                     isLoadingHistory: _isLoadingHistory,
//                     historyOrders: _historyOrders,
//                     openSecondaryPurchaseScreen: _openSecondaryPurchaseScreen)),
//             ElevatedButton.icon(
//               onPressed: () {
//                 _closeEndDrawer();
//               },
//               icon: const Icon(Icons.close),
//               label: const Text('Close Wallet'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
