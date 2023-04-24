import 'package:bookkarooowner/screens/gettingStartedPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Settings"),
        // backgroundColor: Color(0xff1F319D),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>  GettingStarted()),
                  (Route<dynamic> route) => false,
            );
          },
          child: const Text(
            "Log Out",
            style: TextStyle(color: Colors.red, fontSize: 28),
          ),
        )
      ),
    );
  }
}
