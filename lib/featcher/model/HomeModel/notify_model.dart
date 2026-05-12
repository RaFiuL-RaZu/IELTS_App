class NotifyModel {
  Message? message;
  String? sId;
  String? senderId;
  String? receiverId;
  String? type;
  bool? isRead;
  String? createdAt;
  String? updatedAt;

  NotifyModel(
      {this.message,
        this.sId,
        this.senderId,
        this.receiverId,
        this.type,
        this.isRead,
        this.createdAt,
        this.updatedAt});

  NotifyModel.fromJson(Map<String, dynamic> json) {
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
    sId = json['_id'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    type = json['type'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message!.toJson();
    }
    data['_id'] = this.sId;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    data['type'] = this.type;
    data['isRead'] = this.isRead;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Message {
  String? title;
  String? body;

  Message({this.title, this.body});

  Message.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}
