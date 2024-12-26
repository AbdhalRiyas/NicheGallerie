import 'package:flutter/material.dart';
import 'package:shop/src/components/skeleton/product/products_skelton.dart';
import 'package:shop/src/components/skeleton/skeleton.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/repositories/home_repository.dart';
import 'package:shop/src/utils/build_widget.dart';
import 'package:shop/src/utils/result.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = HomeRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _repository.getWidgets(),
          builder: (context, snapshot) {
            Result? result = snapshot.data;

            if (result != null && result.isSuccess) {
              return CustomScrollView(
                slivers: List.generate(result.data.length,
                    (index) => buildWidget(result.data[index])),
              );
            }
            return ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(defaultPadding / 2),
                  child: Skeleton(
                    height: 200,
                    width: double.infinity,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ProductsSkelton(),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      3,
                      (index) => Skeleton(
                        height: 150,
                        width: (MediaQuery.of(context).size.width -
                                (defaultPadding * 2 + 20)) /
                            3,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
