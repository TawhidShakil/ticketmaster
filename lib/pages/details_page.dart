import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';

class DeatilPage extends StatefulWidget {
  final Map<String, dynamic> event;
  const DeatilPage({super.key, required this.event});

  @override
  State<DeatilPage> createState() => _DeatilPageState();
}

class _DeatilPageState extends State<DeatilPage> {
  int ticketCount = 1;
  bool isProcessing = false;
  final supabase = Supabase.instance.client;

  // 🔐 SSLCommerz Credentials
  final String storeId = "testbox"; // Change to your Store ID for production
  final String storePassword = "qwerty"; // Change to your Store Password
  final bool isSandbox = true; // Set false for production

  // Generate unique transaction ID
  String generateTransactionId() {
    return "TXN${DateTime.now().millisecondsSinceEpoch}";
  }

  // Show message to user
  void showMessage(String message, {Color? bgColor}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor ?? Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Initiate Payment
  Future<void> initiatePayment() async {
    // Check if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showMessage("Please login first!", bgColor: Colors.red);
      return;
    }

    setState(() => isProcessing = true);

    try {
      final int price = widget.event['price'] ?? 0;
      final int totalAmount = price * ticketCount;
      final String transactionId = generateTransactionId();

      print("🔹 Starting payment...");
      print("Transaction ID: $transactionId");
      print("Amount: ৳$totalAmount");

      // Initialize SSLCommerz
      Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          sdkType: isSandbox ? SSLCSdkType.TESTBOX : SSLCSdkType.LIVE,
          store_id: storeId,
          store_passwd: storePassword,
          total_amount: totalAmount.toDouble(),
          currency: SSLCurrencyType.BDT,
          tran_id: transactionId,
          product_category: "Ticket",
        ),
      );

      // Add customer information (Required for SSLCommerz)
      sslcommerz.addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
          customerName: user.displayName ?? "Guest User",
          customerEmail: user.email ?? "guest@example.com",
          customerAddress1: "Dhaka, Bangladesh",
          customerCity: "Dhaka",
          customerPostCode: "1207",
          customerCountry: "Bangladesh",
          customerPhone: user.phoneNumber ?? "01700000000",
          customerState: "Dhaka",
        ),
      );

      print("🔹 Launching SSLCommerz payment gateway...");

      // Launch payment gateway
      SSLCTransactionInfoModel result = await sslcommerz.payNow();

      print("🔹 Payment Result: ${result.status}");

      // Handle payment result
      if (result.status?.toLowerCase() == "closed") {
        showMessage("Payment cancelled by user", bgColor: Colors.orange);
      } else if (result.status?.toLowerCase() == "failed") {
        showMessage(
          "Payment failed: ${result.status ?? 'Unknown error'}",
          bgColor: Colors.red,
        );
      } else if (result.status?.toLowerCase() == "valid" ||
          result.status?.toLowerCase() == "validated") {
        // Payment successful - Save booking
        print("✅ Payment successful! Saving booking...");
        await saveBooking(transactionId, totalAmount, result);

        showMessage(
          "Payment Successful! Booking confirmed.",
          bgColor: Colors.green,
        );

        // Wait a moment then go back
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context);
      } else {
        showMessage(
          "Payment status: ${result.status ?? 'Unknown'}",
          bgColor: Colors.orange,
        );
      }
    } catch (e) {
      print("❌ Payment Error: $e");
      showMessage("Payment error: ${e.toString()}", bgColor: Colors.red);
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  // Save booking to Supabase
  Future<void> saveBooking(
    String transactionId,
    int totalAmount,
    SSLCTransactionInfoModel result,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;

      await supabase.from('bookings').insert({
        'user_id': user.uid,
        'user_email': user.email,
        'event_id': widget.event['id'],
        'event_name': widget.event['event_name'],
        'ticket_count': ticketCount,
        'total_amount': totalAmount,
        'transaction_id': transactionId,
        'payment_status': 'success',
        'bank_tran_id': result.bankTranId ?? 'N/A',
        'card_type': result.cardType ?? 'N/A',
        'created_at': DateTime.now().toIso8601String(),
      });

      print("✅ Booking saved successfully!");
    } catch (e) {
      print("❌ Error saving booking: $e");
      throw Exception("Failed to save booking");
    }
  }

  @override
  Widget build(BuildContext context) {
    final int price = widget.event['price'] ?? 0;
    final int totalAmount = price * ticketCount;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.event['image_url'] ?? "",
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: MediaQuery.of(context).size.height / 2,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(top: 40.0, left: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          bottom: 20.0,
                        ),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(color: Colors.black45),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.event['category'] != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xff6351ec),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  widget.event['category'].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 5),
                            Text(
                              widget.event['event_name'] ?? 'Unnamed Event',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "About Event",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                widget.event['details'] ??
                    "No details provided for this event.",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  const Text(
                    "Number of Tickets: ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (ticketCount > 1) {
                              setState(() => ticketCount--);
                            }
                          },
                          child: const Text(
                            "-",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          "$ticketCount",
                          style: const TextStyle(
                            color: Color(0xff6351ec),
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () => setState(() => ticketCount++),
                          child: const Text(
                            "+",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 30.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total: ৳$totalAmount",
                    style: const TextStyle(
                      color: Color(0xff6351ec),
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: isProcessing ? null : initiatePayment,
                    child: Container(
                      width: 180,
                      height: 55,
                      decoration: BoxDecoration(
                        color: isProcessing
                            ? Colors.grey
                            : const Color(0xff6351ec),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: isProcessing
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              )
                            : const Text(
                                "Pay Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
