import 'package:flutter/material.dart';
import 'upload_event.dart';
import 'update_event.dart';
import 'admin_logout.dart'; // ✅ Import the logout file

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeef0ff),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Header with logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // Spacer for centering
                  const Text(
                    "Home Admin",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  // ✅ Logout Icon Button from admin_logout.dart
                  AdminLogout.logoutIconButton(context),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Upload Events Card
            _adminCard(
              context,
              icon: Icons.upload,
              title: "Upload\nEvents",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UploadEvent()),
                );
              },
            ),

            const SizedBox(height: 25),

            // Update Events Card
            _adminCard(
              context,
              icon: Icons.edit,
              title: "Update\nEvents",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdateEvent()),
                );
              },
            ),

            const SizedBox(height: 25),

            // Event Tickets Card
            _adminCard(
              context,
              icon: Icons.confirmation_num,
              title: "Event\nTickets",
            ),

            const SizedBox(height: 25),

            // Manage Profiles Card
            _adminCard(
              context,
              icon: Icons.manage_accounts,
              title: "Manage\nProfiles",
            ),

            const Spacer(),

            // ✅ Bottom Logout Button from admin_logout.dart
            AdminLogout.logoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _adminCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.purple),
              const SizedBox(width: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
