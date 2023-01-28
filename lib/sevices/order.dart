import 'package:flowers0/cart/cart.dart';
import 'package:flowers0/model_screen/item_info.dart';
import 'package:flowers0/model_screen/new_item_screen.dart';

import '../model/order.dart';
import '../model/cartItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderServices {
  String collection = "orders";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createOrder(
      {String userId,
      String id,
      String description,
      String status,
      List<FlowerItemZ> cart,
      List<CartItemModel> cartItems,
      String payMeth,
      int totalPrice}) {
    List<Map> convertedCart = [];
    var uid = id.toUpperCase().substring(0, 7);

    var _minute;
    var _data;
    var _month;
    var _hour;
////Date
    if (DateTime.now().day < 10)
      _data = "0${DateTime.now().day}";
    else
      _data = DateTime.now().day.toString();

    ///Minute
    if (DateTime.now().minute < 10)
      _minute = "0${DateTime.now().minute}";
    else
      _minute = DateTime.now().minute.toString();

    ///Hour
    if (DateTime.now().hour < 10)
      _hour = "0${DateTime.now().hour}";
    else
      _hour = DateTime.now().hour.toString();
/////Month
    if (DateTime.now().month < 10)
      _month = "0${DateTime.now().month}";
    else
      _month = DateTime.now().month.toString();

    for (CartItemModel item in cartItems) {
      convertedCart.add(item.toMap());
    }
    _firestore.collection(collection).doc(uid).set({
      "userId": userId,
      "id": uid,
      "заказ": convertedCart,
      "total": totalPrice,
      "time": "$_hour:$_minute",
      "createdAt": DateTime.utc(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateTime.now().hour - 3,
          DateTime.now().minute,
          DateTime.now().second),
      "date": "$_data/$_month/${DateTime.now().year.toString()}",
      "description": description,
      "status": status,
      "paymentMethod": payMeth
    });
  }

  Future<List<OrderModel>> getUserOrders({String userId}) async => _firestore
          .collection(collection)
          .where("userId", isEqualTo: userId)
          .get()
          .then((result) {
        List<OrderModel> orders = [];
        for (DocumentSnapshot order in result.docs) {
          orders.add(OrderModel.fromSnapshot(order));
        }
        return orders;
      });
}
