import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;

  var contactNumber = FirebaseAuth.instance.currentUser!.phoneNumber;

  void confirmBooking(
      bool confirmation, int index, QuerySnapshot snapshot) async {
    // Get a reference to the "booking" collection in Firestore
    CollectionReference bookingCollection =
        FirebaseFirestore.instance.collection('bookings');

    // Get the document ID of the booking at the given index
    String documentID = snapshot.docs[index].id;

    // Update the "status" field of the booking with the given document ID
    await bookingCollection.doc(documentID).update({'isConfirm': confirmation});
    await bookingCollection.doc(documentID).update({'bookingUpdated': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Bookings"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('ownerContactNumber',
                isEqualTo: int.parse(contactNumber.toString().substring(1)))
            .snapshots(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.active) {
            if (snapShot.hasData && snapShot.data != null) {
              if (snapShot.data!.docs.length == 0) {
                return Center(
                    child: Text(
                  "No Bookings ",
                  style: TextStyle(fontSize: 18),
                ));
              } else {
                return ListView.builder(
                  itemCount: snapShot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> userMap =
                        snapShot.data!.docs[index].data();

                    return Dismissible(
                      key: Key(snapShot.data!.docs[index].id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onDismissed: (direction) {
                        // Delete the document from Firestore when swiped left
                        snapShot.data!.docs[index].reference.delete();
                      },
                      child: Card(
                        margin: const EdgeInsets.all(12),
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
                                userMap["customerName"]
                                    .toString()
                                    .toUpperCase(),
                                style: const TextStyle(fontSize: 28),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    userMap['bookingTime'] != null
                                        ? userMap['bookingTime']
                                        : '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    userMap['bookingDate'] != null
                                        ? DateFormat('d MMM').format(
                                            userMap['bookingDate'].toDate())
                                        : '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              userMap['bookingUpdated'] == false
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            confirmBooking(
                                                true, index, snapShot.data!);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.green),
                                          ),
                                          child: const Text('Accept'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            confirmBooking(
                                                false, index, snapShot.data!);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red),
                                          ),
                                          child: const Text('Decline'),
                                        ),
                                      ],
                                    )
                                  : userMap['isConfirm'] == true
                                      ? const Text(
                                          "Booking Accepted",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 22),
                                        )
                                      : const Text(
                                          "Booking Declined",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 22),
                                        )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
