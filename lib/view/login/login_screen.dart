import 'package:expense_tracker/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../register/register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController _loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Login screen'),
        ),
        body: Obx(
          () => SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 40),
                      alignment: Alignment.topCenter,
                      height: 150,
                      child: Image.asset('assets/images/expense.png'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(label: Text('Email')),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      // obscureText: _loginController.isPassword.value,
                      decoration: InputDecoration(
                        label: Text('Password'),
                        // suffixIcon: Obx(
                        //   () => IconButton(
                        //       onPressed: () {
                        //         // _loginController.togglePassword();
                        //       },
                        //       icon: Icon(
                        //           // _loginController.isPassword.value
                        //           //   ? Icons.visibility_off:
                        //           Icons.visibility)),
                        // )
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          onPressed: _loginController.isLoggedIn.value
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    _loginController.isLoggedIn.value = true;
                                    final email = emailController.text;
                                    final password = passwordController.text;
                                    _loginController.login(email, password);
                                    await Future.delayed(
                                        Duration(milliseconds: 500));
                                    _loginController.isLoggedIn.value = false;
                                  }
                                },
                          child: const Text('Login')),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't  have an account?"),
                        TextButton(
                          onPressed: () {
                            _formKey.currentState!.reset();
                            Get.to(() => RegisterScreen());
                          },
                          child: Text('Register',
                              style: TextStyle(color: Colors.blue)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
        ));
  }
}
