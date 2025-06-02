import 'package:flutter/material.dart';
import 'package:shop/src/constants.dart';

class OrderDetailShimmer extends StatefulWidget {
  const OrderDetailShimmer({super.key});

  @override
  State<OrderDetailShimmer> createState() => _OrderDetailShimmerState();
}

class _OrderDetailShimmerState extends State<OrderDetailShimmer>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildOrderSummaryShimmer(),
          SizedBox(height: 12),
          _buildOrderItemsShimmer(),
          SizedBox(height: 12),
          _buildCustomerDetailsShimmer(),
          SizedBox(height: 12),
          _buildActionButtonShimmer(),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryShimmer() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildShimmerBox(width: 20, height: 20, isCircle: true),
              SizedBox(width: 8),
              _buildShimmerBox(width: 120, height: 18),
            ],
          ),
          SizedBox(height: 16),
          _buildShimmerBox(
              width: 100, height: 32, borderRadius: defaultBorderRadius),
          SizedBox(height: 16),
          Row(
            children: [
              _buildShimmerBox(width: 16, height: 16, isCircle: true),
              SizedBox(width: 8),
              _buildShimmerBox(width: 140, height: 14),
            ],
          ),
          SizedBox(height: 12),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey[200],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerBox(width: 100, height: 16),
              _buildShimmerBox(width: 80, height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsShimmer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildShimmerBox(width: 20, height: 20, isCircle: true),
              SizedBox(width: 8),
              _buildShimmerBox(width: 80, height: 18),
            ],
          ),
          SizedBox(height: 16),
          // First item
          _buildItemShimmer(),
          SizedBox(height: 8),
          // Second item
          _buildItemShimmer(),
          SizedBox(height: 8),
          // Third item
          _buildItemShimmer(),
        ],
      ),
    );
  }

  Widget _buildItemShimmer() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: Row(
        children: [
          _buildShimmerBox(
              width: 50, height: 50, borderRadius: defaultBorderRadius),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerBox(width: double.infinity, height: 14),
                SizedBox(height: 4),
                _buildShimmerBox(width: 60, height: 12),
              ],
            ),
          ),
          SizedBox(width: 12),
          _buildShimmerBox(width: 60, height: 14),
        ],
      ),
    );
  }

  Widget _buildCustomerDetailsShimmer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildShimmerBox(width: 20, height: 20, isCircle: true),
              SizedBox(width: 8),
              _buildShimmerBox(width: 130, height: 18),
            ],
          ),
          SizedBox(height: 16),
          _buildDetailRowShimmer(),
          SizedBox(height: 12),
          _buildDetailRowShimmer(),
          SizedBox(height: 12),
          _buildDetailRowShimmer(),
          SizedBox(height: 12),
          _buildDetailRowShimmer(),
        ],
      ),
    );
  }

  Widget _buildDetailRowShimmer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmerBox(width: 16, height: 16, isCircle: true),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerBox(width: 60, height: 12),
              SizedBox(height: 2),
              _buildShimmerBox(width: double.infinity, height: 14),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtonShimmer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: _buildShimmerBox(
        width: double.infinity,
        height: 50,
        borderRadius: defaultBorderRadius,
      ),
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    double? borderRadius,
    bool isCircle = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: isCircle
            ? BorderRadius.circular(height / 2)
            : BorderRadius.circular(borderRadius ?? 4),
        color: Colors.grey.withAlpha(20),
      ),
    );
  }
}
