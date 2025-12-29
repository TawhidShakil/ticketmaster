import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticketmaster/pages/bottomNav.dart';
import 'package:ticketmaster/pages/home.dart';
import '../admin/admin_login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // 🔐 Google Sign-In Function
  Future<void> signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      await FirebaseAuth.instance.signInWithPopup(googleProvider);

      // ✅ Login success → Home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image.asset('images/onboarding.png'),
          const SizedBox(height: 10),

          const Text(
            "Unlock the features of",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            "Event Booking App",
            style: TextStyle(
              color: Color(0xff6351ec),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Discover, book, and experience unforgettable movements effortlessly!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black45, fontSize: 20),
          ),

          const SizedBox(height: 50),

          // 👇 Google Sign-In Button
          GestureDetector(
            onTap: signInWithGoogle, // 🔥 HERE IS THE FIX
            child: Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: const Color(0xff6351ec),
                borderRadius: BorderRadius.circular(45),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/google.png', height: 30, width: 30),
                  const SizedBox(width: 20),
                  const Text(
                    "Sign in with Google",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Admin Login Button
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminLogin()),
              );
            },
            child: const Text(
              "Login as an Admin",
              style: TextStyle(
                color: Color.fromARGB(255, 3, 3, 3),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
