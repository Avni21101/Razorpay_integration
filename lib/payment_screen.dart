import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razor_pay_integration/payment_cubit/payment_cubit.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state.apiStatus == ApiStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Success'),
              backgroundColor: Colors.green.withOpacity(0.5),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state.apiStatus == ApiStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red.withOpacity(0.5),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Razorpay Integration'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png'),
                const SizedBox(height: 32),
                const AmountTextField(),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    context.read<PaymentCubit>().openCheckout();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(8),
                      minimumSize: Size(MediaQuery.sizeOf(context).width - 32, 50)),
                  child: const Text(
                    'Payment',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AmountTextField extends StatelessWidget {
  const AmountTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        onChanged: (value) {
          context.read<PaymentCubit>().onAmountChange(value);
        },
        keyboardType: const TextInputType.numberWithOptions(),
        decoration: const InputDecoration(
          hintText: 'Enter Amount',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
