const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.newBookingToOwner = functions.firestore
  .document("bookings/{bookingId}")
  .onCreate(async (snap, context) => {
    const bookingData = snap.data();
    const ownerToken = bookingData.ownerToken;
    console.log("owner token", ownerToken);

    try {
      const payload = {
        notification: {
          title: "New booking created",
          body: "A new booking has been created.",
        },
        data :{message : "sample message"}
      };
      if (!payload) {
        console.log("Payload is null, returning...");
        return;
      }
      const message = await admin.messaging().send(ownerToken, payload);
      console.log("Successfully sent message to owner:", ownerToken);

    } catch (error) {
      console.error("Error sending notification:", error);
      throw error;
    }
  });



//exports.bookingUpdateToCustomer = functions.firestore
//  .document("bookings/{bookingId}")
//  .onUpdate(async (change, context) => {
//    const bookingData = change.after.data();
//    const customerToken = bookingData.customerToken;
//    const confirmation = bookingData.isConfirm;
//
//    if (confirmation == true) {
//      try {
//        const payload = {
//          notification: {
//            title: "Booking confirmed",
//            body: "Your booking has been confirmed.",
//          },
//        };
//        const response = await admin.messaging().send(customerToken, payload);
//        console.log("Successfully sent message to customer:", response);
//        return response;
//      } catch (error) {
//        console.error("Error sending notification:", error);
//      }
//    } else if (confirmation == false) {
//      try {
//        const payload = {
//          notification: {
//            title: "Booking cancelled",
//            body: "Your booking has been cancelled.",
//          },
//        };
//        const response = await admin.messaging().send(customerToken, payload);
//        console.log("Successfully sent message to customer:", response);
//        return response;
//      } catch (error) {
//        console.error("Error sending notification:", error);
//      }
//    }
//  });

