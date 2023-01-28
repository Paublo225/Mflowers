import 'package:flowers0/model_screen/item_info.dart';
import 'package:flowers0/sevices/firebase_services.dart';

import '../model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductServices {
  String collection = "products";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseServices _firebaseServices = FirebaseServices();

  Stream<List<ProductModel>> getProducts() {
    List<ProductModel> products = [];
    _firestore
        .collection(collection)
        .snapshots()
        .map((snap) => snap.docs.map((e) {
              List<ProductModel> products = [];
              products.add(ProductModel.fromSnapshot(e));
              return products;
            }));
  }

  Stream<int> getCartItems() {
    int _count = 0;
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("cart")
        .snapshots()
        .map((event) => _count += event.docs.length);
  }

  Future<List<ProductModel>> getProductsOfCategory(String category) async =>
      _firestore
          .collection(collection)
          .orderBy("сорт_позиция")
          .where("category", isEqualTo: category)
          .get()
          .then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });
  /*  _firestore
          .collection(collection)
          .where("category", isEqualTo: category)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                var data = doc.data();
                return ProductModel.fromMap(data);
              }).toList());*/

  Future<bool> isAddedCart(String idProduct) => _firebaseServices.usersRef
          .doc(_firebaseServices.getUserId())
          .collection("cart")
          .get()
          .then((value) {
        bool isAdded;
        for (DocumentSnapshot cartItem in value.docs) {
          if (cartItem.id == idProduct) {
            isAdded = true;
            break;
          } else
            isAdded = false;
        }
        return isAdded;
      });

  Future<int> quantityCart(String idProduct) async =>
      await _firebaseServices.usersRef
          .doc(_firebaseServices.getUserId())
          .collection("cart")
          .get()
          .then((value) {
        int quantity;
        for (DocumentSnapshot cartItem in value.docs) {
          if (cartItem.id == idProduct) {
            quantity = cartItem.data()["kolvo"];
            break;
          }
        }
        return quantity;
      });

  Future<List<ProductModel>> getOrderProducts(String productId) async =>
      _firestore
          .collection(collection)
          .where("productId", isEqualTo: productId)
          .get()
          .then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });

  Future<List<ProductModel>> getProductsbyID() async =>
      _firebaseServices.usersRef
          .doc(_firebaseServices.getUserId())
          .collection("cart")
          .get()
          .then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }
        return products;
      });

  Future<List<ProductModel>> getProductsbyIDs() async =>
      _firebaseServices.usersRef
          .doc(_firebaseServices.getUserId())
          .collection("cart")
          .get()
          // ignore: missing_return
          .then((value) {
        for (DocumentSnapshot d in value.docs) {
          _firebaseServices.productsRef
              .where("id", isEqualTo: d.id)
              .get()
              .then((snap) {
            List<ProductModel> products = [];
            for (DocumentSnapshot product in snap.docs) {
              products.add(ProductModel.fromSnapshot(product));
            }
            return products;
          });
        }
      });

  Future<List<ProductModel>> searchProducts({String productName}) {
    String searchKey = productName[0].toUpperCase() + productName.substring(1);
    return _firestore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .get()
        .then((result) {
          List<ProductModel> products = [];
          for (DocumentSnapshot product in result.docs) {
            products.add(ProductModel.fromSnapshot(product));
          }
          return products;
        });
  }
}
