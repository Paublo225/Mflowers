import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flowers0/model/product.dart';
import 'package:flowers0/provider/user_pr.dart';

import 'package:flowers0/sevices/product.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../helpers/count_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:expandable/expandable.dart';
import '../main.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

// ignore: must_be_immutable
class FlowerScreen extends StatefulWidget {
  ProductModel product;
  String name;
  String imageUrl;
  int qpak;
  String quantity;
  String description;
  int price;
  String opt;
  String id;
  String length;
  String producer;
  String sort;

  String deliveryDate;
  FlowerScreen(
      {this.product,
      this.id,
      this.name,
      this.imageUrl,
      this.qpak,
      this.quantity,
      this.description,
      this.price,
      this.producer,
      this.length,
      this.sort,
      this.opt,
      this.deliveryDate});

  @override
  _FlowerScreenState createState() => _FlowerScreenState();
}

class _FlowerScreenState extends State<FlowerScreen>
    with AutomaticKeepAliveClientMixin {
  int count = 0;

  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection("users");
  User _user = FirebaseAuth.instance.currentUser;
  ExpandableController excontroller;
  ProductServices _productServices = ProductServices();
  int kolvo = 0;
  bool _canVibrate = true;
  int summa = 1;

  Future<void> _initVibration() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _canVibrate = canVibrate;
      _canVibrate
          ? debugPrint('This device can vibrate')
          : debugPrint('This device cannot vibrate');
    });
  }

  TabController tabController;
  bool _tabHeight = true;
  bool _isInCartItem = false;
  String _btnTitle = "ДОБАВИТЬ В КОРЗИНУ";
  isInCart(String idishka) async {
    List<String> listOfId = [];

    await _usersRef.doc(_user.uid).collection("cart").get().then((v) {
      print(v.size);
      for (int i = 0; i < v.size; i++) {
        listOfId.add(v.docs[i].id);
      }
    });
    for (var i in listOfId) {
      if (idishka == i) {
        setState(() {
          _isInCartItem = true;
          _btnTitle = "ИЗМЕНИТЬ КОЛИЧЕСТВО";
        });
        break;
      } else {
        setState(() {
          _isInCartItem = false;
          _btnTitle = "ДОБАВИТЬ В КОРЗИНУ";
        });
      }
    }
  }

  Future _addToCart() async {
    if (widget.product != null)
      return _usersRef
          .doc(_user.uid)
          .collection("cart")
          .doc(widget.product.id)
          .set({
        "name": widget.product.name,
        "cartid": widget.product.id,
        "kolvo": kolvo == 0 ? widget.product.qpak : kolvo,
        "summa":
            summa == 1 ? widget.product.price * widget.product.qpak : summa,
      });
    else
      return _usersRef.doc(_user.uid).collection("cart").doc(widget.id).set({
        "name": widget.name,
        "cartid": widget.id,
        "kolvo": kolvo == 0 ? widget.qpak : kolvo,
        "summa": summa == 1 ? widget.price * widget.qpak : summa,
      });
  }

  void _successTop() async {
    // await _addToCart();
    if (widget.product != null) {
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          icon: null,
          message: "${widget.product.name} в корзине",
        ),
        displayDuration: Duration(milliseconds: 50),
        onTap: () {
          /* Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (context, animation1, animation2) => Cart(
                    // indexTab: 1,
                    )));*/
        },
      );
    } else
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          icon: null,
          message: "${widget.name} в корзине",
        ),
        displayDuration: Duration(milliseconds: 50),
        onTap: () {
          /* Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (context, animation1, animation2) => Cart(
                    // indexTab: 1,
                    )));*/
        },
      );
    //_btnController.success();
    //  print("clicked");
  }

  void _warningTop(String text) async {
    // await _addToCart();
    showTopSnackBar(
      context,
      CustomSnackBar.error(
        icon: null,
        message: text,
      ),
      displayDuration: Duration(milliseconds: 500),
      onTap: () {
        /* Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(seconds: 0),
                pageBuilder: (context, animation1, animation2) => Cart(
                    // indexTab: 1,
                    )));*/
      },
    );
    //_btnController.error();
    //  print("clicked");
  }

  _bottombtn(int size) {
    final userpr = Provider.of<UserProvider>(context);
    return new Container(
      height: 100,
      //  padding: EdgeInsets.only(bottom: 50),
      child: Center(
        child: new Container(
            width: MediaQuery.of(context).size.height * 0.4,
            height: 40,
            child: new RaisedButton(
                shape: new RoundedRectangleBorder(
                    //side: BorderSide(color: Colors.black38),
                    // borderRadius: new BorderRadius.circular(30.0)
                    ),
                disabledColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: Colors.white,
                onPressed: () async {
                  print(count);
                  print(kolvo);
                  print(summa);
                  print(quantity);
                  print(qpak);
                  print("$size, $qpakZ");

                  print(_price);
                  print("Проверка");

                  if (quantity != 0 && quantity > 1) {
                    if (quantity > 0 || widget.quantity != null) {
                      if (kolvo != 0 && kolvo <= quantity) {
                        await _addToCart();
                        userpr.changeLoading();
                        setState(() {
                          _btnTitle = "ИЗМЕНИТЬ КОЛИЧЕСТВО";
                          qpakZ = kolvo;
                        });
                        if (_canVibrate) {
                          Vibrate.feedback(FeedbackType.success);
                        }
                        _successTop();
                      } else {
                        print(count);
                        if (_canVibrate) {
                          Vibrate.feedback(FeedbackType.warning);
                        }
                        quantity > 0 && count != 0
                            ? _warningTop("Доступно только $quantity шт")
                            : _warningTop("Выберите количество");
                      }
                    } else {
                      print("qpak $qpak");
                      if (_canVibrate) {
                        Vibrate.feedback(FeedbackType.warning);
                      }
                      _warningTop("Нет в наличии");
                    }
                  } else {
                    print("qpak $qpak");
                    if (_canVibrate) {
                      Vibrate.feedback(FeedbackType.warning);
                    }
                    _warningTop("Нет в наличии");
                  }
                },
                child: new Text(_btnTitle,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontFamily: 'Avenir next')))),
      ),
    );
  }

  int _price = 2;
  int quantity = 1;
  Map<dynamic, dynamic> _opt = {"fa": 41};
  String _optString = "";
  int qpak = 0;
  String dateDelivery = "";

  int qpakZ;
  bool _isAddedtoCart = false;

  _isAdded() async {
    _isAddedtoCart = await _productServices
        .isAddedCart(widget.product != null ? widget.product.id : widget.id);
    if (_isAddedtoCart == null) _isAddedtoCart = false;

    // print(_isAddedtoCart);
  }

  _quantityStuff() async {
    qpakZ = await _productServices
        .quantityCart(widget.product != null ? widget.product.id : widget.id);
    // print(qpakZ);
  }

  @override
  void initState() {
    //  _initial();
    isInCart(widget.product != null ? widget.product.id : widget.id);
    super.initState();

    print("IS:  ${widget.product != null ? widget.product.id : widget.id}");

    _initVibration();
    excontroller = ExpandableController(initialExpanded: true);
    //  tabController = TabController(length: 2, vsync: this);
    _isAdded();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _isAdded();
    _quantityStuff();
    if (widget.product != null) {
      setState(() {
        count = widget.product.qpak;
        kolvo = qpakZ != null ? qpakZ : widget.product.qpak;
        summa = widget.product.price * kolvo;
        _price = widget.product.price;
        quantity = int.parse(widget.product.quantity);
        _optString = widget.product.opt;
        _opt = jsonDecode(_optString);
        qpak = widget.product.qpak;
        dateDelivery = widget.product.deliveryDate;
      });
    } else {
      setState(() {
        count = widget.qpak;
        kolvo = qpakZ != null ? qpakZ : widget.qpak;
        summa = widget.price * kolvo;
        _price = widget.price;
        quantity = int.parse(widget.quantity);
        _optString = widget.opt;
        _opt = jsonDecode(_optString);
        qpak = widget.qpak;
        dateDelivery = widget.deliveryDate;
      });
    }

    return Scaffold(
        backgroundColor: mainColor,
        /* appBar: AppBar(
          elevation: 0.0,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          leading: Align(
            alignment: Alignment.bottomCenter,
            child: RawMaterialButton(
              padding: EdgeInsets.all(8.0),
              elevation: 0.0,
              onPressed: () => Navigator.pop(context),
              shape: CircleBorder(),
              fillColor: Colors.white,
              child: Icon(
                CupertinoIcons.back,
                size: 22.0,
                color: mainColor,
              ),
            ),
          ),
        ),*/
        body: widget.product != null
            ? CustomScrollView(
                controller: ModalScrollController.of(context),
                slivers: [
                    SliverAppBar(
                        leading: GestureDetector(onTap: () {
                          Navigator.pop(context);
                        }),
                        collapsedHeight: 320,
                        flexibleSpace: Stack(
                          children: <Widget>[
                            Container(
                                color: Colors.white,
                                height: 320.0,
                                width: double.infinity,
                                child: Center(
                                    child: Hero(
                                        tag: "assetPath",
                                        child: Image(
                                            errorBuilder:
                                                (context, obj, stack) {
                                              return Image.asset(
                                                  "lib/assets/loading_img.jpg");
                                            },
                                            image: FirebaseImage(
                                                widget.product.imageUrl),
                                            height: 320.0,
                                            width: double.infinity,
                                            fit: BoxFit.fill)))),
                            Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  alignment: Alignment.topRight,
                                  height: 35,
                                  width: 35,
                                  child: RawMaterialButton(
                                    //padding: EdgeInsets.only(right: 10, top: 5),
                                    elevation: 1.0,
                                    onPressed: () => Navigator.pop(context),
                                    shape: CircleBorder(),
                                    fillColor: Colors.black38,
                                    child: Icon(
                                      Icons.close,
                                      size: 22.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ],
                        )),

                    /////Нижняя часть//////////////////////////////////
                    SliverPersistentHeader(
                        delegate: _SliverPersistentHeaderDelegate(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 10, top: 5),
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Stack(children: [
                                      Container(
                                          width: 200,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.product.name,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24.0,
                                                      shadows: [
                                                        Shadow(
                                                          blurRadius: 10.0,
                                                          color: Colors.black38,
                                                          offset:
                                                              Offset(3.0, 3.0),
                                                        ),
                                                      ]),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 3,
                                                    ),
                                                    child: Text(
                                                      // ignore: unrelated_type_equality_checks
                                                      quantity < 1
                                                          ? 'Нет в наличии'
                                                          : 'В наличии: $quantity штук',
                                                      style: TextStyle(
                                                        color: Colors.grey[50],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12.0,
                                                        /* shadows: [
                                              Shadow(
                                                blurRadius: 5.0,
                                                color: Colors.black38,
                                                offset: Offset(3.0, 3.0),
                                              ),
                                            ]*/
                                                      ),
                                                    )),
                                              ])),
                                      Container(
                                          alignment: Alignment.topRight,
                                          child: _priceText(_price)),
                                    ]),
                                  ),
                                ),
                                /* Container(
                        child: TabBar(
                          controller: tabController,
                          indicatorColor: Colors.white,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: [
                            Tab(
                              text: "Описание",
                            ),
                            Tab(
                              text: "Характеристики",
                            )
                          ],
                          onTap: (index) {
                            print(index);
                            if (index == 1) {
                              setState(() {
                                _tabHeight = !_tabHeight;
                              });
                            } else {
                              setState(() {
                                _tabHeight = false;
                              });
                            }
                            print(_tabHeight);
                          },
                        ),
                      ),*/
                                /*  AnimatedContainer(
                        margin: EdgeInsets.only(top: 5, left: 5),
                        height: _tabHeight ? 150 : 50,
                        width: MediaQuery.of(context).size.width,
                        duration: Duration(milliseconds: 200),
                        child: new TabBarView(
                            controller: tabController,
                            children: [
                              _description(
                                  _opt,
                                  _opt.values.toList(),
                                  _opt.keys.toList(),
                                  widget.product.description),
                              Text(
                                "- Объем: 250 мл\n- Цвет: Черный\n- В наличии 124 штук\n",
                                style: TextStyle(color: Colors.white),
                                softWrap: true,
                              )
                            ]),
                      ),*/
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          // height: 0,
                                          decoration: BoxDecoration(
                                              border: Border(
                                            bottom: BorderSide(
                                              //                   <--- left side
                                              color: Colors.white30,
                                              width: 0.5,
                                            ),
                                            top: BorderSide(
                                              //                   <--- left side
                                              color: Colors.white30,
                                              width: 0.5,
                                            ),
                                          )),
                                          margin: EdgeInsets.only(
                                              top: 20, left: 20, bottom: 5),
                                          //   child: Padding(
                                          // padding: EdgeInsets.only(top: 15),
                                          child: ExpandablePanel(
                                              collapsed: null,
                                              controller: excontroller,
                                              theme: ExpandableThemeData(
                                                  iconColor: Colors.white),
                                              header: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Text(
                                                    "Описание",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  )),
                                              expanded: _description(
                                                  _opt,
                                                  _opt.values.toList(),
                                                  _opt.keys.toList(),
                                                  widget.product.description,
                                                  dateDelivery))),

                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        //height: 100,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                // height: 0,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                  bottom: BorderSide(
                                                    //                   <--- left side
                                                    color: Colors.white30,
                                                    width: 0.5,
                                                  ),
                                                )),
                                                margin: EdgeInsets.only(
                                                    left: 20, bottom: 10),
                                                //   child: Padding(
                                                // padding: EdgeInsets.only(top: 15),
                                                child: ExpandablePanel(
                                                    theme: ExpandableThemeData(
                                                        iconColor:
                                                            Colors.white),
                                                    collapsed: null,
                                                    header: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5),
                                                        child: Text(
                                                          "Характеристики",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                    expanded: _characteristicks(
                                                        widget.product.producer,
                                                        widget.product.length,
                                                        widget.product.sort))),
                                            // )
                                          ],
                                        ),
                                      ),
                                      /////COUNT WIDGET////////
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, left: 30),
                                          child: CountWidget(
                                            quantity: quantity,
                                            count:
                                                quantity != 0 ? qpak : qpak = 0,
                                            minkolvo:
                                                quantity <= qpak && quantity > 0
                                                    ? quantity
                                                    : null,
                                            optKolvo: _opt.values.toList(),
                                            optPrices: _opt.keys.toList(),
                                            price: _price,
                                            opt: _opt,
                                            kolvo:
                                                qpakZ != null ? qpakZ : kolvo,
                                            onSelected: (size) {
                                              count = size;
                                              kolvo = count;
                                              summa = (_price * kolvo);
                                              print(" MAIN $_price");
                                            },
                                            onSelected1: (size) {
                                              count = size;
                                              kolvo = count;
                                              summa = _price * kolvo;

                                              print(" MAIN $_price");
                                            },
                                            onSelected2: (pr) {
                                              _price = pr;
                                              print("pr" +
                                                  _price.toString() +
                                                  " " +
                                                  pr.toString());
                                              summa = _price * kolvo;
                                            },
                                          )),
                                      _bottombtn(qpakZ != null ? qpakZ : qpak),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            height: MediaQuery.of(context).size.height))
                  ])
            : CustomScrollView(slivers: [
                SliverAppBar(
                    leading:
                        GestureDetector(onTap: () => Navigator.pop(context)),
                    collapsedHeight: 320,
                    flexibleSpace: Stack(
                      children: <Widget>[
                        Container(
                            color: Colors.white,
                            height: 320.0,
                            width: double.infinity,
                            child: Center(
                                child: Hero(
                                    tag: "assetPath",
                                    child: Image(
                                        errorBuilder: (context, obj, stack) {
                                          return Image.asset(
                                              "lib/assets/loading_img.jpg");
                                        },
                                        image: FirebaseImage(widget.imageUrl),
                                        height: 320.0,
                                        width: double.infinity,
                                        fit: BoxFit.fill)))),
                        Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              alignment: Alignment.topRight,
                              height: 35,
                              width: 35,
                              child: RawMaterialButton(
                                //padding: EdgeInsets.only(right: 10, top: 5),
                                elevation: 1.0,
                                onPressed: () => Navigator.pop(context),
                                shape: CircleBorder(),
                                fillColor: Colors.black38,
                                child: Icon(
                                  Icons.close,
                                  size: 22.0,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ],
                    )),

                /////Нижняя часть//////////////////////////////////
                SliverPersistentHeader(
                    //   pushPinnedChildren: true,
                    delegate: _SliverPersistentHeaderDelegate(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Stack(children: [
                                  Container(
                                      width: 200,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.name,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24.0,
                                                  shadows: [
                                                    Shadow(
                                                      blurRadius: 10.0,
                                                      color: Colors.black38,
                                                      offset: Offset(3.0, 3.0),
                                                    ),
                                                  ]),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                  left: 3,
                                                ),
                                                child: Text(
                                                  quantity <= 0
                                                      ? 'Нет в наличии'
                                                      : 'В наличии: $quantity штук',
                                                  style: TextStyle(
                                                    color: Colors.grey[50],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                    /* shadows: [
                                              Shadow(
                                                blurRadius: 5.0,
                                                color: Colors.black38,
                                                offset: Offset(3.0, 3.0),
                                              ),
                                            ]*/
                                                  ),
                                                )),
                                          ])),
                                  Container(
                                      alignment: Alignment.topRight,
                                      child: _priceText(_price)),
                                ]),
                              ),
                            ),
                            /* Container(
                        child: TabBar(
                          controller: tabController,
                          indicatorColor: Colors.white,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: [
                            Tab(
                              text: "Описание",
                            ),
                            Tab(
                              text: "Характеристики",
                            )
                          ],
                          onTap: (index) {
                            print(index);
                            if (index == 1) {
                              setState(() {
                                _tabHeight = !_tabHeight;
                              });
                            } else {
                              setState(() {
                                _tabHeight = false;
                              });
                            }
                            print(_tabHeight);
                          },
                        ),
                      ),*/
                            /*  AnimatedContainer(
                        margin: EdgeInsets.only(top: 5, left: 5),
                        height: _tabHeight ? 150 : 50,
                        width: MediaQuery.of(context).size.width,
                        duration: Duration(milliseconds: 200),
                        child: new TabBarView(
                            controller: tabController,
                            children: [
                              _description(
                                  _opt,
                                  _opt.values.toList(),
                                  _opt.keys.toList(),
                                  widget.product.description),
                              Text(
                                "- Объем: 250 мл\n- Цвет: Черный\n- В наличии 124 штук\n",
                                style: TextStyle(color: Colors.white),
                                softWrap: true,
                              )
                            ]),
                      ),*/
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      // height: 0,
                                      decoration: BoxDecoration(
                                          border: Border(
                                        bottom: BorderSide(
                                          //                   <--- left side
                                          color: Colors.white30,
                                          width: 0.5,
                                        ),
                                        top: BorderSide(
                                          //                   <--- left side
                                          color: Colors.white30,
                                          width: 0.5,
                                        ),
                                      )),
                                      margin: EdgeInsets.only(
                                          top: 20, left: 20, bottom: 5),
                                      //   child: Padding(
                                      // padding: EdgeInsets.only(top: 15),
                                      child: ExpandablePanel(
                                          collapsed: null,
                                          controller: excontroller,
                                          theme: ExpandableThemeData(
                                              iconColor: Colors.white),
                                          header: Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Text(
                                                "Описание",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )),
                                          expanded: _description(
                                              _opt,
                                              _opt.values.toList(),
                                              _opt.keys.toList(),
                                              widget.description,
                                              dateDelivery))),

                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    //height: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            // height: 0,
                                            decoration: BoxDecoration(
                                                border: Border(
                                              bottom: BorderSide(
                                                //                   <--- left side
                                                color: Colors.white30,
                                                width: 0.5,
                                              ),
                                            )),
                                            margin: EdgeInsets.only(
                                                left: 20, bottom: 10),
                                            //   child: Padding(
                                            // padding: EdgeInsets.only(top: 15),
                                            child: ExpandablePanel(
                                                theme: ExpandableThemeData(
                                                    iconColor: Colors.white),
                                                collapsed: null,
                                                header: Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 5),
                                                    child: Text(
                                                      "Характеристики",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    )),
                                                expanded: _characteristicks(
                                                    widget.producer,
                                                    widget.length,
                                                    widget.sort))),
                                        // )
                                      ],
                                    ),
                                  ),
                                  /////COUNT WIDGET////////
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 10, left: 30),
                                      child: CountWidget(
                                        quantity: quantity,
                                        count: quantity != 0 ? qpak : 0,
                                        optKolvo: _opt.values.toList(),
                                        minkolvo:
                                            quantity <= qpak && quantity > 0
                                                ? quantity
                                                : null,
                                        optPrices: _opt.keys.toList(),
                                        price: _price,
                                        opt: _opt,
                                        kolvo: qpakZ != null ? qpakZ : kolvo,
                                        onSelected: (size) {
                                          count = size;
                                          kolvo = count;
                                          summa = (_price * kolvo);
                                          print(" MAIN $_price");
                                        },
                                        onSelected1: (size) {
                                          count = size;
                                          kolvo = count;
                                          summa = _price * kolvo;

                                          print(" MAIN $_price");
                                        },
                                        onSelected2: (pr) {
                                          _price = pr;
                                          print("pr" +
                                              _price.toString() +
                                              " " +
                                              pr.toString());
                                          summa = _price * kolvo;
                                        },
                                      )),
                                  _bottombtn(qpakZ != null ? qpakZ : qpak),
                                ],
                              ),
                            ),
                          ],
                        ),
                        height: MediaQuery.of(context).size.height))
              ]));
  }

  Widget _priceText(int _price) {
    return Text(
      '$_price₽ ',
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: MediaQuery.of(context).size.height / 15,
          shadows: [
            Shadow(
              blurRadius: 10.0,
              color: Colors.black38,
              offset: Offset(3.0, 3.0),
            ),
          ]),
    );
  }

  Widget _description(Map<dynamic, dynamic> opt, List<dynamic> optPrices,
      List<dynamic> optKolvo, String description, String delivery) {
    List k = [];
    opt.keys.forEach((element) {
      k.add(int.parse(element));
    });
    List v = opt.values.toList();
    k.sort();
    v.sort((b, a) => a.compareTo(b));
    // print(k);
    // print(v);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // for (int i = 0; i < optKolvo.length; i++)

      // if (optKolvo[i + 1] != null || optPrices[i + 1] != null)
      if (delivery != "" && delivery != null)
        Text("Дата поставки: $delivery\n",
            style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700)),
      for (int i = 0; i < opt.length; i++)
        Text(
          "от ${k[i]} штук - ${v[i]}₽",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      Text(
        "$description\n",
        style: TextStyle(fontSize: 14, color: Colors.white),
      )
    ]);
  }

  Widget _characteristicks(String producer, String length, String sort) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      producer != null && producer != ''
          ? Text(
              "- Производитель: $producer",
              style: TextStyle(fontSize: 14, color: Colors.white),
            )
          : SizedBox(),
      length != null && length != ''
          ? Text(
              "- Длина: $length см",
              style: TextStyle(fontSize: 14, color: Colors.white),
            )
          : SizedBox(),
      sort != null && sort != ''
          ? Text(
              "- Сорт: $sort\n",
              style: TextStyle(fontSize: 14, color: Colors.white),
            )
          : SizedBox(),
    ]);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverPersistentHeaderDelegate({this.child, this.height});

  final Widget child;
  final double height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
