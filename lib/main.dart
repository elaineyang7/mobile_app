import 'dart:async';

import 'package:flutter/material.dart';
import 'package:elaine_app/post_list.dart';
import 'package:elaine_app/post_model.dart';
import 'package:elaine_app/new_post_form.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'We Rate Posts',
      theme: new ThemeData(brightness: Brightness.dark),
      home: new MyHomePage(title: 'Browse Post'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var initialPosts = <Post>[]

    ..add(new Post('Table', '1000', 'This is a very good table.'));


  Future<Null> _showNewPostForm() async {
    Post newPost = await Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new AddPostFormPage();
        },
      ),
    );
    if (newPost != null) {
      initialPosts.add(newPost);
    }
  }

  @override
  Widget build(BuildContext context) {
    var key = new GlobalKey<ScaffoldState>();
    return new Scaffold(
      key: key,
      appBar: new AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: new Text(widget.title),
        actions: [
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: () => _showNewPostForm(),
          ),
        ],
      ),
      body: new Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(

            begin: Alignment.topRight,
            end: Alignment.bottomLeft,

            stops: [0.1, 0.5, 0.7, 0.9],

            colors: [
              Colors.grey[300],
              Colors.grey[200],
              Colors.grey[100],
              Colors.grey[50],

            ],


          ),
        ),
        child: new Center(
          child: new PostList(initialPosts),
        ),
      ),
    );
  }
}
