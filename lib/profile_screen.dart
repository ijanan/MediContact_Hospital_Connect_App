import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://i.pinimg.com/originals/d4/06/94/d406945e47e522266f241f15ff0d5545.jpg'), // Replace with your anime image URL
            ),
            const SizedBox(height: 10),
            Text(
              FirebaseAuth.instance.currentUser?.displayName ?? "User Name",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
             const SizedBox(height: 5),
            
            Text(
              FirebaseAuth.instance.currentUser?.email ?? "My Account",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "My Account",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEBE4F7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView( 
                shrinkWrap: true,
                children: const [
                  ProfileOption(
                    icon: Icons.person,
                    text: "My Profile",
                  ),
                  ProfileOption(
                    icon: Icons.calendar_month,
                    text: "My Appointment",
                  ),
                  ProfileOption(
                    icon: Icons.key,
                    text: "Change Password",
                  ),
                  ProfileOption(
                    icon: Icons.send,
                    text: "Contact Us",
                  ),
                  ProfileOption(
                    icon: Icons.chat,
                    text: "Share With Friends",
                  ),
                  ProfileOption(
                    icon: Icons.lightbulb,
                    text: "Help ?",
                  ),
                  ProfileOption(
                    icon: Icons.bookmark,
                    text: "Rate Us",
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

class ProfileOption extends StatelessWidget {
  const ProfileOption({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
      },  );

  }
}