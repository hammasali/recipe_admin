class AddProduct {
  String name, price, quantity;

  AddProduct({this.name, this.price, this.quantity});

  Map toMap(AddProduct user) {
    var data = Map<String, dynamic>();

    data['name'] = user.name;
    data['price'] = user.price;
    data['quantity'] = user.quantity;

    return data;
  }

  factory AddProduct.fromMap(Map<String, dynamic> data) {
    return AddProduct(
        name: data['name'], price: data['price'], quantity: data['quantity']);
  }
}
