import 'dart:async';

import 'package:flutter/material.dart';
import 'package:elaine_app/post_model.dart';
import 'package:elaine_app/common_widgets/avatar.dart';

class PostDetailPage extends StatefulWidget {
  final Post post;

  PostDetailPage(this.post);

  @override
  _PostDetailPageState createState() => new _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  double postAvatarSize = 150.0;
  double _sliderValue = 10.0;

  Widget get postImage {
    return new Hero(
      tag: widget.post,
      child: new Container(
        height: postAvatarSize,
        width: postAvatarSize,
        constraints: new BoxConstraints(),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,


          image: new DecorationImage(
            image: new NetworkImage(widget.post.image ?? ''),
          ),
        ),
      ),
    );
  }

  Widget get postProfile {
    return new Container(
      padding: new EdgeInsets.symmetric(vertical: 32.0),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],

          colors: [
            Colors.deepPurple[200],
            Colors.deepPurple[200],
            Colors.deepPurple[100],
            Colors.deepPurple[100],
          ],


        ),
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          postImage,
          new Text(
            widget.post.title,
            style: new TextStyle(fontSize: 32.0),
          ),
          new Text(
            '\$' + widget.post.price,
            style: new TextStyle(fontSize: 20.0),
          ),
          new Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: new Text(widget.post.description),
          ),
          //rating
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: new Text('${widget.post.title}'),
      ),
      body: new ListView(
        children: <Widget>[postProfile],// addYourRating],
      ),
    );
  }
}
