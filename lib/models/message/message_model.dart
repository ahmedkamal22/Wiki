class MessageModel {
  String? receiverId;
  String? senderId;
  String? messageText;
  String? messageDate;
  String? messageImage;

  MessageModel({
    this.receiverId,
    this.senderId,
    this.messageText,
    this.messageDate,
    this.messageImage,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    receiverId = json["receiverId"];
    senderId = json["senderId"];
    messageText = json["messageText"];
    messageDate = json["messageDate"];
    messageImage = json["messageImage"];
  }

  Map<String, dynamic> toMap() {
    return {
      "receiverId": receiverId,
      "senderId": senderId,
      "messageText": messageText,
      "messageDate": messageDate,
      "messageImage": messageImage,
    };
  }
}
