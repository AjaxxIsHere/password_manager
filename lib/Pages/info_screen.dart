import 'package:flutter/material.dart';
import 'package:password_manager/Widgets/animated_text.dart';
import 'package:pixelarticons/pixelarticons.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Pixel.arrowleft,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.black,
        title: const Text(
          'About LockBox',
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 90),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "This Password Manager app is designed to provide users with a secure and convenient way to manage their sensitive information. It allows for the safe storage of passwords and notes, all encrypted using industry-standard AES encryption to ensure data privacy. The app features a user-friendly interface, making it easy for users to add, edit, and delete passwords and notes. It also offers password decryption for quick access when needed. Security and privacy are the app's top priorities, ensuring that users' digital lives are well protected. \n\n (Hint: Enter your 'favourite' number in the Notes title to unlock a secret feature :D)",
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: AnimatedRainbowText(
                  text: "Copyright © 2024 Larry&AJ Co. All rights reserved.",
                  style: TextStyle(fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }
}
