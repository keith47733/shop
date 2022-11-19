import 'cart_detail.dart';

class OrderDetail {
  final String orderProductId;
  final DateTime orderDate;
  final List<CartDetail> products;
  final double amount;

  OrderDetail({
    required this.orderProductId,
    required this.orderDate,
    required this.products,
    required this.amount,
  });
}
