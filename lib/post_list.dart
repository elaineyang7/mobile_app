import 'package:flutter/material.dart';
import 'package:elaine_app/post_card.dart';
import 'package:elaine_app/post_model.dart';

class PostList extends StatelessWidget {
  final List<Post> posts;

  PostList(this.posts);

  ListView _buildList(context) {
    return new ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, int) {
        return new PostCard(posts[int]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }
}
