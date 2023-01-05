const { gql } = require('apollo-server');

const typeDefs = gql`
extend schema
    @link(url: "https://specs.apollo.dev/federation/v2.0",
          import: ["@key", "@shareable"])

type User @key(fields:"user_id"){
       user_id:ID!,
       username:String!,
       profile_photo: String,
       posts: [Post!],
       followings: [User!],
       followers: [User!]
  }

  type Post {
       post_id:ID!,
       photo: String,
       content:String,
       likes: Int,
       creator: User!,
       createdAt: String!,
       comments: [Comment]
  }


  type Comment @key(fields: "comment_id", resolvable: false) {
      comment_id: ID!
  }


  type Query {
    getPosts: Post,
    getuserData: User,
    getRecommendedPosts:[Post],
    getAllPosts:[Post],
    getAllFollowers:[User],
    getTotalLikes:Int,
  }

  type Mutation {
       addPost(file_name: String, content: String): Post,
       updatePost(post_id: ID, content: String): Post,
       deletePost(post_id: ID):Post
       createUser(username: String): User,
       followUser(user_id: ID):User,
       unFollowUser(user_id: ID):User,
       likePost(post_id: ID): Post,
       unlikePost(post_id: ID): Post
    }

`;

module.exports= typeDefs;