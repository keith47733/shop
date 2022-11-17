import 'cart_product.dart';

class OrderProduct {
  final String orderProductId;
  final DateTime orderDate;
  final List<CartProduct> products;
  final double amount;

  OrderProduct({
    required this.orderProductId,
    required this.orderDate,
    required this.products,
    required this.amount,
  });
}
