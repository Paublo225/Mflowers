import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowers0/cart/cartItem.dart';
import 'package:flowers0/cart/confirmation.dart';
import 'package:flowers0/model/cartEmpty.dart';
import 'package:flowers0/model/cartItem.dart';
import 'package:flowers0/model/product.dart';
import 'package:flowers0/main.dart';
import 'package:flowers0/model_screen/new_item_screen.dart';
import 'package:flowers0/sevices/category.dart';
import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flowers0/sevices/order.dart';
import 'package:flowers0/sevices/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CartPage extends StatefulWidget {
  CartPageState createState() => new CartPageState();
}

class CartPageState extends State<CartPage>
    with AutomaticKeepAliveClientMixin<CartPage> {
  final List<ProductModel> _products = [];
  //CategoryServices _categoryServices = CategoryServices();
  ProductServices _productServices = ProductServices();
  fetchProductsbyID() {
    _productServices.getProductsbyID().then((value) {
      setState(() {
        _products.addAll(value);
      });
      print("object");
      print(value);
    });
  }

  FirebaseServices _firebaseServices = FirebaseServices();
  CategoryServices categoryServices;
  ProductServices productServices;
  User user = FirebaseAuth.instance.currentUser;
  final TextStyle topMenuStyle = new TextStyle(
      fontFamily: 'Avenir next',
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.w600);
  final TextStyle buttonInfoStyle = new TextStyle(
      fontFamily: 'Avenir next',
      fontSize: 10,
      color: Colors.black,
      fontWeight: FontWeight.w600);
  FlowerItemZ flowerItem;
  PageController _pageController;

  List<int> _summavsego = [];
  int _summary = 0;
  int _total = 0;
  Future doc(int list) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("cart").get();
    list = querySnapshot.docs.length;

    return list;
  }

  String uid;
  void initState() {
    fetchProductsbyID();
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  OrderServices _orderServices = OrderServices();

  List<FlowerItemZ> convertedCart = [];
  List<CartItemModel> cartItemModel = [];
  List<CartEmptyModel> cartEmptyModel = [];
  List<String> idsproducts = [];
  List<int> quantities = [];
  List<int> kolvos = [];

  _onSubmit(
    String id,
    int total,
    String userId,
    List<FlowerItemZ> cartList,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Center(child: Text('Подтвердите заказ')),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Вы уверены?",
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          // margin: EdgeInsets.only(right: 10),
                          //alignment: Alignment.topLeft,
                          //padding: EdgeInsets.only(right: 50),
                          //height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: RaisedButton(
                              color: Colors.black,
                              child: Text(
                                'Да',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DefaultTabBar()));
                                //window OK
                                showCupertinoModalPopup(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return _popUp();
                                    });
                                //CREATING ORDER
                                _orderServices.createOrder(
                                    userId: userId,
                                    id: id,
                                    totalPrice: total,
                                    status: "В процессе",
                                    cart: convertedCart);

                                //CLEARING CART

                                convertedCart.clear();
                                _firebaseServices.usersRef
                                    .doc(_firebaseServices.getUserId())
                                    .collection("cart")
                                    .get()
                                    .then((value) {
                                  for (DocumentSnapshot sn in value.docs) {
                                    sn.reference.delete();
                                  }
                                });
                              }),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Container(
                            // alignment: Alignment.centerRight,
                            //  margin: EdgeInsets.only(right: 10),
                            //height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: RaisedButton(
                                child: Text('Отмена'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })),
                        SizedBox(
                          width: 15,
                        ),
                      ])
                ],
              )
            ]);
      },
    );
  }

  _popUp() {
    return Scaffold(
        body: FutureBuilder<QuerySnapshot>(
            future: Future.delayed(
              Duration(milliseconds: 700),
              () => FirebaseFirestore.instance
                  .collection('orders')
                  .where("userId", isEqualTo: _firebaseServices.getUserId())
                  .orderBy("createdAt")
                  .get(),
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              // Collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                    child: Stack(
                        children: snapshot.data.docs.map((document) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green,
                            size: 35,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(
                              "Заказ №${snapshot.data.docs[snapshot.data.size - 1]["id"]} оформлен!",
                              style: TextStyle(fontSize: 20)),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                  color: Colors.black,
                                  child: Text(
                                    'ОК',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return DefaultTabBar();
                                        });
                                  }),
                              SizedBox(
                                width: 10,
                              ),
                              RaisedButton(
                                  color: Colors.white,
                                  child: Text(
                                    'Оплатить',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                DefaultTabBar(),
                                            fullscreenDialog: true));
                                  }),
                            ])
                      ]);
                }).toList()));
              }

              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.pink[100]),
                  ),
                ),
              );
            }));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //final userpr = Provider.of<UserProvider>(context);
    convertedCart = [];
    cartItemModel = [];
    cartEmptyModel = [];
    idsproducts = [];
    quantities = [];
    kolvos = [];
    _total = 0;
    return new Scaffold(
        bottomNavigationBar: _bottomInfo(cartItemModel),
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Row(children: [
              Text(
                "Корзина",
                style: TextStyle(
                    //  fontFamily: 'Avenir next',
                    fontSize: 26,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              )
            ])),
        body: Column(children: [
          //print(_products[i]);
          CartPageItem()
        ]));
  }

  String _mailOrder(
      String nordder, List<FlowerItemZ> items, String email, int itog) {
    var message =
        '<center><img src="https://firebasestorage.googleapis.com/v0/b/flowers-64dcc.appspot.com/o/logo_flowers.png?alt=media&token=e176c590-280c-4a15-bed9-9185451683e0"></center></br><h3>Заказ оформлен</h3><p>Ваш заказ оформлен и ожидает оплаты.</p><p>Если у вас возникнут вопросы, вы можете связаться с нами по телефону +7 499 677 5877 с 11:00 до 21:00 или ответить на это сообщение.</p><center><h2>Заказ №$nordder</h2></center></br><table><table border="1" width="100%" cellpadding="5"><tr><th>Товар</th><th>Цена</th><th>Кол-во</th><th>Сумма</th></tr>';
    var row = '';
    for (int i = 0; i < items.length; i++) {
      row +=
          '<tr><td>${items[i].title}</td><td>${items[i].price}, руб.</td><td>${items[i].quantity} шт.</td><td>${items[i].price}, руб.</td></tr>';
    }
    var itogo =
        '<tr><td colspan="3" style="text-align:left"><b>ИТОГО:</b></td><td><b>$itog, руб.</b></td></tr></table>';
    var info = '<h3>Ваши данные</h3><p><b>Почта:</b> $email</p>';
    print("mail send");
    return message + row + itogo + info;
  }

  Widget _bottomInfo(List<CartItemModel> cart) {
    // print(_cartState);

    return StreamBuilder(
        stream: _firebaseServices.usersRef
            .doc(_firebaseServices.getUserId())
            .collection('cart')
            .snapshots(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("data");
          }
          if (snapshot.hasError) {
            return Text("data");
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return Text("data");
          }

          if (snapshot.data.docs.isEmpty) return Text("");

          if (snapshot.hasData) {
            _summary = 0;
            QuerySnapshot qqq = snapshot.data;

            qqq.docs.forEach((doc) {
              _summary += doc.get("summa");
            });
            _total = _summary;
            return BottomAppBar(
                child: Container(
              height: MediaQuery.of(context).size.height / 5.5,
              width: double.infinity,
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "  ИТОГ:",
                              style: TextStyle(fontSize: 22),
                            ),
                            Text(
                              "$_summary руб  ",
                              style: TextStyle(fontSize: 22),
                            ),
                          ])),
                  new Container(
                      margin: EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 50,
                      child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                          ),
                          disabledColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          color: Colors.black,
                          onPressed: () async {
                            print("object: ${idsproducts}");
                            showCupertinoModalPopup(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return ConfirmOrderPage(
                                    idz: idsproducts,
                                    quantities: quantities,
                                    kolvos: kolvos,
                                    summary: _summary,
                                    cartItem: cartItemModel,
                                    emptyCartItem: cartEmptyModel,
                                  );
                                });
                          },
                          child: Text("Оформить заказ",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white)))),
                ],
              ),
            ));
          }
        });
  }

  _emptycart() {
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: 1),
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.width * 0.9,
          /*decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(width: 2.0, color: Colors.grey[600]),
                  top: BorderSide(width: 2.0, color: Colors.grey[600]),
                  left: BorderSide(width: 2.0, color: Colors.grey[600]),
                  right: BorderSide(width: 2.0, color: Colors.grey[600]),
                ),
              ),*/
          //  child: Container(
          alignment: Alignment.center,
          child: Column(children: [
            Container(
              child: Image(
                image: AssetImage("lib/assets/boxx.png"),
                height: MediaQuery.of(context).size.height / 7,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(
                  "Здесь пустовато...",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.grey[600],
                  ),
                )),
            Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  "Корзина пуста. Перейдите в меню и выберете понравившийся товар",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ))
          ])),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
