class HelpModel {
  String? id;
  String? phone;
  String? email;
  String? location;
  String? createdAt;
  String? updatedAt;

  HelpModel({
    this.id,
    this.phone,
    this.email,
    this.location,
    this.createdAt,
    this.updatedAt,
  });

  HelpModel.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    phone = json["phone"];
    email = json["email"];
    location = json["location"];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["_id"] = id;
    data["phone"] = phone;
    data["email"] = email;
    data["location"] = location;
    data["createdAt"] = createdAt;
    data["updatedAt"] = updatedAt;
    return data;
  }
}