// const axios = require('axios');

// // Define the bearer token and API endpoint 
// const token = 'ya29.c.c0ASRK0GbRo5zUn469AAzo69YrooyfYTJ_nKOV1bYOvAm7XY0E2Q1czmFnDebJZS2PH6u3WwrYiTur3l1XY0DHcf8P-z5KASoeIjB0uZebw3E6eEf2XX8UbGSY-DWfuacW-Fi30552Mht17LqLGYeyQ6csjwaNTWjFFKpw96lokTO5UdhfmMz0pI4DosH2zQeF-P01F6Gm7RCoPLhX4n8vJCAkpFYWgrTEYX4XKh06lfNeNG46rFHR1-RfB7m1Ufmm4nZD0-szO_QEH9spzXztaX1qqSqapOqIpsA__G0RFA8TcstFaLAn3IFRFegfTByg3ozq9R_G7CrUsmpIc4mL63zFp87KBu2Gz3T7Uj4BIW06VsY48yviRVGLL385CV8XxlvX2bXp1uu7m3Zg3Q799Wk3-YgznnMnOgee0qi9Y8MR37xe5BiZ0ubbWsRfd4-iO9zl66_a09xVkSBI-aVQ7YuQSZhFBVpRQsi03xOf3_QS5R1OVn44bhVS6o9f1kR-JBOUrzkrXtj3ruOBOWkZW9lx0l2XeJ8wcFxUV9z0rX5Ji_tMuUlXuaXcoU8xXxaZZn7g2Wrzmmd-xlvfRuwmgsB5My4OOFUqSYMW6SpvBprjQ4ReYfn16tQYi-15BwYtydc72n660bkIM9iW7Qo-6OtX_i6QS42RB3r4BywtaSV3h-6xQbRWBb_xezkFJgv3aR7_jUwlcYta33kfomb2m1cgpYg75Vtsbj1l6ajRp362O0fZy5F5ovhopi_14wfwcjcfUghbSg6ynvpxu3QJ2irb9OxQ1rv3jxvrIkUk82m_582bnSSMjjhUc9Z0pjJeI0ZBSxmO3Wivc7Sj8fSjoxF_s-np9WYv63FIaVVtcasgwZhihlyQonkzBoR9ZdFtU4J_-3jQljy0dOw5vYpenqIc3wn4lrJtk-3Qp1bi1ZZR83j0dtl8OqBspSZ9lIR2cOZBabU6RUZnjyuFo_k2Xn1w2lZt8ao9OseXgquJwouq8SykBMdrr9Y';  // Replace with actual token
// const url = 'https://fcm.googleapis.com/v1/projects/bnqt-d1772/messages:send';

// // Message payload setup
// const messagePayload = {
//     message: {
//         topic: "topicUser",
//         notification: {  // Note: Corrected 'Notification' to 'notification'
//             title: "chalfsdfsdafja ",
//             body: "Numdr is 8f8dsfds8010"
//         },
//         android: {
//             priority: "high",
//             notification: {  // Corrected 'Notification' to 'notification'
//                 channel_id: "high_importance_channel"
//             }
//         }
//     }
// };

// // Config request headers
// const headers = {
//     'Authorization': `Bearer ${token}`,  // Corrected bearer token usage
//     'Content-Type': 'application/json'   // Added missing content type header
// };

// // Send the request
// axios.post(url, messagePayload, { headers: headers })
//     .then(response => {
//         console.log('Notification sent successfully:', response.data);
//     })
//     .catch(error => {
//         console.error('Error sending notification:', error);
//     });


const admin = require('firebase-admin');
const axios = require('axios');

// Initialize Firebase Admin SDK
const serviceAccount = require('./firebase-service-account.json'); // Path to your service account JSON file
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Define FCM topic
const topic = 'topicAdmin';

// Define the message payload
const messagePayload = {
  notification: {
    title: 'google chutiya ',
    body: 'This is a test notification',
  },
  android: {
    priority: 'high',
    notification: {
      channel_id: 'high_importance_channel',
    },
  },
  topic: topic,
};

// Send Notification
async function sendNotification() {
  try {
    const response = await admin.messaging().send(messagePayload);
    console.log('Notification sent successfully:', response);
  } catch (error) {
    console.error('Error sending notification:', error);
  }
}

sendNotification();
