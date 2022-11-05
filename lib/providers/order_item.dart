import 'cart_item.dart';

class OrderItem {
  final String orderId;
  final double amount;
  final List<CartItem> products;
  final DateTime orderDate;

  OrderItem({
    required this.orderId,
    required this.amount,
    required this.products,
    required this.orderDate,
  });
}
