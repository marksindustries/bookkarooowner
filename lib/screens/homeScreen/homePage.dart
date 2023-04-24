import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// bool isConfirmed = false;
// bool buttonPressed = false;

class _HomePageState extends State<HomePage> {
  void confirmBooking(
      bool confirmation, int index, QuerySnapshot snapshot) async {
    // Get a reference to the "booking" collection in Firestore
    CollectionReference bookingCollection =
        FirebaseFirestore.instance.collection('booking');

    // Get the document ID of the booking at the given index
    String documentID = snapshot.docs[index].id;

    // Update the "status" field of the booking with the given document ID
    await bookingCollection.doc(documentID).update({'isConfirm': confirmation});
    await bookingCollection.doc(documentID).update({'bookingUpdate': true});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Bookings"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('booking').snapshots(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.active) {
            if (snapShot.hasData && snapShot.data != null) {
              return ListView.builder(
                itemCount: snapShot.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> userMap =
                      snapShot.data!.docs[index].data() as Map<String, dynamic>;
                  return Card(
                    margin: EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    child: Container(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "${userMap["customer_name"]}",
                            style: TextStyle(fontSize: 28),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userMap['booking_time'] != null
                                    ? DateFormat('hh:mm a').format(
                                        userMap['booking_time'].toDate())
                                    : '',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                userMap['date'] != null
                                    ? DateFormat('d MMM')
                                        .format(userMap['date'].toDate())
                                    : '',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                         userMap['bookingUpdate'] == false ?  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  confirmBooking(true, index, snapShot.data!);
                                },
                                child: Text('Accept'),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.green),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  confirmBooking(false, index, snapShot.data!);
                                },
                                child: Text('Decline'),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                ),
                              ),
                            ],
                          ):
                         userMap['isConfirm'] == true ? Text("Booking Accepted",style: TextStyle(color: Colors.green),):Text("Booking Declined",style: TextStyle(color: Colors.red),)

                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
