
 const neo4j = require('neo4j-driver')

 const uri = NEO4J_URI;
 const user = USER;
 const password = PASSWORD;

 const driver = neo4j.driver(uri, neo4j.auth.basic(user, password))



module.exports = {

Query: {

 async getuserData(parents,args,context,info){


                  if(!context.user){
                       console.log(" Not Authenticated as user");
                   }
                   console.log("context in accounts resolver: "+context.user);

                   const session = driver.session();
                   console.log('connection established');

                    const result = await session.readTransaction(tx =>
                       tx.run('MATCH(u:User) WHERE u.user_id=$user_id RETURN u.username, u.profile_photo.file_name',
                       {user_id: context.user})
                       );

                    const singleRecord = result.records[0];

                    const username = singleRecord.get(0);
                    const profile_photo = singleRecord.get(1);
                    console.log("username : "+username);
                    console.log("profile_photo : "+ profile_photo);

                    const fuser= {
                         username: username,
                         profile_photo: profile_photo
                    }
                    console.log(fuser);
                    return fuser;

                    await session.close();

                    await driver.close();

 },

 async getRecommendedPosts(parents,args,context,info){
       try{
         if(!context.user){
             console.log(" Not Authenticated as user");
         }
         console.log("context in accounts resolver: "+context.user);
         const session = driver.session();
         console.log('connection established');

            const result = await session.readTransaction(tx =>
             tx.run('MATCH(u:User{user_id:$user_id})-[:FOLLOWS]->(:User)--(p:Post) RETURN p',
             {user_id: context.user})
             );

          const record = result.records;
          const posts =  [];

          for (let i = 0; i < record.length; i++) {
              const post = record[i].get(0)
              posts.push(post);
              console.log(posts[i].properties.title);
            }

        console.log(posts);
        return posts;

       }catch(err){
           console.log("error : "+err);
       }finally{
          await session.close();
       }
       await driver.close();

 },

 async getAllPosts(parents,args,context,info){
      try{
         if(!context.user){
             console.log(" Not Authenticated as user");
         }
         console.log("context in accounts resolver: "+context.user);
         const session = driver.session();
         console.log('connection established');

            const result = await session.readTransaction(tx =>
             tx.run('MATCH(u:User{user_id:$user_id})-[:HAS_POST]->(p:Post) RETURN p',
             {user_id: context.user})
             );

          const record = result.records;
          const posts =  [];

          for (let i = 0; i < record.length; i++) {
              const post = record[i].get(0)
              posts.push(post);
              console.log(posts[i].properties.title);
            }

        console.log(posts);
        return posts;

      }catch(err){
         console.log("error : "+err);
      }finally{
         await session.close();
      }

       await driver.close();

 },

 async getAllFollowers(parents,args,context,info){
      try{
         if(!context.user){
             console.log(" Not Authenticated as user");
         }
         console.log("context in accounts resolver: "+context.user);
         const session = driver.session();
         console.log('connection established');

            const result = await session.readTransaction(tx =>
             tx.run('MATCH(u:User{user_id:$user_id})<-[:FOLLOWS]-(p:User) RETURN p',
             {user_id: context.user})
             );

          const record = result.records;
          const followers =  [];

          for (let i = 0; i < record.length; i++) {
              const follower = record[i].get(0)
              followers.push(follower);
              console.log(followers[i].properties.username);
            }

          return followers;

      }catch(err){
         console.log("error : "+err);
      }finally{
         await session.close();
      }

      await driver.close();

 }
},

Mutation: {
  async createUser(parents,{username},context,info){
      if(!context.user){
                   console.log(" Not Authenticated as user");
                   }
     const session = driver.session();
     try {
     const result= await session.writeTransaction(tx =>
     tx.run('CREATE(u: User{user_id: $user_id, username: $username}) RETURN u',
      { user_id: context.user, username: username})
     );

     const singleRecord = result.records[0];
     const createdNodeId = singleRecord.get(0);
     console.log(' created user with id: ' + createdNodeId);
     }finally {
     await session.close();
     }
  },


  async addPost(parents,{file_name, content},context,info){
        if(!context.user){
               console.log(" Not Authenticated as user");
        }

       const session = driver.session();
       try {
       const result= await session.writeTransaction(tx =>
       tx.run('CREATE(p: Post{photo: $file_name, content: $content, likes: 0, creator: $creator }) RETURN u',
        { file_name: file_name, content: content, creator: context.user})
       );

       const singleRecord = result.records[0];
       const createdNodeId = singleRecord.get(0);
       console.log(' created post with id: ' + createdNodeId);
       }finally {
       await session.close();
       }
    },


  async updatePost(parents,{post_id, content},context,info){
      if(!context.user){
           console.log(" Not Authenticated as user");
      }
      const session = driver.session();
       try {
             const result= await session.writeTransaction(tx =>
             tx.run('MATCH(p: Post{post_id: $post_id}) SET p.content=$content RETURN p',
              {post_id: post_id, content: content})
             );

             const singleRecord = result.records[0];
             const createdNodeId = singleRecord.get(0);
             console.log(' updated post with id: ' + createdNodeId);
       }finally {
             await session.close();
       }
  },

  async deletePost(parents,{post_id},context,info){
        if(!context.user){
                  console.log(" Not Authenticated as user");
             }
             const session = driver.session();
              try {
                    const result= await session.writeTransaction(tx =>
                    tx.run('MATCH(p: Post{post_id: $post_id}) DELETE p',
                     {post_id: post_id})
                    );

                    console.log(' deleted post with id: ' + createdNodeId);
              }finally {
                    await session.close();
              }
  },

  async followUser(parents,{user_id},context,info){
          if(!context.user){
                    console.log(" Not Authenticated as user");
               }
               const session = driver.session();
                try {
                      const result= await session.writeTransaction(tx =>
                      tx.run('MATCH(u: User{user_id: $userid}) MATCH(v: User{user_id: $user_id}) CREATE(u)-[r:FOLLOWS]->(v) RETURN u',
                       {userid: context.user, user_id: user_id})
                      );

                      console.log(context.user+' follow user with id '+ user_id);
                }finally {
                      await session.close();
                }
  },

  async unFollowUser(parents,{user_id},context,info){
          if(!context.user){
                    console.log(" Not Authenticated as user");
               }
               const session = driver.session();
                try {
                      const result= await session.writeTransaction(tx =>
                      tx.run('MATCH(u: User{user_id: $userid})-[r:FOLLOWS]->(v: User{user_id: $user_id}) DELETE r RETURN u',
                       {userid: context.user, user_id: user_id})
                      );

                      console.log(context.user+' follow user with id '+ user_id);
                }finally {
                      await session.close();
                }
  },

  async likePost(parents,{post_id},context,info){
            if(!context.user){
                      console.log(" Not Authenticated as user");
                 }
                 const session = driver.session();
                  try {
                        const result= await session.writeTransaction(tx =>
                        tx.run('MATCH(u: User{user_id: $user_id}) MATCH(p: Post{post_id: $post_id}) CREATE(u)-[r:LIKES]->(p) RETURN p',
                         {user_id: context.user, post_id: post_id})
                        );

                        console.log(context.user+' likes post with id '+ post_id);
                  }finally {
                        await session.close();
                  }
  },

  async unFollowUser(parents,{post_id},context,info){
            if(!context.user){
                      console.log(" Not Authenticated as user");
                 }
                 const session = driver.session();
                  try {
                        const result= await session.writeTransaction(tx =>
                        tx.run('MATCH(u: User{user_id: $user_id})-[r:LIKES]->(p: Post{post_id: $post_id}) DELETE r Return p',
                         {user_id: context.user, post_id: post_id})
                        );

                        console.log(context.user+' likes a post with id '+ post_id);
                  }finally {
                        await session.close();
                  }
    }
}


};
