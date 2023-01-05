import'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RegPage extends StatefulWidget{
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage>{
   String _username=' ';


    String saveUserProfile= """
     mutation saveProfiles( \$username: String! ){
      createUser(input: { username: \$username }){
               username
      }
   }
    """;


   final ButtonStyle style= ElevatedButton.styleFrom(
     primary: Colors.blue,
     elevation: 5.0,
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(30.0),
     ),
   );

   @override
  Widget build(BuildContext context) {
      return Mutation(
        options: MutationOptions(document: gql(saveUserProfile)),
        builder: ( RunMutation runMutation, QueryResult? result) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Color(0xfff2f3f7),
              body: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff2470c7),
                        borderRadius: BorderRadius.only(
                          bottomLeft: const Radius.circular(70),
                          bottomRight: const Radius.circular(70),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildContainer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 1.4 * (MediaQuery.of(context).size.height / 20),
                            width: 5 * (MediaQuery.of(context).size.width / 10),
                            margin: EdgeInsets.only(bottom: 20),
                            child: ElevatedButton(
                              style: style,
                              onPressed: () =>runMutation({
                                'username': _username,
                              }),
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: MediaQuery.of(context).size.height / 40,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Card(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.white,
                          child: Text(
                            result == null
                                ? '''Post details coming up shortly,'''
                                ''' Kindly enter details and create a post'''
                                : result.data.toString(),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );

         }

        );
   }



   Widget _buildUnameRow(){
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: TextFormField(
         keyboardType: TextInputType.text,
         validator:(String? value){
           if(value!.isEmpty){
             return 'Please enter an username';
           }
           return null;
         },
         onChanged: (value){
           setState(() {
             _username=value;
           });
         },
         decoration: InputDecoration(
             prefixIcon: Icon(
                 Icons.person
             ),
             labelText: 'username'
         ),
       ),
     );
   }

   /*Widget _buildFnameRow(){
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: TextFormField(
         keyboardType: TextInputType.text,
         validator:(String? value){
           if(value!.isEmpty){
             return 'Please enter an fullname';
           }
           return null;
         },
         onChanged: (value){
           setState(() {
             _fullname=value;
           });
         },
         decoration: InputDecoration(
             prefixIcon: Icon(
                 Icons.person
             ),
             labelText: 'fullname'
         ),
       ),
     );
   }*/


   Widget _buildContainer(){
     return Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: <Widget>[
         ClipRRect(
           borderRadius: BorderRadius.all(
             Radius.circular(20.0),
           ),
           child: Container(
             height: MediaQuery.of(context).size.height * 0.6,
             width: MediaQuery.of(context).size.width * 0.8,
             decoration: BoxDecoration(
               color: Colors.white,
             ),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: <Widget>[
                     Text(
                       "Registration",
                       style: TextStyle(
                         fontSize: MediaQuery.of(context).size.height / 30,
                       ),
                     ),
                   ],
                 ),

                 _buildUnameRow(),

                 // _buildFnameRow(),
                 //_buildRegButton()

               ],
             ),
           ),
         ),
       ],
     );
   }
}