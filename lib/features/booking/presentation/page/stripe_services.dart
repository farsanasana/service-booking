import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:dio/dio.dart';
import 'package:secondproject/core/constand/api.dart';

class StripeServices {
  StripeServices._();
  static final StripeServices instance = StripeServices._();

  Future<void> makepayment(
    String totalAmount, 
    {required Function onSuccess, required Function(dynamic error) onFailure}
  ) async {
    try {
      int amount = (double.parse(totalAmount) * 100).toInt(); // Convert to cents

      log("Debug: Creating payment intent for $amount AED");
      String? paymentIntentClientSecret = await _createPaymentIntent(amount, 'AED');
      if (paymentIntentClientSecret == null) {
        log('Error: Payment intent creation failed');
        onFailure("Failed to create payment intent");
        return;
      }

      log("Debug: Initializing payment sheet");
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: "farsana rahman c",
          paymentIntentClientSecret: paymentIntentClientSecret,
        )
      );

      log("Debug: Showing payment sheet");
      await _processPayment(onSuccess, onFailure);
      
    } catch (e) {
      log('Error in makepayment: $e');
      onFailure(e.toString()); // Call onFailure in case of any error
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        'amount': amount.toString(),
        'currency': currency,
      };

      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            'Authorization': 'Bearer $stripeSecretKey', // Ensure this key is defined
            'Content-Type': 'application/x-www-form-urlencoded'
          }
        )
      );

      if (response.data != null) {
        log('Payment intent created successfully');
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      log('Error creating payment intent: $e');
      return null;
    }
  }

  Future<void> _processPayment(Function onSuccess, Function(dynamic error) onFailure) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      log('Payment successful');
      onSuccess(); // ✅ Call onSuccess after successful payment

    } on StripeException catch (e) {
      log('Stripe error: ${e.error.localizedMessage}');
      onFailure(e.error.localizedMessage); // ✅ Call onFailure with error message

    } catch (e) {
      log('Error processing payment: $e');
      onFailure(e.toString()); // ✅ Call onFailure with error message
    }
  }
}
