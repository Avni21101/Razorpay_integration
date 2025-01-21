import 'package:dio/dio.dart';
import 'package:razor_pay_integration/app_constants.dart';
import 'package:razor_pay_integration/basic_auth_interceptor.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

abstract class IPaymentRepository {
  Future<void> initializePayment(Dio dioInstance, Razorpay razorPay, num amount);
}

class PaymentRepository implements IPaymentRepository {
  @override
  Future<void> initializePayment(Dio dioInstance, Razorpay razorPay, num amount) async {
    final orderId = await _generateOrderId(dioInstance, amount);
    razorPay.open(_generateOption(orderId ?? '', amount));
  }

  Future<String?> _generateOrderId(Dio dioInstance, num amount) async {
    dioInstance.interceptors.add(
      BasicAuthInterceptor(
        username: AppConstants.keyId,
        password: AppConstants.keySecret,
      ),
    );

    final response = await dioInstance.post(
      'https://api.razorpay.com/v1/orders',
      data: {
        "amount": amount * 100,
        "currency": "INR",
        "receipt": "qwsaq1",
        "partial_payment": true,
        "first_payment_min_amount": 230,
        "notes": {
          "key1": "value3",
          "key2": "value2",
        },
      },
    );
    final responseData = response.data as Map<String, dynamic>;
    return responseData['id'];
  }

  Map<String, dynamic> _generateOption(String orderId, num amount) {
    return {
      'key': AppConstants.keyId,
      'amount': amount * 100, // payment amount * 100
      'name': 'Acme Corp.',
      'order_id': orderId,
      'description': 'Fine T-Shirt',
      'timeout': 120, // in seconds
      'prefill': {'contact': '9000090000', 'email': 'abc@gmail.com'},
    };
  }
}
