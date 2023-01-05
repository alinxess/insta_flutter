const { MongoClient } = require('mongodb');
const uri = MONGO_URI;
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });


module.exports = {

Comment: {
      __resolveReference(reference) {

        //resolving referenced made by feed_service
        return getAllComments(reference.post_id);
      }
    },

 Query: {

   async getComment(parents,{comment_id},context,info){
        if(!context.user){
            console.log(" Not Authenticated as user");
        }

        await client.connect();
        console.log("Connected correctly to server");
        const db = client.db("fmongoDb");

        const col = db.collection("ufeed");
        const query = {comment_id: $comment_id};
        var comment=" ";
        var commentor =" ";

        const qr = await col.find(query).project({_id:0, comment:1, 'commentor.username': 1});


        console.log("Record Read successfully");
        console.log(qr);
        console.log(qr[0].comment);
        console.log(qr[0].commentor.username);
        comment= qr[0].comment;
        commentor = qr[0].commentor.username;
        console.log("comment: "+comment);

        const mcomm = {
           comment: comment,
           commentor: commentor
        }

        console.log(mcomm);

        return mcomm;
        await client.close();

   },

   async getAllComments(parents,{post_id},context,info){
           if(!context.user){
               console.log(" Not Authenticated as user");
           }

           await client.connect();
           console.log("Connected correctly to server");
           const db = client.db("fmongoDb");

           const col = db.collection("ufeed");
           const query = {post_id: $post_id};

           const qr = await col.find(query).project({_id:0, comment:1, 'commentor.username': 1 }).toArray();


           console.log("Record Read successfully");
           console.log(qr);
           return qr;
           await client.close();

      }

 },

 Mutation: {

    async createComment(parents,{comment, post_id},context,info){
          if(!context.user){
             console.log(" Not Authenticated as user");
          }

           await client.connect();
           console.log("Connected correctly to server");
           const db = client.db("fmongoDb");

           const col = db.collection("ufeed");

           try{
               const doc = {comment_id: new ObjectId(), comment: $comment , post_id: $post_id, commentor: context.user };
               const result = await col.insertOne(doc);
               console.log(
                  `A document was inserted with the _id: ${result.insertedId}`,
               );

           }catch(e){
               console.log("error : "+err);
           }finally{
               await client.close();
           }
    },

    async updateComment(parents,{comment_id, comment},context,info){
              if(!context.user){
                 console.log(" Not Authenticated as user");
              }

               await client.connect();
               console.log("Connected correctly to server");
               const db = client.db("fmongoDb");

               const col = db.collection("ufeed");

               try{
                  const query = { comment_id: $comment_id };
                  const update = { $set: { comment: $comment }};
                  const options = {};
                  col.updateOne(query, update, options);

               }catch(e){
                   console.log("error : "+err);
               }finally{
                   await client.close();
               }
    },

    async deleteComment(parents,{comment_id},context,info){
                  if(!context.user){
                     console.log(" Not Authenticated as user");
                  }

                   await client.connect();
                   console.log("Connected correctly to server");
                   const db = client.db("fmongoDb");

                   const col = db.collection("ufeed");

                   try{
                      const query = { comment_id: $comment_id };
                      col.deleteOne(query);

                   }catch(e){
                       console.log("error : "+err);
                   }finally{
                       await client.close();
                   }
        }
 }



};