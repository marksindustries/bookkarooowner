const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize the Firebase admin SDK
admin.initializeApp();

// Define the Cloud Function that sends the push notification
exports.sendNotification = functions.firestore
  .document("bookings/{bookingId}")
  .onUpdate((change, context) => {
  const bookingData = change.after.data();
  const bookingId = context.params.bookingId;
  const customerToken = bookingData.customerToken;
  const bookingUpdated = bookingData.bookingUpdated;

    // Check if the bookingUpdated value has been set to true
if (bookingUpdated) {
      // Construct the notification payload
    const payload = {
        notification: {
          title: "Booking Update",
          body: "Your booking has been updated!",
        },
        data: {
          bookingId: bookingId,
        },
      };

      // Send the notification to the customer's device
      return admin
        .messaging()
        .send(customerToken, payload)
        .then((response) => {
          console.log("Notification sent successfully:", response);
          return null;
        })
        .catch((error) => {
          console.error("Error sending notification:", error);
          return null;
        });
    }

    return null;
  });
