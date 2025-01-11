import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shop/src/constants.dart';

void showLoader(BuildContext context, {String? message}) {
  showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimationWidget.flickr(
              leftDotColor: Colors.white,
              rightDotColor: sandDuneColor,
              size: 30,
            ),
            if (message != null) ...[
              const SizedBox(height: defaultPadding),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ],
        ),
      );
    },
  );
}

void hideLoader(BuildContext context) {
  Navigator.of(context).pop();
}
