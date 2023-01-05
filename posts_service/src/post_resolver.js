
//const admin = require("firebase-admin");
const { initializeApp, applicationDefault, cert } = require('firebase-admin/app');
const { getFirestore, Timestamp, FieldValue } = require('firebase-admin/firestore');
const { getStorage } = require('firebase-admin/storage');

const serviceAccount = require('../serviceAccountKey.json');

/*admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();*/

initializeApp({
  credential: cert(serviceAccount),
  storageBucket: BUCKET,
});

const db = getFirestore();
const bucket = getStorage().bucket();

//upload file
const {Storage} = require('@google-cloud/storage');
const storage = new Storage(); //creates a client



module.exports={


Query: {

  async getuserPhoto(parent,{photo}, context,info){

        if(!context.user){
        console.log(" Not Authenticated as user")
        }
        const currentuser = context.user;

        const fileName= photo;

        const photo_url = await storage.bucket(bucketName).file(fileName).getDownloadURL();
        console.log(`${photo_url} downloaded`);
        return photo_url;
    }

},


Mutation: {
   async uploadPhoto(parent,{photo}, context,info){
       if(!context.user){
          console.log(" Not Authenticated as user")
       }
       const currentuser = context.user;

       const filePath = bucketName+'/'+currentuser+'/post';
       const destFileName = photo;

       const options = {
           destination: destFileName,
           preconditionOpts: {ifGenerationMatch: generationMatchPrecondition},
         };

         await storage.bucket(bucketName).upload(filePath, options);
         console.log(`${photo} uploaded to ${bucketName}`);
   }
}


};