import 'cart_item.dart';

class OrderItem {
  final String orderItemId;
  final DateTime orderDate;
  final List<CartItem> products;
  final double amount;

  OrderItem({
    required this.orderItemId,
    required this.orderDate,
    required this.products,
    required this.amount,
  });
}
