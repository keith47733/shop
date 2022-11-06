class CartItem {
	// Since each class (ProductItem, OrderItem, CartItem) uses a String ID, name these variables with the class prefix to avoid conufsion. Otherwise, single word names are OK since they will be called with the class for context (eg, CartItem.title).
  final String cartItemId;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    required this.cartItemId,
    required this.title,
    required this.price,
    required this.quantity,
  });
}
