import 'package:flutter/widgets.dart';

class CommentModel {
  @required
  String? name;
  @required
  String? image;
  @required
  String? commentDate;
  @required
  String? commentText;

  @required
  String? commentImage;

  @required
  String? uId;

  CommentModel(
      {this.name,
      this.image,
      this.commentDate,
      this.commentText,
      this.commentImage,
      this.uId});

  CommentModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    image = json["image"];
    commentImage = json["commentImage"];
    commentDate = json["commentDate"];
    commentText = json["commentText"];
    uId = json["uId"];
  }

  Map<String, dynamic>? toMap() {
    return {
      "name": name,
      "image": image,
      "commentDate": commentDate,
      "commentText": commentText,
      "commentImage": commentImage,
      "uId": uId,
    };
  }
}
