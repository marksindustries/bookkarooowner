const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendBookingNotification = functions.database.ref('/bookings/{bookingId}').onWrite(async (change, context) => {
  // Get the user ID from the booking data
  const bookingId = context.params.bookingId;
  const bookingData = change.after.val();
  const userId = bookingData.userId;

  // Get the user's FCM token
  const userSnapshot = await admin.database().ref(`/users/${userId}`).once('value');
  const user = userSnapshot.val();
  const fcmToken = user.fcmToken;

  // Set the message payload
  const payload = {
    notification: {
      title: 'Booking Updated',
      body: 'Your booking has been updated'
    }
  };

  // Send the FCM notification
  return admin.messaging().sendToDevice(fcmToken, payload);
});
