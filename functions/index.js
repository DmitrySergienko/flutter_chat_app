const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Cloud Firestore triggers ref: https://firebase.google.com/docs/functions/firestore-events
exports.myFunction = functions.firestore
  .document("chat/{messageId}")
  .onCreate((snapshot, context) => {
    // Return this function's promise, so this ensures the firebase function
    // will keep running, until the notification is scheduled.
    return admin.messaging().sendToTopic("chat", {
      // Sending a notification message.
      notification: {
        title: snapshot.data()["userName"],
        body: `snapshot.data()["text"]`,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
        image: snapshot.data()["userImage"], // use 'image' field
      },
    });
  });

  const firestore = admin.firestore();

exports.individualChatNotification = functions.firestore
  .document("individualChat/{messageId}")
  .onCreate(async (snapshot, context) => {
    // Get the recipient user's ID from the created chat message
    const recipientUserId = snapshot.data().recipientId;

    // Fetch the recipient user's FCM token from Firestore
    const userDoc = await firestore.collection('users').doc(recipientUserId).get();

    if (!userDoc.exists) {
      console.log('No user found with ID:', recipientUserId);
      return;
    }

    const token = userDoc.data().token;
    if (!token) {
      console.log('No token found for user:', recipientUserId);
      return;
    }

    // Send the push notification to the recipient user
    return admin.messaging().send({
      token: token,
      notification: {
        title: snapshot.data()["userName"],
        body: snapshot.data()["text"],
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
        image: snapshot.data()["userImage"],
      },
    });
  });


