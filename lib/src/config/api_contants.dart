class ApiContants {
  ApiContants._internal();
  static final _instance = ApiContants._internal();
  factory ApiContants() => _instance;

  final String config = '/config';
  final String home = '/home';
  final String products = '/products';
  final String categories = '/products/categories';
  final String brands = '/products/brands';
  final String accords = '/products/accords';
  final String notes = '/products/notes';
  final String orders = '/orders';
  final String login = '/auth/login';
  final String register = '/auth/register';
  final String validate = '/auth/validate';
  final String checkoutDetails = '/checkout/details';
  final String checkout = '/checkout';
  final String calculateShipping = '/checkout/shipping-cost';
  final String shippingMethods = '/checkout/shipping-methods';

  final String billingAddress = '/users/billing-address';
  final String countries = '/countries';
}
