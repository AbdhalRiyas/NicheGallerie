import 'package:expressions/expressions.dart';
import 'package:flutter/foundation.dart';

double calculateCost(Map<String, dynamic> data, int qty) {
  double cost = data['cost'] != null ? double.parse(data['cost']) : 0.0;
  if (data.containsKey("class_costs") &&
      data["class_costs"].containsKey("no_class_cost")) {
    String costExpression = data["class_costs"]["no_class_cost"];

    // Remove spaces
    costExpression = costExpression.replaceAll(" ", "");

    // Replace [qty] with the actual quantity
    costExpression = costExpression.replaceAll("[qty]", qty.toString());

    cost += evaluateExpression(costExpression);
  }
  return cost;
}

double evaluateExpression(String expression) {
  try {
    final parsedExpression = Expression.parse(expression);

    final evaluator = const ExpressionEvaluator();
    return evaluator.eval(parsedExpression, {}).toDouble();
  } catch (e) {
    debugPrint("Error evaluating expression: $e");
    return 0.0;
  }
}
