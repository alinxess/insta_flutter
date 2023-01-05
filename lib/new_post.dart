import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class NewPost extends StatefulWidget{
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  /* ? -> can be nullable
     ! -> cant be null
   */

  //uploadPhoto mutation
  final String uploadPhoto = """
  mutation UploadPhoto(\$photo: Upload!){
    uploadPhoto(input: {photo: \$photo}) {
        photo_id
    }
  }
""";

  //addPost mutation
  final String addPost = """
  mutation AddPost(\$filename: String!, \$content: String){
    addPost(input: {filename: \$filename, content: \$content}){
      
    }
  }
""";

  //getPhotoUrl query
  final String getUserQuery = '''
  query ReadUsers(\$photo: String!){
         getuserPhoto(photo: \$photo){
                   file_name           
         }                       
  }
 ''';

  File? _image;
  String? _content;
  final picker = ImagePicker();

  Future getImageFile(ImageSource src) async {
    //picking from gallery
    final pickedFile = await picker.getImage(source: src);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }


  Widget getPhoto() {
    return Container(
        child: Query(
            options: QueryOptions(document: gql(getUserQuery),
                variables:{
                   'photo': _image,
                },
                pollInterval: Duration(seconds: 1),
                fetchPolicy: FetchPolicy.cacheAndNetwork),
            builder: (QueryResult result,
                {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }
              if (result.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (result.data == null) {
                return Center(child: Text('Users post not found.'));
              }

              String file_name = result.data!['getuserPhoto']['file_name'];
              createPost(file_name, _content);
              return Text(" ");
            }
        )
    );
  }


  Widget createPost(String filename, String? content) {
    return Container(
        child: Mutation(
            options: MutationOptions(
              document: gql(addPost),
              update: (GraphQLDataProxy? cache, QueryResult? result) {
                return cache;
              },
              onCompleted: (dynamic resultData) {
                print(resultData);
              },
            ),
            builder: (RunMutation? runMutation, QueryResult? result) {
              runMutation!({
                'filename': filename,
                'content': content
              });
              return Text(" ");
            }
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Mutation(
        options: MutationOptions(
          document: gql(addPost),
          update: (GraphQLDataProxy? cache, QueryResult? result) {
            return cache;
          },
          onCompleted: (dynamic resultData) {
            print(resultData);
          },
        ),
        builder: (RunMutation? runMutation,
            QueryResult? result,) {
          bool flag = false;
          if (result!.hasException) {
            return Text(result!.exception.toString());
          }else{
            flag = true;
          }
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Center(
                  child: _image == null
                      ? Text("No Image selected")
                      : Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() {
                      _content = value;
                    });
                  },
                  decoration: InputDecoration(
                      labelText: 'write something..'
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton.extended(
                      label: Text("Camera"),
                      onPressed: () => {getImageFile(ImageSource.camera),},
                      //getImageFile(ImageSource.camera),
                      heroTag: UniqueKey(),
                      icon: Icon(Icons.camera),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    FloatingActionButton.extended(
                      label: Text("Gallery"),
                      onPressed: () => {getImageFile(ImageSource.gallery),},
                      //getImageFile(ImageSource.gallery),
                      heroTag: UniqueKey(),
                      icon: Icon(Icons.photo_library),
                    ),
                  ],
                ),
                FloatingActionButton.extended(
                  label: Text("Post"),
                  onPressed: () =>
                  {
                    runMutation!({
                      'photo': _image
                    }),
                    flag==true? getPhoto(): Text(" "),
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/*
Center(
        child: _image == null
            ? Text("No Image selected")
            : Image.file(
          _image!,
          height: 200,
          width: 200,
        ),
      ),
      floatingActionButton:Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            label: Text("Camera"),
            onPressed: () => {getImageFile(ImageSource.camera),},//getImageFile(ImageSource.camera),
            heroTag: UniqueKey(),
            icon: Icon(Icons.camera),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton.extended(
            label: Text("Gallery"),
            onPressed: () => {getImageFile(ImageSource.gallery),},//getImageFile(ImageSource.gallery),
            heroTag: UniqueKey(),
            icon: Icon(Icons.photo_library),
          )
        ],
      ),

 */
