class FeeModel {
  final String name;
  final double amount;
  final String type;

  FeeModel({
    required this.name,
    required this.amount,
    required this.type,
  });

  factory FeeModel.fromJson(Map<String, dynamic> json) {
    return FeeModel(
      name: json['name'],
      amount: json['amount'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'type': type,
    };
  }

  FeeModel copyWith({
    String? name,
    double? amount,
    String? type,
  }) {
    return FeeModel(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      type: type ?? this.type,
    );
  }
}
