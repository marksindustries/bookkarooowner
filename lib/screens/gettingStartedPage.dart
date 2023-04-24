import 'package:bookkarooowner/screens/sendOtpPage.dart';
import 'package:bookkarooowner/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GettingStarted extends StatefulWidget {
  const GettingStarted({Key? key}) : super(key: key);

  @override
  State<GettingStarted> createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  late FocusNode _focusNode;
  TextEditingController mobileNumberController = TextEditingController();

  void sendOTP() async {
    String phone = "+91" + mobileNumberController.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      codeSent: (verificationId, resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SendOTPPage(
              verificationId: verificationId,
              mobileNumber: mobileNumberController.text,
            ),
          ),
        );
      },
      verificationCompleted: (credential) {},
      verificationFailed: (ex) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ex.message!),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: const Duration(seconds: 30),
    );
  }

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // request focus when the page is loaded
    Future.delayed(const Duration(milliseconds: 10), () {
      _focusNode.requestFocus();
    });
  }

  updateButtonState() {
    setState(() {
      _isButtonEnabled = mobileNumberController.text.trim().length == 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // prevent the keyboard from resizing the layout
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Book Karoo',
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 42),
                    ),
                    Text(
                      "Owner's",
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 42),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Let's get started",
                        style: GoogleFonts.lato(fontSize: 22),
                      ),
                    ),
                  ),
                  TextFieldBookKaroo(
                    maxLength: 10,
                    type: TextInputType.number,
                    text: 'Mobile Number',
                    controllerName: mobileNumberController,
                    focusNode: _focusNode,
                    onChanged: (value) {
                      updateButtonState();
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: _isButtonEnabled ? Colors.black : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: _isButtonEnabled
                          ? () {
                        sendOTP();
                      }
                          : null,
                      child: const Text(
                        'Continue',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}


