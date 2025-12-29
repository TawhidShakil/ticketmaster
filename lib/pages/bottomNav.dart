import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ticketmaster/pages/booking.dart';
import 'package:ticketmaster/pages/home.dart';
import 'package:ticketmaster/pages/profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;
  late Home home;
  late Booking booking;
  late Profile profile;
  int currentTabIndex = 0;

  @override
  void initState() {
    home = Home();
    booking = Booking();
    profile = Profile();
    pages = [home, booking, profile];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.book, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
