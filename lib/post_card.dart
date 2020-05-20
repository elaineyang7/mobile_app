import 'package:flutter/material.dart';
import 'package:elaine_app/post_detail_page.dart';
import 'package:elaine_app/post_model.dart';

class PostCard extends StatefulWidget {
  final Post post;

  PostCard(this.post);

  @override
  PostCardState createState() {
    return new PostCardState(post);
  }
}

class PostCardState extends State<PostCard> {
  Post post;
  String renderUrl;


  PostCardState(this.post);

  void initState() {
    super.initState();
    renderPostPic();
  }

  void renderPostPic() async {
    await post.getImage();
    setState(() {
      renderUrl = post.image;
    //await post.getImageUrl();
    //setState(() {
      //renderUrl = post.imageUrl;
    });
  }

  Widget get postImage {
    var postAvatar = new Hero(
      tag: post,
      child: new Container(
        width: 100.0,
        height: 100.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: new NetworkImage(renderUrl ?? ''),
          ),
        ),
      ),
    );

    var placeholder = new Container(
        width: 100.0,
        height: 100.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,


          gradient: new LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple[50], Colors.deepPurple[100], Colors.deepPurple[200]],
          ),
        ),

        alignment: Alignment.center,

    );


    var crossFade = new AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: postAvatar,
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: new Duration(milliseconds: 1000),
    );

    return crossFade;
  }

  Widget get postCard {
    return new Positioned(
      right: 0.0,
      child: new Container(
        width: 290.0,
        height: 115.0,
        child: new Card(
          color: Colors.deepPurple[300], //black87,
          child: new Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 64.0,
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text(widget.post.title,
                    style: Theme.of(context).textTheme.headline),
                new Text('\$' + widget.post.price,
                    style: Theme.of(context).textTheme.subhead),

              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: () => showPostDetailPage(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: new Container(
          height: 115.0,
          child: new Stack(
            children: <Widget>[
              postCard,
              new Positioned(top: 7.5, child: postImage),
            ],
          ),
        ),
      ),
    );
  }

  showPostDetailPage() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new PostDetailPage(post);
    }));
  }
}
