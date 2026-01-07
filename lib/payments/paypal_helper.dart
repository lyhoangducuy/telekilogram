import 'package:flutter/material.dart';
import 'package:paypal_checkout/paypal_checkout.dart';
import 'paypal_config.dart';

class PayPalHelper {
  static Future<void> pay({
    required BuildContext context,
    required double amount,
    required VoidCallback onPaid,
  }) async {
    final amt = amount.toStringAsFixed(2);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PayPalPaymentScreen(
          sandboxMode: PayPalConfig.sandboxMode,
          checkOutType: CheckOutType.paypal,
          clientId: PayPalConfig.clientId,
          secretKey: PayPalConfig.secretKey,
          currency: PayPalConfig.currency,
          amount: amt,
          returnURL: PayPalConfig.returnURL,
          cancelURL: PayPalConfig.cancelURL,
          onSuccess: (data) {
            onPaid();
            Navigator.pop(context);
          },
          onCancel: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Bạn đã hủy PayPal")),
            );
            Navigator.pop(context);
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("PayPal lỗi ❌ $error")),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
