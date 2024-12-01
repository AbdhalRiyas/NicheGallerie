import 'package:flutter/material.dart';
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
            return CircularProgressIndicator.adaptive();
          },
        ),
      ),
    );
  }
}
