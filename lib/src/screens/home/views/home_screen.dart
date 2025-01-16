import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shop/src/components/empty_error_state_widget.dart';
import 'package:shop/src/repositories/home_repository.dart';
import 'package:shop/src/screens/home/views/components/home_skeleton.dart';
import 'package:shop/src/utils/build_widget.dart';
import 'package:shop/src/utils/result.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.repository});

  final HomeRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Result> _future;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Initialize the future
  }

  void _fetchData() {
    setState(() {
      _future = widget.repository.getWidgets(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SnapHelperWidget<Result>(
          future: _future,
          onSuccess: (result) {
            if (result.isSuccess) {
              // Render data if the result indicates success
              return CustomScrollView(
                slivers: List.generate(
                  result.data.length,
                  (index) => buildWidget(result.data[index]),
                ),
              );
            } else {
              // Display NoDataWidget if the result indicates failure
              return NoDataWidget(
                title: result.error, // Display error message
                imageWidget: const ErrorStateWidget(),
                retryText: 'Reload',
                onRetry: _fetchData, // Retry logic
              );
            }
          },
          loadingWidget: const HomeSkeleton(), // Loading UI
          errorBuilder: (error) {
            // Handle errors by showing the NoDataWidget
            return NoDataWidget(
              title: error.toString(), // Display error message
              imageWidget: const ErrorStateWidget(),
              retryText: 'Reload',
              onRetry: _fetchData, // Retry logic
            );
          },
        ),
      ),
    );
  }
}
