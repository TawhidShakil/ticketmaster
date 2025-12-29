import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticketmaster/pages/signup.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: user == null
          ? const Center(child: Text("No user logged in"))
          : Column(
              children: [
                // 🔹 Top Header with background
                Container(
                  padding: const EdgeInsets.only(top: 50, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0xfff5f5ff), // Light lavender background
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 🔹 Avatar (Image or First Letter)
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xff008b9b), // Teal color from image
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: user?.photoURL != null
                          ? Image.network(user!.photoURL!, fit: BoxFit.cover)
                          : Center(
                              child: Text(
                                user?.displayName != null &&
                                        user!.displayName!.isNotEmpty
                                    ? user!.displayName![0].toUpperCase()
                                    : "S",
                                style: const TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 🔹 Profile Fields
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _profileItem("Name", user!.displayName ?? "Fardeen Khan"),
                      const SizedBox(height: 15),
                      _profileItem("Email", user!.email ?? "far@gamil.com"),
                      const SizedBox(height: 15),
                      _actionItem("Contact Us", Icons.mail_outline, () {}),
                      const SizedBox(height: 15),
                      _actionItem("LogOut", Icons.logout, () async {
                        bool? confirm = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Confirm Logout"),
                              content: const Text(
                                "Are you sure you want to logout?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false); // NO
                                  },
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, true); // YES
                                  },
                                  child: const Text("Logout"),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Signup(),
                            ),
                          );
                        }
                      }),
                      const SizedBox(height: 15),
                      _actionItem(
                        "Delete Account",
                        Icons.delete_outline,
                        () {},
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // Widget for displaying Name/Email
  Widget _profileItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black45, fontSize: 14),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget for action buttons like Logout/Delete
  Widget _actionItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xff2d7eaa),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
