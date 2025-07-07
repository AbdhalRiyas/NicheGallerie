import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';

SnackBar customSnackBar(
  String text, {
  SnackBarAction? action,
}) {
  return SnackBar(
      margin: const EdgeInsets.all(defaultPadding / 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: primaryColor,
      content: Text(text),
      duration: const Duration(seconds: 3),
      action: action);
}
