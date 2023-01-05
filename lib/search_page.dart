import 'package:flutter/material.dart';
import 'package:insta_flutter/search_page_body.dart';


class SearchPage extends StatelessWidget{



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SearchPageBody(),
     // bottomNavigationBar: InstaHome().bottomBar,
    );
  }
}