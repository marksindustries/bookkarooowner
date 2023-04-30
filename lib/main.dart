import 'package:bookkarooowner/firebase_options.dart';
import 'package:bookkarooowner/screens/gettingStartedPage.dart';
import 'package:bookkarooowner/screens/homeScreen/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const BookKarooOwner());
}

class BookKarooOwner extends StatelessWidget {
  const BookKarooOwner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (FirebaseAuth.instance.currentUser != null)
          ? const HomeScreen()
          : const GettingStarted(),
    );
  }
}
