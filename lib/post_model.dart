import 'dart:async';
import 'dart:convert';

import 'dart:io';

class Post {
  final String title;
  final String price;
  final String description;
  String image;

  int rating = 10;

  Post(this.title, this.price, this.description);

  Future getImage() async {

    if (image != null) {
      return;
    }
    image;

  }
}
