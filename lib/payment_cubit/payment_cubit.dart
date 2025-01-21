import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razor_pay_integration/payment_repository.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit({required this.paymentRepository}) : super(const PaymentState());

  final IPaymentRepository paymentRepository;

  final Razorpay _razorPay = Razorpay();
  final _dio = Dio();

  void onAmountChange(String amount) {
    emit(state.copyWith(amount: amount));
  }

  void attachPaymentEventListeners() {
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse paymentSuccessResponse) {
    emit(state.copyWith(apiStatus: ApiStatus.success));
  }

  void _handlePaymentError(PaymentFailureResponse paymentFailureResponse) {
    emit(state.copyWith(apiStatus: ApiStatus.error, errorMessage: paymentFailureResponse.message));
  }

  Future<void> openCheckout() async {
    try {
      await paymentRepository.initializePayment(
        _dio,
        _razorPay,
        num.tryParse(state.amount) ?? 0,
      );
      emit(state.copyWith(apiStatus: ApiStatus.success));
    } catch (e) {
      emit(state.copyWith(apiStatus: ApiStatus.error));
    }
  }

  @override
  Future<void> close() {
    _razorPay.clear();
    return super.close();
  }
}
