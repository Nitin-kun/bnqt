import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final int totalCost;

  const PaymentScreen({required this.totalCost, super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Create a Razorpay instance
  Razorpay razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    // Attach Listeners for Payment Events
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccessHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentErrorHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);
  }

  void paymentSuccessHandler(PaymentSuccessResponse response) {
    print('Payment Successful: ${response.paymentId}');
  }

  void paymentErrorHandler(PaymentFailureResponse response) {
    print('Payment Error: ${response.code} - ${response.message}');
  }

  void externalWalletHandler(ExternalWalletResponse response) {
    print('External Wallet: ${response.walletName}');
  }

  void _openCheckout() {
    var options = {
      'key': 'rzp_test_cfvSjPoMfoPyDN',
      'amount': 2000,
      'name': 'Example Store',
      'description': 'Payment for your order',
      'prefill': {'contact': '8521188010', 'email': 'customer@example.com'},
    };
    try {
      razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Make a payment of ₹${widget.totalCost}",
              style: const TextStyle(fontSize: 18),
            ),
            ElevatedButton(
                onPressed: _openCheckout, child: const Text("payment"))
          ],
        ),
      ),
    );
  }
}
