import 'package:cloud_firestore/cloud_firestore.dart';
import 'cartItem.dart';

class UserModel {
  static const ID = "uid";
  static const NAME = "name";
  static const EMAIL = "email";
  static const CART = "cart";

  String _name;
  String _email;
  String _id;

  int _priceSum = 0;

//  getters
  String get name => _name;

  String get email => _email;

  String get id => _id;

  // public variables
  List<CartItemModel> cart;
  int totalCartPrice;

  nameprint(String name) {
    print(name);
  }

  int getTotalPrice({List cart}) {
    if (cart == null) {
      return 0;
    }
    for (Map cartItem in cart) {
      _priceSum += cartItem["price"] * cartItem["quantity"];
    }

    int total = _priceSum;

    print("THE TOTAL IS $total");

    return total;
  }
}
