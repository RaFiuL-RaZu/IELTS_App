class MyPlanModel {
  String? id;
  String? subscriptionType;
  String? subscriptionExpiresAt;

  MyPlanModel({
    this.id,
    this.subscriptionType,
    this.subscriptionExpiresAt,
  });

  MyPlanModel.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    subscriptionType = json["subscriptionType"];
    subscriptionExpiresAt = json["subscriptionExpiresAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["_id"] = id;
    data["subscriptionType"] = subscriptionType;
    data["subscriptionExpiresAt"] = subscriptionExpiresAt;
    return data;
  }
}