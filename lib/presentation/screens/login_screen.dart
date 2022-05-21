import 'package:driver/data/models/driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/authentication_cubit/authentication_cubit.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<dynamic> buildDialog(BuildContext context, DialogShown state) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CustomDialog(
        status: state.statusMessage,
      ),
    );
  }

  SnackBar buildSnackBar(ErrorOccured state) {
    return SnackBar(
      content: Text(
        state.errorMessage,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is DialogShown) {
              buildDialog(context, state);
            }
            if (state is ErrorOccured) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(state));
            }
            if (state is AuthenticationSuccessful) {
              Navigator.pushNamedAndRemoveUntil(
                  context, mainScreen, (route) => false);
            }
          },
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const SizedBox(height: 72),
                    const SizedBox(height: 40),
                    const Text(
                      'Sign In',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Bolt-SemiBold',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) => !value!.contains('@')
                                ? 'Please provide a valid email address!'
                                : null,
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email address',
                              labelStyle: TextStyle(fontSize: 16),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            validator: (value) => value!.length < 8
                                ? 'Please provide a valid password!'
                                : null,
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(fontSize: 16),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 40),
                          CustomButton(
                            color: colorAccentPurple,
                            title: 'LOGIN',
                            onPressed: () {
                              final driverInfo = Driver(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                              formKey.currentState!.validate()
                                  ? context
                                      .read<AuthenticationCubit>()
                                      .loginDriver(driverInfo)
                                  : null;
                            },
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, registrationScreen),
                      child: const Text(
                        'Don\'t have an account? Sign up here',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
