import 'package:flutter/material.dart';
import 'package:shop/src/repositories/home_repository.dart';
import 'package:shop/src/screens/home/views/components/home_skeleton.dart';
import 'package:shop/src/utils/build_widget.dart';
import 'package:shop/src/utils/result.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.repository});

  final HomeRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: repository.getWidgets(context),
          builder: (context, snapshot) {
            Result? result = snapshot.data;

            if (snapshot.hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("An error occurred: ${snapshot.error}"),
                    backgroundColor: Colors.red,
                  ),
                );
              });
              return HomeSkeleton(); // Fallback UI in case of an error
            }

            if (result != null && result.isSuccess) {
              return CustomScrollView(
                slivers: List.generate(
                  result.data.length,
                  (index) => buildWidget(result.data[index]),
                ),
              );
            }
            return HomeSkeleton();
          },
        ),
      ),
    );
  }
}
