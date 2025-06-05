import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:youtube_analyzer/repositories/models/wallet.dart';

class SelectPaymentScreen extends StatefulWidget {
  const SelectPaymentScreen(
      {super.key,
      required this.value,
      required this.avaliableCurrency,
      // required this.onChanged,
      required this.onSelected,
      required this.minAmountController,
      required this.formKey,
      // required this.postPayment
      required this.handlePurchase});
  final int? value;
  final List<PaymentCurrency> avaliableCurrency;
  // final void Function(Payment payment) onChanged;
  final Function(int) onSelected;
  final TextEditingController minAmountController;
  final GlobalKey<FormState> formKey;
  // final Future<Payment> Function(String payCurrency, double priceUsd)
  //     postPayment;
  final Future<void> Function(
      {required bool isLoading,
      required String payCurrency,
      required String priceUsd}) handlePurchase;

  @override
  State<SelectPaymentScreen> createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final int requiredMinAmount =
        widget.avaliableCurrency[widget.value!].minAmount;

    Future<void> handlePurchaseFunc() async {
      setState(() {
        isLoading = true;
      });
      if (widget.formKey.currentState?.validate() ?? false) {
        debugPrint(
            'type of entred amount ${widget.minAmountController.text}: ${widget.minAmountController.text.runtimeType}');
        debugPrint(
            'type of entered currency ${widget.avaliableCurrency[widget.value!].code}: ${widget.avaliableCurrency[widget.value!].code.runtimeType}');
        await widget.handlePurchase(
            isLoading: isLoading,
            payCurrency: widget.avaliableCurrency[widget.value!].code,
            priceUsd: widget.minAmountController.text);
      } else {
        setState(() {
          isLoading = true;
        });
      }
    }

    final ColorScheme clrScreme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Select payment method',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Form(
                key: widget.formKey,
                child: TextFormField(
                  controller: widget.minAmountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    IntegerPartLengthLimitingFormatter(4),
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^\d*\.?\d{0,2}')), // allow only 2 decimal places
                    NoLeadingZeroExceptDecimalFormatter(),
                  ],
                  decoration: const InputDecoration(
                    prefixText: '\$',
                    labelText: 'Enter amount',
                    hintText: 'xxxx.xx',
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a number';
                    }
                    final parsed = double.tryParse(value);
                    if (parsed! < requiredMinAmount) {
                      return 'Minimum amount \nfor this network is $requiredMinAmount';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 3,
              child: DropdownButton<int>(
                isExpanded: true,
                underline: const SizedBox.shrink(),
                borderRadius: BorderRadius.circular(24),
                alignment: AlignmentDirectional.center,
                value: widget.value,
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    widget.onSelected(newValue);
                  }
                },
                items: List.generate(widget.avaliableCurrency.length, (index) {
                  final currency = widget.avaliableCurrency[index];
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // SvgPicture.asset(
                        //   CurrencyImages.daiSvg,
                        //   height: 36,
                        // ),
                        Image.asset(
                          currency.logoUrl,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(currency.code,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                                const SizedBox(
                                  width: 4,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        'FF${currency.networkColor.replaceAll('#', '')}',
                                        radix: 16)),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    currency.network.toUpperCase(),
                                  ),
                                ),
                              ],
                            ),
                            Opacity(
                              opacity: 0.5,
                              child: Text(
                                currency.name,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    iconAlignment: IconAlignment.end,
                    icon:
                        isLoading ? null : const Icon(Icons.arrow_forward_ios),
                    label: isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                clrScreme.primary),
                          )
                        : const Text('Next Step'),
                    onPressed: isLoading ? null : handlePurchaseFunc,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: clrScreme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )),
            ),
            SizedBox(
              height: 52,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class NoLeadingZeroExceptDecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Дозволяємо "0" або "0.XX"
    if (text == '0' || text.startsWith('0.')) {
      return newValue;
    }
    // Забороняємо декілька нулів на початку (наприклад, "00", "0001")
    if (text.length > 1 && text.startsWith('0')) {
      return oldValue;
    }
    return newValue;
  }
}

class IntegerPartLengthLimitingFormatter extends TextInputFormatter {
  final int maxLength;
  IntegerPartLengthLimitingFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final parts = text.split('.');
    if (parts[0].length > maxLength) {
      return oldValue;
    }
    return newValue;
  }
}
