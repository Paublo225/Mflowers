import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';

import 'package:flowers0/cart/confirmation.dart';
import 'package:flowers0/model/cartEmpty.dart';
import 'package:flowers0/model/cartItem.dart';
import 'package:flowers0/model/product.dart';
import 'package:flowers0/model_screen/item_screen.dart';
import 'package:flowers0/model_screen/new_item_screen.dart';
import 'package:flowers0/provider/connection_provider.dart';
import 'package:flowers0/provider/user_pr.dart';
import 'package:flowers0/sevices/category.dart';
import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flowers0/sevices/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:flowers0/helpers/styles.dart';

// ignore: must_be_immutable
class Cart extends StatefulWidget with ChangeNotifier {
  static const ID = "cartid";
  static const NAME = "name";

  static const PRICE = "summa";
  static const QUANTITY = "kolvo";
  static const SUMMARY = "summary";

  List<FlowerItemZ> flowerItem = [];
  List summ = [];

  double get total {
    return flowerItem.fold(0.0, (double currentTotal, FlowerItemZ nextFlower) {
      return currentTotal + nextFlower.price;
    });
  }

  void totalSum() async {
    var qqq = FirebaseFirestore.instance.collection("cart").snapshots();
    qqq.forEach((element) {
      summ.add(element.docs[0]);
    });
    print(summ);
  }

  void addToCart(FlowerItemZ flowerItemZ) => flowerItem.add(flowerItemZ);
  void removeFromCart(FlowerItemZ flowerItemZ) {
    flowerItem.remove(flowerItemZ);
    notifyListeners();
  }

  String id;
  String name;
  String image;
  String productId;
  int price;
  int quantity;
  int summary;

  Cart(
      {Key key,
      this.id,
      this.name,
      this.image,
      this.price,
      this.productId,
      this.quantity,
      this.summary});

  Map toMap() => {
        ID: id,
        NAME: name,
        PRICE: price,
        QUANTITY: quantity,
      };

  CartPageState createState() => new CartPageState();
}

