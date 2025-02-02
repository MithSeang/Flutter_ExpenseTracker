import 'package:expense_tracker/controller/register_controller.dart';
import 'package:expense_tracker/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RegisterController _registerController = Get.put(RegisterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register screen'),
      ),
      body: SafeArea(
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
                  controller: usernameController,
                  decoration: const InputDecoration(label: Text('Username')),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  // obscureText: _loginController.isPassword.value,
                  decoration: InputDecoration(
                    label: Text('Email'),
                    // suffixIcon: Obx(
                    //   () => IconButton(
                    //       onPressed: () {
                    //         _loginController.togglePassword();
                    //       },
                    //       icon: Icon(_loginController.isPassword.value
                    //           ? Icons.visibility_off
                    //           : Icons.visibility)),
                    // )
                  ),
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
                    //         _loginController.togglePassword();
                    //       },
                    //       icon: Icon(_loginController.isPassword.value
                    //           ? Icons.visibility_off
                    //           : Icons.visibility)),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _registerController.isLoggedIn.value = true;
                          final username = usernameController.text;
                          final email = emailController.text;
                          final password = passwordController.text;
                          await _registerController.register(
                              username, email, password);
                          _registerController.isLoggedIn.value = false;
                        }
                      }
                      // _loginController.isLoggIn.value
                      //     ? null
                      //     : () async {
                      //         if (_formKey.currentState!.validate()) {
                      //           _loginController.isLoggIn.value = true;
                      //           final email = emailController.text;
                      //           final password = pwController.text;
                      //           _loginController.loginUser(
                      //               email: email, password: password);
                      //           await Future.delayed(
                      //               Duration(milliseconds: 500));
                      //           _loginController.isLoggIn.value = false;
                      //         }
                      //       },
                      ,
                      child: const Text('Register')),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child:
                          Text('Login', style: TextStyle(color: Colors.blue)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
