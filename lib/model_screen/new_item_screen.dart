import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_image/firebase_image.dart';
import 'package:flowers0/model/category.dart';
import 'package:flowers0/model/product.dart';
import 'package:flowers0/sevices/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'item_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:octo_image/octo_image.dart';

final TextStyle topMenuStyle = new TextStyle(
    fontFamily: 'Avenir next',
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.w600);

// ignore: must_be_immutable
class FlowerItemZ extends StatefulWidget {
  String id;
  String imageUrl;
  String title;
  CategoryModel categories;
  int price;
  String description;
  String quantity;
  String category;
  String opt;
  int qpak;
  int minKolvo;
  String length;
  String producer;
  String sort;
  String deliveryDate;
  PageController page;
  ProductModel product;
  FlowerItemZ({
    this.id,
    this.imageUrl,
    this.title,
    this.categories,
    this.price,
    this.opt,
    this.category,
    this.description,
    this.product,
    this.quantity,
    this.minKolvo,
    this.qpak,
    this.length,
    this.producer,
    this.sort,
    this.deliveryDate,
    this.page,
  });

  Map toMap() => {
        "id": id,
        "imageUrl": imageUrl,
        "name": title,
        "price": price,
        "опт": opt,
        "qpak": qpak,
        "мин_кол-во": minKolvo,
        "quantity": quantity,
      };
  _FlowerItemState createState() => new _FlowerItemState();
}

class _FlowerItemState extends State<FlowerItemZ> {
  final List<ProductModel> _products = [];
  Duration animationDuration = Duration(milliseconds: 500);
  //CategoryServices _categoryServices = CategoryServices();
  ProductServices _productServices = ProductServices();
  var _isLoading = true, _isInit = false;
  fetchProducts(String category) {
    Future.delayed(Duration(milliseconds: 200), () {
      _productServices.getProductsOfCategory(category).then((value) {
        setState(() {
          _isLoading = false;
          _products.addAll(value);
        });
      });
    });
  }

