import 'package:intl/intl.dart';
import 'package:shop/src/models/currency.dart';

String formatCurrency(double amount, Currency currency,
    [bool showSymbol = true]) {
  String formattedAmount = NumberFormat.currency(
    symbol: '',
    decimalDigits: currency.decimals,
  ).format(amount);

  if (!showSymbol) {
    return formattedAmount;
  }

  switch (currency.pos) {
    case 'left':
      return '${currency.symbol}$formattedAmount';
    case 'left_space':
      return '${currency.symbol} $formattedAmount';
    case 'right':
      return '$formattedAmount${currency.symbol}';
    case 'right_space':
    default:
      return '$formattedAmount ${currency.symbol}';
  }
}
