import 'package:flutter/material.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Text(
              "Bookings",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // Booking Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.blue, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Mumbai, India",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  const Divider(height: 20),

                  Row(
                    children: [
                      // Event Image
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage("assets/concert.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Event Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Honey Singh Concert",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 6),

                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 6),
                                Text("2024-12-20"),
                              ],
                            ),

                            SizedBox(height: 6),

                            Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 6),
                                Text("3"),
                                SizedBox(width: 14),
                                Icon(
                                  Icons.attach_money,
                                  size: 16,
                                  color: Colors.blue,
                                ),
                                Text("30"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
