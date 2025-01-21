import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razor_pay_integration/payment_cubit/payment_cubit.dart';
import 'package:razor_pay_integration/payment_repository.dart';
import 'package:razor_pay_integration/payment_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Razorpay Integration',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: RepositoryProvider<IPaymentRepository>(
        create: (context) => PaymentRepository(),
        child: BlocProvider(
          create: (context) => PaymentCubit(
            paymentRepository: context.read<IPaymentRepository>(),
          )..attachPaymentEventListeners(),
          child: const PaymentScreen(),
        ),
      ),
    );
  }
}
