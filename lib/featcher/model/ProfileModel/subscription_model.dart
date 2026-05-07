class SubscriptionModel {
  final String? id;
  final String? title;
  final String? description;
  final int price;
  final int durationInDays;
  final List<String> features;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubscriptionModel({
    this.id = '',
    this.title = '',
    this.description = '',
    this.price = 0,
    this.durationInDays = 0,
    this.features = const [],
    this.isActive = false,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      durationInDays: json['durationInDays'] ?? 0,
      features: List<String>.from(json['features'] ?? []),
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id ?? '',
      'title': title ?? '',
      'description': description ?? '',
      'price': price,
      'durationInDays': durationInDays,
      'features': features,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return '''
SubscriptionModel {
  id: $id,
  title: $title,
  description: $description,
  price: $price,
  durationInDays: $durationInDays,
  features: $features,
  isActive: $isActive,
  createdAt: $createdAt,
  updatedAt: $updatedAt
}
''';
  }
}