class CartPageState extends State<Cart>
    with AutomaticKeepAliveClientMixin<Cart> {
  final List<ProductModel> _products = [];

  //CategoryServices _categoryServices = CategoryServices();
  ProductServices _productServices = ProductServices();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int _summaryZ = 0;
  fetchProductsbyID() {
    _productServices.getProductsbyID().then((value) {
      setState(() {
        _products.addAll(value);
      });
    });
  }

  bool _canVibrate = true;
  Future<void> _initVibration() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
      _canVibrate
          ? debugPrint('This device can vibrate')
          : debugPrint('This device cannot vibrate');
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
    super.initState();
    fetchProductsbyID();
    _initVibration();

    // _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  List<FlowerItemZ> convertedCart = [];
  List<CartItemModel> cartItemModel = [];
  List<CartEmptyModel> cartEmptyModel = [];
  List<String> idsproducts = [];
  List<int> quantities = [];
  List<int> kolvos = [];

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    Provider.of<ConnectivityProvider>(context, listen: false).dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    final userpr = Provider.of<UserProvider>(context);
    convertedCart = [];
    cartItemModel = [];
    cartEmptyModel = [];
    idsproducts = [];
    quantities = [];
    kolvos = [];
    _total = 0;
    return Consumer<ConnectivityProvider>(builder: (context, model, child) {
      if (model.isOnline != null) {
        return model.isOnline
            ? new Scaffold(
                // key: globalKeyCart,
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
                body: Stack(children: [
                  FutureBuilder<QuerySnapshot>(
                    future: _firebaseServices.usersRef
                        .doc(_firebaseServices.getUserId())
                        .collection("cart")
                        .get(GetOptions(source: Source.cache)),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Scaffold(
                          body: Center(
                            child: Text("Error: ${snapshot.error}"),
                          ),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data.docs.isEmpty) {
                          return _emptycart();
                        }
                        if (snapshot.hasData) {
                          return SmartRefresher(
                              header: ClassicHeader(
                                refreshingText: "Обновляется",
                                releaseText: "Обновляется",
                                idleText: "Потяните вниз",
                              ),
                              onRefresh: () async {
                                if (_canVibrate) {
                                  Vibrate.feedback(FeedbackType.heavy);
                                }

                                try {
                                  await Future.delayed(
                                      Duration(milliseconds: 600));
                                  _refreshController.refreshCompleted();
                                } catch (e) {
                                  _refreshController.refreshFailed();
                                }
                                // userpr.changeLoading();
                              },
                              controller: _refreshController,
                              child: ListView(children: <Widget>[
                                // _topInfo(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: snapshot.data.docs.map((document) {
                                    return FutureBuilder(
                                        future: _firebaseServices.productsRef
                                            .doc(document.id)
                                            .get(),
                                        builder: (context, productSnap) {
                                          if (productSnap.connectionState ==
                                              ConnectionState.done) {
                                            Map _productMap =
                                                productSnap.data.data();

                                            if (int.parse(
                                                    _productMap["quantity"]) >=
                                                document["kolvo"]) {
                                              cartItemModel.add(CartItemModel(
                                                id: document.id,
                                                imageUrl:
                                                    _productMap["imageUrl"],
                                                name: _productMap["name"],
                                                price: document["summa"]
                                                    .toString(),
                                                quantity: document["kolvo"]
                                                    .toString(),
                                                fullQuantity:
                                                    _productMap["quantity"],
                                                dateDelivery: _productMap[
                                                    "дата_поставки"],
                                              ));
                                              idsproducts.add(document.id);
                                              quantities.add(int.parse(
                                                  _productMap["quantity"]));
                                              kolvos.add(document["kolvo"]);
                                            }
                                            if (int.parse(
                                                    _productMap["quantity"]) <
                                                document["kolvo"]) {
                                              cartEmptyModel.add(CartEmptyModel(
                                                id: document.id,
                                                imageUrl:
                                                    _productMap["imageUrl"],
                                                name: _productMap["name"],
                                                price: document["summa"]
                                                    .toString(),
                                                quantity: document["kolvo"]
                                                    .toString(),
                                              ));
                                            }
                                            convertedCart.add(FlowerItemZ(
                                              id: document.id,
                                              imageUrl: _productMap["imageUrl"],
                                              title: _productMap["name"],
                                              price: document["summa"],
                                              quantity:
                                                  document["kolvo"].toString(),
                                            ));

                                            if (cartEmptyModel.length > 0) {
                                              cartEmptyModel
                                                  .forEach((element) async {
                                                _total = await _summary -
                                                    int.parse(element.price);
                                              });
                                            }
                                            print("Total: $_total");
                                            return new GestureDetector(
                                                onTap: () {
                                                  /////////
                                                  showBarModalBottomSheet(
                                                      expand: true,
                                                      context: context,
                                                      builder: (context) =>
                                                          FlowerScreen(
                                                            id: document.id,
                                                            imageUrl:
                                                                _productMap[
                                                                    "imageUrl"],
                                                            name: _productMap[
                                                                "name"],
                                                            price: _productMap[
                                                                "price"],
                                                            quantity:
                                                                _productMap[
                                                                    "quantity"],
                                                            opt: _productMap[
                                                                "опт"],
                                                            qpak: _productMap[
                                                                "qpak"],
                                                            description:
                                                                _productMap[
                                                                    "description"],
                                                            producer: _productMap[
                                                                "производитель"],
                                                            length: _productMap[
                                                                "длина"],
                                                            sort: _productMap[
                                                                "сорт"],
                                                            deliveryDate:
                                                                _productMap[
                                                                    "дата_поставки"],
                                                          )).then((value) =>
                                                      setState(() {}));
                                                },
                                                child: Dismissible(
                                                  key: UniqueKey(),
                                                  direction: DismissDirection
                                                      .endToStart,
                                                  onDismissed: (direction) {
                                                    userpr.changeLoading();
                                                    print(document.id);
                                                    convertedCart.clear();
                                                    _summavsego.remove(
                                                        document["summa"]);
                                                    _summavsego = [];
                                                    _summary -=
                                                        document["summa"];
                                                    _firebaseServices.usersRef
                                                        .doc(_firebaseServices
                                                            .getUserId())
                                                        .collection("cart")
                                                        .doc(document.id)
                                                        .delete();
                                                    userpr.changeLoading();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: Container(
                                                      height: 100,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: Colors.white,
                                                        boxShadow: <BoxShadow>[
                                                          BoxShadow(
                                                            color:
                                                                Colors.black26,
                                                            offset: Offset(
                                                                1.0, 3.0),
                                                            blurRadius: 3.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: <Widget>[
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child: OctoImage(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              fit: BoxFit.fill,
                                                              height: 100,
                                                              width: 100,
                                                              //alignment: Alignment.centerLeft,
                                                              placeholderBuilder:
                                                                  (context) {
                                                                return Image.asset(
                                                                    'lib/assets/loading_img.jpg');
                                                              },
                                                              errorBuilder:
                                                                  (context, obj,
                                                                      stack) {
                                                                return Container(
                                                                    margin: EdgeInsets
                                                                        .all(
                                                                            20),
                                                                    child: Image
                                                                        .asset(
                                                                            "lib/assets/error_img.jpg"));
                                                              },

                                                              image: FirebaseImage(
                                                                  _productMap[
                                                                      "imageUrl"],
                                                                  shouldCache:
                                                                      false),
                                                              //  fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width -
                                                                        190,
                                                                    child:
                                                                        RichText(
                                                                      text: TextSpan(
                                                                          children: [
                                                                            TextSpan(
                                                                                text: _productMap["name"] + "\n",
                                                                                style: TextStyle(color: (int.parse(_productMap["quantity"]) >= document["kolvo"]) ? Colors.black : Colors.black38, fontSize: 16, fontWeight: FontWeight.bold)),
                                                                            TextSpan(
                                                                                text: "${document["summa"]} руб \n\n",
                                                                                style: TextStyle(color: (int.parse(_productMap["quantity"]) >= document["kolvo"]) ? Colors.black : Colors.grey, fontSize: 16, fontWeight: FontWeight.w300)),
                                                                            if (_productMap["дата_поставки"] != "" &&
                                                                                _productMap["дата_поставки"] != null)
                                                                              TextSpan(text: "Дата поставки: ${_productMap["дата_поставки"]} \n", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400)),
                                                                            TextSpan(
                                                                                text: (int.parse(_productMap["quantity"]) >= document["kolvo"]) ? "Кол-во: ${document["kolvo"]}" : "Нет в наличии",
                                                                                style: TextStyle(color: (int.parse(_productMap["quantity"]) >= document["kolvo"]) ? Colors.black : Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w400)),
                                                                          ]),
                                                                    )),
                                                                IconButton(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .delete_forever_outlined,
                                                                      color: Colors
                                                                              .pink[
                                                                          100],
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      userpr
                                                                          .changeLoading();
                                                                      print(document
                                                                          .id);
                                                                      convertedCart
                                                                          .clear();
                                                                      _summavsego
                                                                          .remove(
                                                                              document["summa"]);
                                                                      _summavsego =
                                                                          [];
                                                                      _summary -=
                                                                          document[
                                                                              "summa"];
                                                                      await _firebaseServices
                                                                          .usersRef
                                                                          .doc(_firebaseServices
                                                                              .getUserId())
                                                                          .collection(
                                                                              "cart")
                                                                          .doc(document
                                                                              .id)
                                                                          .delete();
                                                                      userpr
                                                                          .changeLoading();
                                                                    })
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ));
                                          }
                                          //  return Text("");
                                          return SkeletonLoader(
                                            period: Duration(seconds: 2),
                                            highlightColor: Colors.pink[200],
                                            direction: SkeletonDirection.ltr,
                                            builder: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Container(
                                                height: 100,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  //   color: Colors.white,
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      offset: Offset(1.0, 3.0),
                                                      blurRadius: 3.0,
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Container(
                                                        color: Colors.pink,
                                                        width: 100,
                                                        height: 100,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                190,
                                                          ),
                                                          IconButton(
                                                              icon: Icon(
                                                                Icons
                                                                    .delete_forever_outlined,
                                                                color: Colors
                                                                    .pink[100],
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                userpr
                                                                    .changeLoading();
                                                                print(document
                                                                    .id);
                                                                convertedCart
                                                                    .clear();
                                                                _summavsego.remove(
                                                                    document[
                                                                        "summa"]);
                                                                _summavsego =
                                                                    [];
                                                                _summary -=
                                                                    document[
                                                                        "summa"];
                                                                await _firebaseServices
                                                                    .usersRef
                                                                    .doc(_firebaseServices
                                                                        .getUserId())
                                                                    .collection(
                                                                        "cart")
                                                                    .doc(
                                                                        document
                                                                            .id)
                                                                    .delete();
                                                                userpr
                                                                    .changeLoading();
                                                              })
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  }).toList(),
                                ),
                              ]));
                        }
                      }
                      return Scaffold(
                        body: Center(
                            child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.pink[100]),
                        )),
                      );
                    },
                  ),
                ]))
            : _nointernet();
      }
      return Scaffold(
        body: Center(
            child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink[100]),
        )),
      );
    });
  }

  _nointernet() {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("lib/assets/internet_check.png"))),
          ),
          Text(
            "Какие-то проблемы с соединением.\nПопробуйте обновить или подключиться к сети.",
            textAlign: TextAlign.center,
            style: textStyle,
          ),
          GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.only(top: 45),
              width: 90,
              height: 40,
              child: Center(
                child: Text(
                  "Обновить",
                  style: textStyleBtn,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black54)),
            ),
          )
        ],
      ),
    ));
  }

  Widget _bottomInfo(List<CartItemModel> cart) {
    // print(_cartState);
    final userpr = Provider.of<UserProvider>(context);
    int totalSumma;
    double heightAppBar = 130;
    return FutureBuilder(
        initialData: totalSumma,
        future: userpr.cartTotal(),
        // ignore: missing_return
        builder: (context, snapshot) {
          totalSumma = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting)
            return BottomAppBar(
                child: Container(
              height: heightAppBar,
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
                              "  СУММА:",
                              style: TextStyle(fontSize: 22),
                            ),
                            Text(
                              "$totalSumma руб  ",
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
                            if (cartItemModel.isNotEmpty) {
                              print("object: $idsproducts");
                              await showCupertinoModalPopup(
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
                                  }).then((value) => setState(() {
                                    cartItemModel.clear();
                                  }));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Center(
                                            child: Text('Оформление заказа')),
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "В вашей корзине нет доступных товаров.",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(),
                                              ),
                                            )
                                          ],
                                        ),
                                        actions: [
                                          Center(
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              //alignment: Alignment.topLeft,
                                              //padding: EdgeInsets.only(right: 50),
                                              //height: MediaQuery.of(context).size.height * 0.5,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              child: RaisedButton(
                                                  color: Colors.black,
                                                  child: Text(
                                                    'OK',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  }),
                                            ),
                                          )
                                        ]);
                                  });
                            }
                          },
                          child: Text("Перейти к оформлению",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white)))),
                ],
              ),
            ));
          return BottomAppBar(
              child: Container(
            height: heightAppBar,
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
                            "  СУММА:",
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(
                            snapshot.hasData
                                ? "${snapshot.data} руб  "
                                : totalSumma,
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
                          if (cartItemModel.isNotEmpty) {
                            print("object: $idsproducts");
                            await showCupertinoModalPopup(
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
                                }).then((value) => setState(() {}));
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: Center(
                                          child: Text('Оформление заказа')),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              "В вашей корзине нет доступных товаров.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(),
                                            ),
                                          )
                                        ],
                                      ),
                                      actions: [
                                        Center(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 10),
                                            //alignment: Alignment.topLeft,
                                            //padding: EdgeInsets.only(right: 50),
                                            //height: MediaQuery.of(context).size.height * 0.5,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            child: RaisedButton(
                                                color: Colors.black,
                                                child: Text(
                                                  'OK',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                }),
                                          ),
                                        )
                                      ]);
                                });
                          }
                        },
                        child: Text("Перейти к оформлению",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)))),
              ],
            ),
          ));
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
