import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:insta_flutter/insta_stories.dart';



class InstaList extends StatefulWidget{

_InstaListState createState() => _InstaListState();

}

class _InstaListState extends State<InstaList>{
  bool isPressed = false;

  //getRecommendedPosts query
  final String getUserQuery = '''
  query ReadUsers{
                getRecommendedPosts {
                         photo {
                             file_name
                         }
                         content
                         likes
                         creator {
                              username
                              profile_photo {
                                      file_name
                              }
                         }
                         comments {
                              comment
                              commentor {
                                     username
                                     profile_photo {
                                             file_name
                                     }
                              }
                         }
                }                       
}
''';

  @override
  Widget build(BuildContext context) {
    var deviceSize= MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: Query(
                options: QueryOptions(document: gql(getUserQuery), pollInterval: Duration(seconds: 1), fetchPolicy: FetchPolicy.cacheAndNetwork),
                builder: (QueryResult result,{VoidCallback? refetch, FetchMore? fetchMore}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (result.data == null) {
                    return Center(child: Text('Users post not found.'));
                  }

                  List postList = result.data!['getRecommendedPosts'];

                  //Map<String,dynamic> postList = result.data!['getRecommendedPosts'];
                  /*String photo_url= postList['photo']['file_name']!=null?postList['photo']['file_name']:' ';
                  String content= postList['content']!=null?postList['content']:' ';
                  String likes= postList['likes']!=null?postList['likes']:' ';
                  String creatorname= postList['creator']['username']!=null?postList['creator']['username']:' ';
                  String creatorprofile= postList['creator']['profile_photo']['file_name']!=null?postList['creator']['profile_photo']['file_name']:' ';
                  */

                  return ListView.builder(
                    itemCount: postList.length,
                    itemBuilder: (context,index) {

                      final post = postList[index];
                      String photo_url= post[0][0]!=null?post[0][0]:' ';
                      String content= post[1]!=null?post[1]:' ';
                      String likes= post[2]!=null?post[2]:' ';
                      String creatorname= post[3][0]!=null?post[0][0]:' ';
                      String creatorprofile= post[3][1][0]!=null?post[3][1][0]:' ';

                      List comments = postList[4];
                      String comment= comments[0][0]!=null?comments[0][0]:' ';
                      String commentor= comments[1][0]!=null?comments[1][0]:' ';
                      String commentor_photo= comments[1][1][0]!=null?comments[1][1][0]:' ';

                      return index == 0
                          ? new SizedBox(
                        child: new InstaStories(),
                        height: deviceSize.height * 0.15,
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 8.0, 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    new Container(
                                      height: 40.0,
                                      width: 40.0,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new NetworkImage(
                                                creatorprofile)
                                        ),
                                      ),
                                    ),
                                    new SizedBox(
                                      width: 10.0,
                                    ),
                                    new Text(
                                      creatorname,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                new IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: null,
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: new Image.network(
                              photo_url,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    new IconButton(
                                      icon: new Icon(isPressed
                                          ? Icons.favorite
                                          : Icons.favorite_border),
                                      color: isPressed ? Colors.red : Colors
                                          .black,
                                      onPressed: () {
                                        setState(() {
                                          isPressed = !isPressed;
                                        });
                                      },
                                    ),
                                    new SizedBox(
                                      width: 12.0,
                                    ),
                                    new Icon(
                                      Icons.mode_comment,
                                    ),
                                    new SizedBox(
                                      width: 16.0,
                                    ),
                                    new Icon(
                                      Icons.send,
                                    ),
                                  ],
                                ),
                                new Icon(
                                  Icons.bookmark,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0),
                            child: Text(
                              "Liked by pawankumar, pk and "+ likes + "others",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                12.0, 16.0, 0.0, 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                            commentor_photo
                                        ),
                                    ),
                                  ),
                                ),
                                new SizedBox(
                                  width: 10.0,
                                ),
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                      new Text(
                                          commentor,
                                         style: TextStyle(
                                         fontWeight: FontWeight.bold),
                                      ),
                                      new Text(
                                        comment,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                      ),
                                ]),
                                Expanded(
                                  child: new TextField(
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintText: " Add a comment...",
                                    ),
                                  ),
                                ),
                              ],

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0),
                            child: Text("1 day ago", style: TextStyle(
                                color: Colors.grey)),
                          )
                        ],
                      );
                    }
                  );
                },
            ),
        )
      ],
    );

  }
}

