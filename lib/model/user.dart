class UserModel {
  final String id;
  final String createdAt;
  final String owner;
  final String avatar;
  final double value; 
  final String currency;

  UserModel({
    required this.id,
    required this.createdAt,
    required this.owner,
    required this.avatar,
    required this.value, 
    required this.currency,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      createdAt: json['createdAt'],
      owner: json['owner'],
      avatar: json['avatar'],
      value: double.parse(json['value'].toString()), 
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'owner': owner,
      'avatar': avatar,
      'value': value,
      'currency': currency,
    };
  }

  UserModel copyWith({
    String? id,
    String? createdAt,
    String? owner,
    String? avatar,
    double? value,
    String? currency,
  }) {
    return UserModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      owner: owner ?? this.owner,
      avatar: avatar ?? this.avatar,
      value: value ?? this.value,
      currency: currency ?? this.currency,
    );
  }
}

