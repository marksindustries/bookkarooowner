import 'package:bookkarooowner/screens/homeScreen/homeScreen.dart';
import 'package:bookkarooowner/screens/ownerInformationPage.dart';
import 'package:bookkarooowner/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SendOTPPage extends StatefulWidget {
  late String mobileNumber;
  final String verificationId;

  SendOTPPage({required this.mobileNumber, required this.verificationId});

  @override
  State<SendOTPPage> createState() => _SendOTPPageState();
}

class _SendOTPPageState extends State<SendOTPPage> {
  TextEditingController otpNumberController = TextEditingController();
  bool _isButtonEnabled = false;
  late FocusNode _focusNode;

  void verifyOTP() async {
    String otp = otpNumberController.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("owners")
            .where("contactNumber", isEqualTo: int.parse(FirebaseAuth.instance.currentUser!.phoneNumber.toString()))
            .get();

        if (querySnapshot.size == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OwnerInformationPage(),
            ),
          );
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // request focus when the page is loaded
    Future.delayed(const Duration(milliseconds: 10), () {
      _focusNode.requestFocus();
      _updateButtonState();
    });
  }

  void _updateButtonState() {
    setState(() {
      // Set _isButtonEnabled to true if the OTP is 6 digits long, else false
      _isButtonEnabled = otpNumberController.text.trim().length == 6;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 32,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            child: Text(
              "Enter the 6-digit OTP sent to",
              style:
              GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.normal),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            child: Text(widget.mobileNumber,
              style:
              GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFieldBookKaroo(
            maxLength: 6,
            text: 'Enter OTP',
            controllerName: otpNumberController,
            focusNode: _focusNode,
            onChanged: (value) {
              _updateButtonState();
            },
            type: TextInputType.number,
          ),
          Container(
            decoration: BoxDecoration(
                color: _isButtonEnabled ? Colors.black : Colors.grey,
                borderRadius: BorderRadius.circular(12)),
            child: TextButton(
              onPressed: _isButtonEnabled
                  ? () {
                verifyOTP();
              }
                  : null, // Disable the button if it is not enabled
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
