import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shop/src/components/skeleton/skeleton.dart';
import 'package:shop/src/constants.dart';
import 'package:shop/src/models/order.dart';
import 'package:shop/src/repositories/order_repository.dart';
import 'package:shop/src/route/screen_export.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderRepository orderRepository = OrderRepository();
  final ScrollController _scrollController = ScrollController();
  List<Order> _orders = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders({bool isRefresh = false}) async {
    if (_isLoading || (!_hasMore && !isRefresh)) return;

    setState(() {
      _isLoading = true;
      if (isRefresh) {
        _currentPage = 1;
        _orders = [];
        _hasMore = true;
        _isRefreshing = true;
      }
    });

    final result = await orderRepository.fetchOrders(page: _currentPage);

    setState(() {
      _isLoading = false;
      _isRefreshing = false;

      if (result.isSuccess && result.data.isNotEmpty) {
        // Explicitly cast result.data to List<Order>
        _orders.addAll(result.data.cast<Order>());
        _currentPage++;
        _hasMore = result.data.length >= 10; // Assuming per_page is 10
      } else {
        _hasMore = false;
      }
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadOrders();
    }
  }

  Future<void> _onRefresh() async {
    await _loadOrders(isRefresh: true);
  }

  final Map<String, dynamic> orderStatus = {
    'pending': {
      'title': 'Awaiting Payment',
      'color': Colors.orange,
      'icon': Icons.schedule,
      'bgColor': Colors.orange.withAlpha(25),
    },
    'processing': {
      'title': 'Ready to Ship',
      'color': Colors.blue,
      'icon': Icons.local_shipping_outlined,
      'bgColor': Colors.blue.withAlpha(25),
    },
    'on-hold': {
      'title': 'On Hold',
      'color': Colors.grey,
      'icon': Icons.pause_circle_outline,
      'bgColor': Colors.grey.withAlpha(25),
    },
    'completed': {
      'title': 'Shipped',
      'color': Colors.green,
      'icon': Icons.check_circle_outline,
      'bgColor': Colors.green.withAlpha(25),
    },
    'cancelled': {
      'title': 'Cancelled',
      'color': Colors.red,
      'icon': Icons.cancel_outlined,
      'bgColor': Colors.red.withAlpha(25),
    },
    'refunded': {
      'title': 'Refunded',
      'color': Colors.purple,
      'icon': Icons.money_off,
      'bgColor': Colors.purple.withAlpha(25),
    },
    'failed': {
      'title': 'Payment Failed',
      'color': Colors.red,
      'icon': Icons.error_outline,
      'bgColor': Colors.red.withAlpha(25),
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _onRefresh,
        child: _orders.isEmpty && !_isLoading
            ? _buildEmptyState()
            : ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  if (index < _orders.length) {
                    return _buildOrderCard(
                      context,
                      _orders[index],
                      orderStatus,
                      orderRepository,
                    );
                  } else if (_hasMore) {
                    return _buildShimmer();
                  } else {
                    return SizedBox.shrink();
                  }
                },
                itemCount: _orders.length + (_hasMore ? 1 : 0),
              ),
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    Order order,
    Map<String, dynamic> orderStatus,
    OrderRepository orderRepository,
  ) {
    final status = orderStatus[order.status] ?? orderStatus['pending'];
    final totalItems = orderRepository.totalItemsInOrder(order.items);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          onTap: () {
            context.goNamed(viewOrderScreen, pathParameters: {
              'id': order.id.toString(),
            });
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: sandDuneColor.withAlpha(25),
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                          ),
                          child: Text(
                            "#${order.id}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: sandDuneColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: status['bgColor'],
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            status['icon'],
                            size: 14,
                            color: status['color'],
                          ),
                          SizedBox(width: 4),
                          Text(
                            status['title'],
                            style: TextStyle(
                              color: status['color'],
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 6),
                              Text(
                                "$totalItems ${totalItems > 1 ? 'items' : 'item'}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            "${order.currency} ${order.total}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Order Date",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            DateFormat('MMM d, yyyy').format(
                              DateTime.parse(order.dateCreated),
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Orders Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your order history will appear here\nonce you make your first purchase',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Skeleton(height: 24, width: 80),
                  Skeleton(height: 24, width: 100),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton(height: 16, width: 60),
                      SizedBox(height: 8),
                      Skeleton(height: 20, width: 80),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Skeleton(height: 14, width: 70),
                      SizedBox(height: 6),
                      Skeleton(height: 16, width: 90),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
