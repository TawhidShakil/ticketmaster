import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final supabase = Supabase.instance.client;

  late Future<List<dynamic>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = fetchEvents();
  }

  // 🔹 STEP 1: Fetch events from Supabase
  Future<List<dynamic>> fetchEvents() async {
    final data = await supabase
        .from('ticket_events')
        .select()
        .order('id', ascending: false);

    return data;
  }

  // 🔹 STEP 2: Get image URL from bucket
  String getImageUrl(String path) {
    return supabase.storage.from('images').getPublicUrl(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 50, left: 20),
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        // 🔹 IMPORTANT: scroll fix
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                children: const [
                  Icon(Icons.location_on_outlined),
                  Text(
                    "Balucor, Sylhet",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Text(
                "Hello, Fardeen",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "Events around your location",
                style: TextStyle(
                  color: Color(0xff6351ec),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // ================= SEARCH =================
              Container(
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search_outlined),
                    border: InputBorder.none,
                    hintText: "Search an Event",
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ================= UPCOMING EVENTS =================
              const Text(
                "Upcoming Events",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // 🔹 STEP 3: Dynamic Supabase data
              FutureBuilder(
                future: _eventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final events = snapshot.data as List;

                  if (events.isEmpty) {
                    return const Text("No events found");
                  }

                  return ListView.builder(
                    itemCount: events.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      // image_url in DB is already a full URL from upload_event.dart
                      final imageUrl = event['image_url'] ?? '';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔹 Event Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                imageUrl,
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.broken_image,
                                        size: 50,
                                      ),
                                    ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            // 🔹 Title + Price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  event['event_name'] ??
                                      'Unnamed Event', // Fixed key
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${event['price'] ?? 0} BDT",
                                  style: const TextStyle(
                                    color: Color(0xff6351ec),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            // 🔹 Location 
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 18,
                                ), // Changed icon
                                const SizedBox(width: 5),
                                Text(
                                  event['location'] ??
                                      'No Location', // Fixed key
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),

                            // 🔹 Date (Optional, if not in DB don't show or show created_at)
                            if (event['created_at'] != null)
                              Text(
                                "Date: ${event['created_at'].toString().split('T')[0]}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
