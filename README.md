# insta_flutter

Built a clone of basic instagram in flutter that allow users to share their photos with others as a post.</br>
Posts can be liked and commented on by users. Users can follow and see the newsfeed of other users 
that they are following. </br>

<b>Implemented an Apollo federation based microservices architecture and GraphQL API.</b></br>

<b>Implemented firebase authentication at the frontend and authorisation in the backend(gateway) by getting user token from headers and pass this token from context to each subgraph as 'userid'.</b></br>

<b>Databases used - Neo4j, MongoDB, Firebase Storage.</b></br>

<b>Implemented Referential Integrity like mechanism between these different databases through Apollo Federation</br>
entity's reference resolver.</b></br>

<b>Frontend</b> - is a flutter application which uses firebase authentication for users.</br>
&</br>
<b>Backened</b> - is based on nodes.js and has an apollo federated gateway and server which consists of 3 subgraphs for 3 different microservices:
1) Accounts :- For maintaining user's personal details and their post. This service uses Neo4j database .
2) Posts :- This service is used when users want to upload photos and videos , so the record will contain photo-location, creation date, photo id etc. This service uses             Firebase Storage.
3) Feeds :- This service is used to store the comments of a particular post by other users. This service uses MongoDB database.

### Click and watch the video
[![Output video](/out_thumbn.png)](https://drive.google.com/file/d/12TyxsefCmty0KxsG186VolmUmeSNJ6dR/view?usp=sharing) </br>


