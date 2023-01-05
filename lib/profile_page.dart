import 'package:flutter/material.dart';
//import 'package:flutter_try/insta_home.dart';
import 'package:insta_flutter/profile_body.dart';

class Profile extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileBody(),
      //bottomNavigationBar: InstaHome().bottomBar,
    );

  }
}

