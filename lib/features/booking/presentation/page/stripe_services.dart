
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

      String? paymentIntentClientSecret = await _createPaymentIntent(amount, 'AED');
      if (paymentIntentClientSecret == null) {
        onFailure("Failed to create payment intent");
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: "farsana rahman c",
          paymentIntentClientSecret: paymentIntentClientSecret,
        )
      );

      await _processPayment(onSuccess, onFailure);
      
    } catch (e) {
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
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _processPayment(Function onSuccess, Function(dynamic error) onFailure) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      onSuccess(); // ✅ Call onSuccess after successful payment

    } on StripeException catch (e) {
      onFailure(e.error.localizedMessage); // ✅ Call onFailure with error message

    } catch (e) {
      onFailure(e.toString()); // ✅ Call onFailure with error message
    }
  }
}
