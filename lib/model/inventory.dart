class Inventory {
  final int quantity;
  final int productID;

  Inventory({this.quantity, this.productID});

  factory Inventory.fromJson(Map<String, int> data) {
    if(data == null){
      return null;
    }else {
      return Inventory(
        quantity: data["quantity"],
        productID: data["product_id"],
      );
    }
  }
}