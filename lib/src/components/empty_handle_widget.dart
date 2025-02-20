import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/src/constants.dart';

class EmptyHandleWidget extends StatelessWidget {
  const EmptyHandleWidget({
    super.key,
    required this.iconSrc,
    required this.title,
  });

  final String iconSrc, title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconSrc,
            height: 100,
            width: 100,
            colorFilter: ColorFilter.mode(
              Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withValues(alpha: 0.3),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: defaultPadding),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
