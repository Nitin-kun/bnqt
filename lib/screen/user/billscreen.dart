import 'package:flutter/material.dart';
import 'package:lakebenquet/widgets/button.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BillScreen extends StatefulWidget {
  final String selectedEventTypes;
  final List<DateTime> selectedDates;
  final List<String> selectedServices;
  final int totalCost;

  const BillScreen({
    required this.selectedServices,
    required this.totalCost,
    required this.selectedDates,
    required this.selectedEventTypes,
    super.key,
  });

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final Razorpay razorpay = Razorpay();

  // Initiates a phone call
  Future<void> _makingPhoneCall() async {
    final Uri url = Uri.parse("tel:+919110171984");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccessHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentErrorHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  void paymentSuccessHandler(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
    );
  }

  void paymentErrorHandler(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.message}')),
    );
  }

  void externalWalletHandler(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  void _openCheckout() {
    final options = {
      'key': 'rzp_test_cfvSjPoMfoPyDN',
      'amount': widget.totalCost * 100, // Convert to paise
      'name': 'Lake garden banquet',
      'description': 'Payment for your event booking',
      'prefill': {'contact': '8521188010', 'email': 'customer@example.com'},
      'theme': {'color': '#5D1049'},
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
        title: const Text("Billing Summary"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Event Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const Divider(),
            Text(
              "Event Type: ${widget.selectedEventTypes}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Dates: ${widget.selectedDates.map((date) => "${date.day}/${date.month}/${date.year}").join(", ")}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Selected Services: ${widget.selectedServices.join(", ")}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Total Cost: ₹${widget.totalCost}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: BnqtButton(
                    text: "Talk to Executive",
                    onPressed: _makingPhoneCall,
                    verticalPadding: 22,
                    icon: Icons.call,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openCheckout,
                    icon: const Icon(Icons.payment),
                    label: const Text("Make Payment"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
