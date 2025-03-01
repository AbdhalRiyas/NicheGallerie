class ShippingModel {
  final String title, methodId;
  final String cost;
  final dynamic classCosts;

  ShippingModel(
      {required this.title,
      required this.methodId,
      required this.cost,
      required this.classCosts});

  factory ShippingModel.fromJson(Map<String, dynamic> json) {
    return ShippingModel(
        title: json['title'],
        methodId: json['method_id'],
        cost: json['cost'],
        classCosts: json['class_costs']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'method_id': methodId,
      'cost': cost,
      'class_costs': classCosts
    };
  }
}
