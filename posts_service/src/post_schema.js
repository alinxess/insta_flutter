const { gql } = require('apollo-server');

const typeDefs = gql`
extend schema
    @link(url: "https://specs.apollo.dev/federation/v2.0",
          import: ["@key", "@shareable"])

scalar Upload

type Photo @key(fields:"photo_id"){
     photo_id:ID!,
     file_name:String!,
     user_id:ID!,
}

type Query{
     getuserPhoto: Photo
}

type Mutation{
     uploadPhoto(photo: Upload!): Photo,
     deletePhoto(photo_id: ID!): Photo
}

`;

module.exports= typeDefs;