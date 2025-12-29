import 'package:flutter/material.dart';
import 'package:ticketmaster/admin/admin_login.dart';
import 'package:ticketmaster/admin/home_admin.dart';
import 'package:ticketmaster/admin/upload_event.dart';
import 'package:ticketmaster/pages/booking.dart';
import 'package:ticketmaster/pages/bottomNav.dart';
import 'package:ticketmaster/pages/details_page.dart';
import 'package:ticketmaster/pages/home.dart';
import 'package:ticketmaster/pages/profile.dart';
import 'package:ticketmaster/pages/signup.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ✅ ADD THIS
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Firebase (unchanged)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔹 Supabase (JUST ADDED)
  await Supabase.initialize(
    url: 'https://mjgnflcnotxvnttoatrf.supabase.co',
    anonKey: 'sb_publishable_VPgbTPuLDl8jP66DNwy2oQ_Wd-zUldx',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: AdminLogin(), // unchanged
    );
  }
}
