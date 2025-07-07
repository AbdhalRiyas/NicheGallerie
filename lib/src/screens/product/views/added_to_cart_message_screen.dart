// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shop/src/constants.dart';
// import 'package:shop/src/route/screen_export.dart';

// class AddedToCartMessageScreen extends StatelessWidget {
//   const AddedToCartMessageScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
//           child: Column(
//             children: [
//               const Spacer(),
//               SvgPicture.asset(
//                 "assets/icons/cart-check.svg",
//                 width: 200,
//                 colorFilter: ColorFilter.mode(
//                   primaryColor.withAlpha(100),
//                   BlendMode.srcIn,
//                 ),
//                 height: MediaQuery.of(context).size.height * 0.3,
//               ),
//               const Spacer(flex: 2),
//               Text(
//                 "Added to cart",
//                 style: Theme.of(context)
//                     .textTheme
//                     .headlineSmall!
//                     .copyWith(fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: defaultPadding / 2),
//               const Text(
//                 "Click the checkout button to complete the purchase process.",
//                 textAlign: TextAlign.center,
//               ),
//               const Spacer(flex: 2),
//               OutlinedButton(
//                 onPressed: () {
//                   context.pop();
//                 },
//                 child: const Text("Continue shopping"),
//               ),
//               const SizedBox(height: defaultPadding),
//               ElevatedButton(
//                 onPressed: () {
//                   context.go('/$cartScreenRoute');
//                   context.pop();
//                 },
//                 child: const Text("Checkout"),
//               ),
//               const Spacer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
