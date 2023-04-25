import 'dart:io';

import 'package:bookkarooowner/screens/homeScreen/homeScreen.dart';
import 'package:bookkarooowner/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class OwnerInformationPage extends StatefulWidget {
  @override
  State<OwnerInformationPage> createState() => _OwnerInformationPageState();
}

class _OwnerInformationPageState extends State<OwnerInformationPage> {
  late bool isOpen = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopAddressController = TextEditingController();
  File? shopImage;

  void saveNewOwner() async {

    var newContactNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
    String name = nameController.text.toLowerCase().trim();
    int contactNumber = int.parse(newContactNumber.toString());
    String city = cityController.text.toLowerCase().trim();
    String state = stateController.text.toLowerCase().trim();
    String shopName = shopNameController.text.toLowerCase().trim();
    String shopAddress = shopAddressController.text.toLowerCase().trim();

    UploadTask uploadTask =  FirebaseStorage.instance.ref().child("shopImages").child(name).putFile(shopImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();


    Map<String, dynamic> newUser = {
      "name": name,
      "contactNumber": contactNumber,
      "shopCity": city,
      "shopState": state,
      "shopName":shopName,
      "shopAddress": shopAddress,
      "isOpen":isOpen,
      "shopImage":downloadUrl
    };

    try {
      await FirebaseFirestore.instance
          .collection("owners")
          .doc("${shopName}")
          .set(newUser);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Welcome !")),
      );
      debugPrint("user created");
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
                    color: Colors.black,
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
                        text: 'Shop Name',
                        controllerName: shopNameController,
                      ),
                      TextFieldBookKaroo(
                        text: 'Shop Address',
                        controllerName: shopAddressController,
                      ),
                      TextFieldBookKaroo(
                        text: 'City',
                        controllerName: cityController,
                      ),
                      TextFieldBookKaroo(
                        text: 'State',
                        controllerName: stateController,
                      ),
                     Container(
                       child: GestureDetector(
                         onTap: () async {
                           XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.camera);
                           if(selectedImage!= null){
                             File convertedFile = File(selectedImage.path);
                             setState(() {
                               shopImage = convertedFile;
                             });
                           }

                         },
                         child: CircleAvatar(
                           radius: 60,
                           child: Icon(Icons.upload),
                           backgroundImage: (shopImage != null) ? FileImage(shopImage!) : null,
                         ),
                       ),
                     )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 60,),

            Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
              ),
              child: TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    saveNewOwner();
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
