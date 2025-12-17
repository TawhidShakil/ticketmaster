import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Image.asset('assets/images/onboarding.png'),
            SizedBox(height: 10),
            Text(
              "Unlock the features of",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              "Event Booking App",
              style: TextStyle(
                color: Color(0xff6351ec),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Discover, book, and experience unforgettable movements effectlessly!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black45, fontSize: 20),
            ),
            SizedBox(height: 50),
            Container(
              height: 70,
              margin: EdgeInsets.only(left: 30, right: 30),
              decoration: BoxDecoration(
                color: Color(0xff6351ec),
                borderRadius: BorderRadius.circular(45),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google.png',
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Sign in with Google",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
