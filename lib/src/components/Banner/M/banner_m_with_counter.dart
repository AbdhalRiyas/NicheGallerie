import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../blur_container.dart';
import 'banner_m.dart';

class BannerMWithCounter extends StatefulWidget {
  const BannerMWithCounter({
    super.key,
    this.image =
        "https://nichegallerie.com/wp-content/uploads/2024/11/Black-friday-sale-subbanner.webp",
    required this.title,
    required this.duration,
    required this.press,
    this.subtitle,
    this.ctaText,
  });

  final String image, title;
  final String? subtitle;
  final String? ctaText;
  final Duration duration;
  final VoidCallback press;

  @override
  State<BannerMWithCounter> createState() => _BannerMWithCounterState();
}

class _BannerMWithCounterState extends State<BannerMWithCounter> {
  late Duration _duration;
  late Timer _timer;

  @override
  void initState() {
    _duration = widget.duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _duration = Duration(seconds: _duration.inSeconds - 1);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BannerM(
      image: widget.image,
      press: widget.press,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: defaultPadding),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: defaultPadding),
            if (widget.subtitle != null)
              Text(
                widget.subtitle!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            const SizedBox(height: defaultPadding / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlurContainer(
                  text: _duration.inHours.toString().padLeft(2, "0"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 4),
                  child: SvgPicture.asset("assets/icons/dot.svg"),
                ),
                BlurContainer(
                  text: _duration.inMinutes
                      .remainder(60)
                      .toString()
                      .padLeft(2, "0"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 4),
                  child: SvgPicture.asset("assets/icons/dot.svg"),
                ),
                BlurContainer(
                  text: _duration.inSeconds
                      .remainder(60)
                      .toString()
                      .padLeft(2, "0"),
                ),
              ],
            ),
            if (widget.ctaText != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: SizedBox(
                    width: 200,
                    height: 28,
                    child: ElevatedButton.icon(
                      onPressed: widget.press,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      iconAlignment: IconAlignment.end,
                      icon: Icon(Icons.chevron_right),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.ctaText.toString(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
