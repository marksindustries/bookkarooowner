import 'package:bookkarooowner/screens/homeScreen/homeScreen.dart';
import 'package:bookkarooowner/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OwnerInformationPage extends StatefulWidget {
  late String mobileNumber;

  OwnerInformationPage({required this.mobileNumber});

  @override
  State<OwnerInformationPage> createState() => _OwnerInformationPageState();
}

class _OwnerInformationPageState extends State<OwnerInformationPage> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailIdController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  TextEditingController stateController = TextEditingController();

  void saveNewCustomer() async {
    int contactNumber = int.parse(widget.mobileNumber);
    String name = nameController.text.toLowerCase().trim();
    String emailId = emailIdController.text.toLowerCase().trim();
    String city = cityController.text.toLowerCase().trim();
    String state = stateController.text.toLowerCase().trim();

    Map<String, dynamic> newUser = {
      "name": name,
      "contactNumber": contactNumber,
      "emailId": emailId,
      "city": city,
      "state": state,
    };

    try {
      await FirebaseFirestore.instance
          .collection("customers")
          .doc("${contactNumber}")
          .set(newUser);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Welcome !")),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message!)),
      );
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              // color: Colors.red,
              height: 100,
              child: Text(
                'Tell Us About Yourself',
                style: GoogleFonts.lato(
                    fontSize: 28,
                    color: const Color(0xff1F319D),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFieldBookKaroo(
                        text: 'Full Name',
                        controllerName: nameController,
                      ),
                      TextFieldBookKaroo(
                        text: 'Email Id',
                        controllerName: emailIdController,
                      ),
                      TextFieldBookKaroo(
                        text: 'City',
                        controllerName: cityController,
                      ),
                      TextFieldBookKaroo(
                        text: 'State',
                        controllerName: stateController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xff1F319D),
              ),
              child: TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    saveNewCustomer();
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
