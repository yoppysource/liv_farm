class CartRequest {
  final int amount;
  final bool isDelivery;
  final String? name;
  final String? phoneNumber;
  final String? address;

  CartRequest(
      {required this.amount,
      required this.isDelivery,
      this.name,
      this.phoneNumber,
      this.address});
}
