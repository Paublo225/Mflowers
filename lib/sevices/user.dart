import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowers0/model/cartItem.dart';
import 'package:flowers0/model/user.dart';
import 'package:flowers0/userpage/notification_page.dart';

import 'firebase_services.dart';

class UserServices {
  String collection = "users";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserInfo inf;

  void createUser(Map<String, dynamic> values) {
    String id = values["id"];
    _firestore.collection(collection).doc(id).set(values);
  }

  void updateUserData(Map<String, dynamic> values) {
    _firestore.collection(collection).doc(values['id']).update(values);
  }

  Future<List<NotificationModel>> getGlobalNotifications() async => _firestore
          .collection("notifications")
          //.orderBy("dataCreated", descending: true)
          .get()
          .then((result) {
        List<NotificationModel> notifications = [];
        for (DocumentSnapshot notification in result.docs) {
          notifications.add(NotificationModel.fromSnapshot(notification));
        }
        return notifications;
      });

  FirebaseServices _firebaseServices = FirebaseServices();

  getCartFullLength() async {
    return await _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("cart")
        .get()
        .then((value) => value.size);
  }

  getCartTotalSum() async {
    int totalSumma = 0;
    await _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("cart")
        .get()
        .then((value) {
      value.docs.toList().forEach((a) {
        totalSumma += a.data()["summa"];
      });
    });
    return totalSumma;
  }

  void removeFromCart({String userId, String cartItem}) {
    print("THE USER ID IS: $userId");
    print("cart items are: ${cartItem.toString()}");
    _firestore
        .collection(collection)
        .doc(userId)
        .collection("cart")
        .doc(cartItem);
  }
}
