import 'package:flutter/widgets.dart';

class PostsModel {
  @required
  String? name;
  @required
  String? image;
  @required
  String? postDate;
  @required
  String? postText;
  @required
  String? postImage;
  @required
  String? uId;

  PostsModel(
      {this.name,
      this.image,
      this.postDate,
      this.postText,
      this.postImage,
      this.uId});

  PostsModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    image = json["image"];
    postImage = json["postImage"];
    postDate = json["postDate"];
    postText = json["postText"];
    uId = json["uId"];
  }

  Map<String, dynamic>? toMap() {
    return {
      "name": name,
      "image": image,
      "postDate": postDate,
      "postText": postText,
      "postImage": postImage,
      "uId": uId,
    };
  }
}
