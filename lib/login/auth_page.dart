import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import 'login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage(
                addToCart: (Product) {},
                cartItems: [],
                removeFromCart: (int) {},
              );
            }

            //if user is not logged in
            else {
              return const LoginOrRegisterPage();
            }
          }),
    );
  }
}
