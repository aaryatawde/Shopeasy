import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopeasy_app/components/my_textfield.dart';
import 'package:shopeasy_app/components/my_button.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, Key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void SignInUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      showErrorMessage("Passwords do not match");
      return;
    }

    try {
      Navigator.pop(context);
      showWelcomeDialog(FirebaseAuth.instance.currentUser!.email!);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      showErrorMessage(e.code);
    }
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
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 255, 203),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10), //100
                  Image.asset(
                    'lib/images/register.jpg',
                    height: 250,
                    width: 250,
                  ),

                  const SizedBox(height: 10), //50

                  //lets create an account
                  const Text(
                    'Let\'s create an account for you!',
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

                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 20), //10

                  MyButton(
                    text: "Sign Up",
                    onTap: SignInUp,
                  ),

                  const SizedBox(height: 20), //50

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login now!',
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
      ),
    );
  }
}
