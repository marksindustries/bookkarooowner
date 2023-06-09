import 'dart:ui';
import 'package:bookkarooowner/screens/gettingStartedPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin<SettingsPage> {
  @override
  bool get wantKeepAlive => true;

  Future<void> updateOpenorClose(bool update) async {
    await FirebaseFirestore.instance
        .collection("owners")
        .where('contactNumber',
            isEqualTo: int.parse(FirebaseAuth.instance.currentUser!.phoneNumber
                .toString()
                .substring(1)))
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({'isOpen': update});
      });
    });
  }

  Future<Map<String, dynamic>> getData() async {
    User? user = FirebaseAuth.instance.currentUser;

    String phoneNumber = user!.phoneNumber!.toString().substring(1);

    if (phoneNumber != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("owners")
          .where('contactNumber', isEqualTo: int.parse(phoneNumber))
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot document = snapshot.docs[0];
        return document.data() as Map<String, dynamic>;
      }
    }

    return {};
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 50),
            child: Container(color: Colors.transparent),
          ),
        ),
        elevation: 10,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getData(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(9),
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: ListTile(
                          title: Text(
                            "Name : " +
                                snapshot.data!['name'].toString().toUpperCase(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(9),
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: ListTile(
                          leading: const Text(
                            "Shop Status",
                            style: TextStyle(fontSize: 18),
                          ),
                          trailing: CupertinoSwitch(
                            // This bool value toggles the switch.
                            value: switchValue,
                            activeColor: CupertinoColors.activeBlue,
                            onChanged: (bool? value) {
                              setState(() {
                                switchValue = value ?? false;
                                switchValue
                                    ? updateOpenorClose(true)
                                    : updateOpenorClose(false);
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GettingStarted()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text(
                          "Log Out",
                          style: TextStyle(color: Colors.red, fontSize: 28),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class ContainerInfo extends StatelessWidget {
  final String text;
  final String value;

  const ContainerInfo({required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              " $text :  ",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
