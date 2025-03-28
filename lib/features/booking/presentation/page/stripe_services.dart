import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

      await _processPayment(amount, onSuccess, onFailure);
      
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

  Future<void> _processPayment(int amount, Function onSuccess, Function(dynamic error) onFailure) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      
      // ✅ Payment successful - store in Firestore
      await _storeTransactionInFirestore(amount, "success");

      onSuccess(); // ✅ Call onSuccess after successful payment

    } on StripeException catch (e) {
      onFailure(e.error.localizedMessage); // ✅ Call onFailure with error message

    } catch (e) {
      onFailure(e.toString()); // ✅ Call onFailure with error message
    }
  }

  Future<void> _storeTransactionInFirestore(int amount, String status) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      await FirebaseFirestore.instance.collection("transactions").add({
        "userId": user.uid,
        "amount": amount / 100, // Convert cents to AED
        "currency": "AED",
         "paymentStatus": status, 
        "timestamp": FieldValue.serverTimestamp(),
      });

      print("✅ Transaction stored successfully");
    } catch (e) {
      print("❌ Error storing transaction: $e");
    }
  }
}

