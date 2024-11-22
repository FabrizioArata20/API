class UserModel {
  final String id;
  final String createdAt;
  final String name;
  final String avatar;
  final dynamic currency; 

  UserModel({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.avatar,
    required this.currency,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var currencyValue = json['currency'];
    if (currencyValue is String) {
      currencyValue = int.tryParse(currencyValue) ?? currencyValue;
    }

    return UserModel(
      id: json['id'],
      createdAt: json['createdAt'],
      name: json['name'],
      avatar: json['avatar'],
      currency: currencyValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'name': name,
      'avatar': avatar,
      'currency': currency,
    };
  }

  UserModel copyWith({
    String? id,
    String? createdAt,
    String? name,
    String? avatar,
    dynamic currency,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      currency: currency ?? this.currency,
    );
  }
}
