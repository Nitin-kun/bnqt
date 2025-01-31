const {GoogleAuth} = require('google-auth-library');

const auth = new GoogleAuth({
    keyFile: './Serviceaccount01.json',  // Note: 'keyFile' should be lowercase
    scopes: 'https://www.googleapis.com/auth/firebase.messaging'  // Corrected scope URL
});

async function getAccessToken() {
    const client = await auth.getClient();
    const accessToken = await client.getAccessToken();
    return accessToken.token;
}

getAccessToken().then(token => {
    console.log('Generated OAuth token:', token);
}).catch(error => {  // Error handler corrected
    console.error('Error generating token:', error);
});