  @override
  void initState() {
    if (!_isInit) {
      fetchProducts(widget.category);
    }
    _isInit = true;
    super.initState();
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _tapped = false;
  Future getDocs() async {
    Future<DocumentSnapshot> querySnapshot =
        _firestore.collection("products").doc("title").get();
    print(querySnapshot);
  }

  FlowerItemZ flowerItem;

  ///// ADD TO CART SECTION ///////
  /*
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("users");
  User _user = FirebaseAuth.instance.currentUser;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  void _doSomething() async {
    await _addToCart(widget.title, widget.id, widget.price, widget.qpak);
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        icon: null,
        message: "+${widget.qpak} ${widget.title} добавлен в корзину",
      ),
      displayDuration: Duration(milliseconds: 1500),
    );
    _btnController.success();

    print("clickedz");
  }

  Future _addToCart(String title, String id, String price, int qpak) {
    int summa = int.parse(price) * qpak;
    print("$title, $id, $price, $qpak, $summa");
    return _usersRef.doc(_user.uid).collection("cart").doc(widget.id).set({
      "name": title,
      "cartid": id,
      "kolvo": qpak,
      "summa": summa,
    });
  }*/
  /////////////////////////////////////////////////
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    //  _products.map((e) => print(e.id));
    var textWidth = MediaQuery.of(context).size.width;

    return widget.category != null
        ? Column(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.category,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            if (_isLoading)
              SkeletonLoader(
                builder: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1.0, 3.0),
                              blurRadius: 3.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: SizedBox(
                          height: 150,
                          width: 160,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              width: double.infinity,
                              height: 8,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              height: 10,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              height: 12,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                items: 5,
                period: Duration(seconds: 2),
                highlightColor: Colors.pink[200],
                direction: SkeletonDirection.ltr,
              )
            else
              for (ProductModel product in _products)
                int.parse(product.quantity) <= int.parse("0")
                    ? SizedBox()
                    : AnimatedBuilder(
                        animation: widget.page,
                        builder: (BuildContext context, Widget widget) {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 30),
                                  alignment: Alignment.topLeft,
                                  child: SizedBox(
                                    height: 150,
                                    width: Curves.easeInOut.transform(1) *
                                        MediaQuery.of(context).size.width,
                                    child: widget,
                                  ),
                                )
                              ]);
                        },
                        child: GestureDetector(
                          onTap: () => showBarModalBottomSheet(
                            expand: true,
                            context: context,
                            builder: (context) => FlowerScreen(
                              product: product,
                            ),
                          ).then((value) => setState(() {})),
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(1.0, 3.0),
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(1),
                                    child: Hero(
                                      tag: "${product.imageUrl}",
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: OctoImage(
                                          alignment: Alignment.centerLeft,
                                          fit: BoxFit.fill,
                                          height: 150,
                                          width: 140,
                                          //alignment: Alignment.centerLeft,
                                          placeholderBuilder: (context) {
                                            return Image.asset(
                                                'lib/assets/loading_img.jpg');
                                          },
                                          errorBuilder: (context, obj, stack) {
                                            return Container(
                                                margin: EdgeInsets.all(20),
                                                child: Image.asset(
                                                    "lib/assets/error_img.jpg"));
                                          },

                                          image: FirebaseImage(
                                            product.imageUrl,
                                          ),
                                          //  fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.directional(
                                end: 165.0,
                                top: 20.0,
                                textDirection: TextDirection.rtl,
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    width: textWidth / 2.2,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name.toUpperCase(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              //   color: Colors.white,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            product.producer,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 10.0,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ])),
                              ),
                              Positioned.directional(
                                textDirection: TextDirection.rtl,
                                end: 165.0,
                                bottom: 55.0,
                                child: Container(
                                  width: 250.0,
                                  child: Text(
                                    int.parse(product.quantity) <=
                                            int.parse("0")
                                        ? "Нет в наличии"
                                        : "Доступно: ${product.quantity} штук",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.directional(
                                textDirection: TextDirection.rtl,
                                end: 165.0,
                                bottom: 25.0,
                                child: Container(
                                  width: 250.0,
                                  child: Text(
                                    "${product.price} ₽/шт",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
          ])
        : _isLoading
            ? SkeletonLoader(
                builder: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 30),
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1.0, 3.0),
                              blurRadius: 3.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: SizedBox(
                          height: 130,
                          width: 160,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              width: double.infinity,
                              height: 8,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              height: 10,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              height: 12,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                items: 1,
                period: Duration(seconds: 2),
                highlightColor: Colors.pink[200],
                direction: SkeletonDirection.ltr,
              )
            : AnimatedBuilder(
                animation: widget.page,
                builder: (BuildContext context, Widget widget) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 30),
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            height: 150,
                            width: Curves.easeInOut.transform(1) *
                                MediaQuery.of(context).size.width,
                            child: widget,
                          ),
                        )
                      ]);
                },
                child: GestureDetector(
                  onTap: () => showBarModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    duration: animationDuration,
                    builder: (context) => FlowerScreen(
                      id: widget.id,
                      name: widget.title,
                      imageUrl: widget.imageUrl,
                      price: widget.price,
                      description: widget.description,
                      qpak: widget.qpak,
                      opt: widget.opt,
                      length: widget.length,
                      sort: widget.sort,
                      producer: widget.producer,
                      deliveryDate: widget.deliveryDate,
                      // category: document.data()['category'],
                      quantity: widget.quantity,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(1.0, 3.0),
                                blurRadius: 3.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(1),
                            child: Hero(
                              tag: "${widget.imageUrl}",
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: OctoImage(
                                  placeholderFadeInDuration:
                                      Duration(milliseconds: 100),
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.fill,
                                  height: 150,
                                  width: 140,
                                  //alignment: Alignment.centerLeft,
                                  placeholderBuilder: (context) {
                                    return Image.asset(
                                        'lib/assets/loading_img.jpg');
                                  },
                                  errorBuilder: (context, obj, stack) {
                                    return Container(
                                        margin: EdgeInsets.all(20),
                                        child: Image.asset(
                                            "lib/assets/error_img.jpg"));
                                  },

                                  image: FirebaseImage(
                                    widget.imageUrl,
                                  ),
                                  //  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.directional(
                        end: 165.0,
                        top: 20.0,
                        textDirection: TextDirection.rtl,
                        child: Container(
                          alignment: Alignment.topLeft,
                          width: textWidth / 2.2,
                          child: Text(
                            widget.title.toUpperCase(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              //   color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned.directional(
                        textDirection: TextDirection.rtl,
                        end: 165.0,
                        bottom: 55.0,
                        child: Container(
                          width: 250.0,
                          child: Text(
                            int.parse(widget.quantity) <= int.parse("0")
                                ? "Нет в наличии"
                                : "Доступно: ${widget.quantity} штук",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ),
                      Positioned.directional(
                        textDirection: TextDirection.rtl,
                        end: 165.0,
                        bottom: 25.0,
                        child: Container(
                          width: 250.0,
                          child: Text(
                            "${widget.price} ₽/шт",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              /* shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black38,
                          offset: Offset(3.0, 3.0),
                        ),
                      ]*/
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }
}
