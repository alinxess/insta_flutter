const { gql } = require('apollo-server');

const typeDefs = gql`
extend schema
    @link(url: "https://specs.apollo.dev/federation/v2.0",
          import: ["@key", "@shareable"])

type Comment @key(fields:"comment_id") @key(fields:"post_id"){
    comment_id: ID!,
    comment: String,
    post_id: ID!,
    commentor: User!
}

 type User @key(fields: "user_id", resolvable: false) {
      user_id: ID!
 }


type Query{
     getComment: Comment,
     getAllComments:[Comment]
}

type Mutation{
     createComment(comment: String, post_id: ID) : Comment,
     updateComment(comment_id: ID, comment: String): Comment,
     deleteComment(comment_id: ID): Comment
 }


`;

module.exports= typeDefs;