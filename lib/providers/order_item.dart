import 'cart_item.dart';

class OrderItem {
  final String orderItemId;
  final double amount;
  final List<CartItem> products;
  final DateTime orderDate;

  OrderItem({
    required this.orderItemId,
    required this.amount,
    required this.products,
    required this.orderDate,
  });
}
