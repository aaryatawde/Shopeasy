import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopeasy_app/components/my_textfield.dart';
import 'package:shopeasy_app/components/my_button.dart';
import 'package:flutter/material.dart';
import 'package:shopeasy_app/login/forgot_pw_page.dart';
import 'package:shopeasy_app/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, Key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text editing controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  //sign in user method
  void signInUser() async {
    //show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //pop the loading circle
      Navigator.pop(context);

      //show the welcome dialog
      showWelcomeDialog(FirebaseAuth.instance.currentUser!.email!);
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);

      showErrorMessage(e.code);
    }
    Navigator.pop(context);
  }

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return Align(
            alignment: Alignment.center,
            child: AlertDialog(
              title: Text(
                message,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          );
        });
  }

  void showWelcomeDialog(String username) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Welcome to Shopeasy, $username!"),
          content: const Text("You have successfully logged in."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 201, 255, 203),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10), //100

                    Image.asset(
                      'lib/images/login.jpg',
                      height: 250,
                      width: 250,
                    ),
                    const SizedBox(height: 20), //50

                    const Text(
                      'Welcome!',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    MyTextField(
                      controller: emailController,
                      hintText: 'email',
                      obscureText: false,
                    ),

                    const SizedBox(height: 20),

                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ForgotPasswordPage();
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20), //10

                    MyButton(
                      text: "Login",
                      onTap: signInUser,
                    ),

                    const SizedBox(height: 20), //50

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not a member?',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            'Register now!',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
