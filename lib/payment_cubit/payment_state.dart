part of 'payment_cubit.dart';

enum ApiStatus { initial, loading, success, error }

class PaymentState extends Equatable {
  const PaymentState({
    this.apiStatus = ApiStatus.initial,
    this.errorMessage = '',
    this.amount = '0',
  });

  final ApiStatus apiStatus;
  final String errorMessage;
  final String amount;

  @override
  List<Object?> get props => [
        apiStatus,
        errorMessage,
        amount,
      ];

  PaymentState copyWith({
    ApiStatus? apiStatus,
    String? errorMessage,
    String? amount,
  }) {
    return PaymentState(
      apiStatus: apiStatus ?? this.apiStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      amount: amount ?? this.amount,
    );
  }
}
