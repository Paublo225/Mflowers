import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers0/auth/initilization.dart';
import 'package:flowers0/main.dart';
import 'package:flowers0/model/cartEmpty.dart';
import 'package:flowers0/model/cartItem.dart';
import 'package:flowers0/order/orderslist.dart';
import 'package:flowers0/pageRoute.dart';
import 'package:flowers0/provider/connection_provider.dart';
import 'package:flowers0/provider/user_pr.dart';
import 'package:flowers0/sevices/category.dart';
import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flowers0/sevices/order.dart';
import 'package:flowers0/sevices/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ConfirmOrderPage extends StatefulWidget {
  int summary;
  String img;
  String title;
  String price;
  List<int> kolvos;
  List<int> quantities;
  int id;
  List<String> idz;
  int quantity;
  List<CartItemModel> cartItem;
  List<CartEmptyModel> emptyCartItem;

  ConfirmOrderPage(
      {Key key,
      this.summary,
      this.kolvos,
      this.quantities,
      this.idz,
      this.cartItem,
      this.emptyCartItem})
      : super(key: key);
  @override
  _ConfirmOrderPageState createState() => new _ConfirmOrderPageState();
}

TextStyle appbarTitle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);
TextStyle topMenulight = TextStyle(
  color: Colors.black,
  fontSize: 16,
);

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  DeliveryMethod _deliveryMethod = DeliveryMethod.del;
  PayMethod _payMethod = PayMethod.mon;
  int _summary = 0;
  int _total = 0;
  String _paymentMethod = "Наличные";
  OrderServices _orderServices = OrderServices();
  List<CartItemModel> convertedCart = [];
  FirebaseServices _firebaseServices = FirebaseServices();
  CategoryServices categoryServices;
  ProductServices productServices;
  User user = FirebaseAuth.instance.currentUser;

  bool _confirmed = false;
  String _mainEmail = "";
  _getMainEmail() async {
    await FirebaseFirestore.instance
        .collection("контактная_информация")
        .doc("текст")
        .get()
        .then((value) {
      setState(() {
        _mainEmail = value.data()["почта"];
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

  bool isAvailableBool = true;
  List<bool> _isAvailableList = [];
  Future<bool> isAvalaible() async {
    widget.cartItem.forEach((item) async {
      for (var item in convertedCart) {
        await _firebaseServices.productsRef.doc(item.id).get().then((value) {
          var ooz = value.data;
          var globalQuantity = int.parse(ooz()["quantity"]);
          bool satisfy = false;
          if (globalQuantity >
              (globalQuantity - int.parse(item.quantity)).abs()) {
            print(item.id);
            print(item.quantity);
            setState(() {
              satisfy = true;
            });
          } else
            setState(() {
              satisfy = false;
            });

          setState(() {
            _isAvailableList.add(satisfy);
          });
        });
      }
    });
    print(_isAvailableList);
    for (bool item in _isAvailableList) {
      if (item == false) {
        setState(() {
          isAvailableBool = false;
        });
        break;
      }
    }

    _isAvailableList.clear();

    print(isAvailableBool);
    return isAvailableBool;
  }

  _acc() {
    if (isAvailableBool)
      widget.cartItem.forEach((item) async {
        await _firebaseServices.productsRef
            .doc(item.id)
            .get()
            .then((value) async {
          var query = value.data;
          await _firebaseServices.productsRef.doc(item.id).update({
            "quantity":
                (int.parse(query()["quantity"]) - int.parse(item.quantity))
                    .toString()
          });
        });
        print(
            "ACC ${item.name} ${item.name} ${int.parse(item.fullQuantity) - int.parse(item.quantity)}");
      });
    else
      print("Ошибочкаа такая");
  }

  _backacc() {
    convertedCart.forEach((item) async {
      await _firebaseServices.productsRef.doc(item.id).get().then((value) {
        int backQuantity = int.parse(value.data()["quantity"]);
        _firebaseServices.productsRef.doc(item.id).update(
            {"quantity": (backQuantity + int.parse(item.quantity)).toString()});
      });
      print(
          "BACK ACC ${item.name} ${int.parse(item.fullQuantity)}  ${int.parse(item.quantity)}");
    });
  }

  _totalSum() {
    _total = 0;
    convertedCart.forEach((i) {
      _total += int.parse(i.price);
    });
  }

  @override
  void initState() {
    super.initState();
    _getMainEmail();
    _summary = widget.summary;
    _initVibration();
    convertedCart.clear();
    convertedCart.addAll(widget.cartItem);
    _totalSum();
    // _totalSum();

    //  _acc();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> conformationAction(String id, String userId, int total) async {
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    // ignore: missing_return
    Consumer<ConnectivityProvider>(builder: (context, model, child) {
      if (model.isOnline != null) print("faf");
    });

    await _acc();
    print("Заказ учтен");

    await new Future.delayed(const Duration(seconds: 5), () async {
      _conformationState(id, userId, total);
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // _acc();

    return Scaffold(
        backgroundColor: Colors.white,
        // key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          // flexibleSpace: _topInfo(),
          leading: IconButton(
            mouseCursor: SystemMouseCursors.forbidden,
            color: Colors.black,
            iconSize: 34,
            icon: Icon(Icons.close),
            onPressed: () {
              //  _dialog();
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Оформление заказа".toUpperCase(),
            style: appbarTitle,
          ),
          elevation: 0.0,
        ),
        body: ListView(children: <Widget>[
          //    _topInfo(),
          for (int i = 0; i < convertedCart.length; i++) convertedCart[i],
          /*    if (widget.emptyCartItem.length > 0)
            for (int i = 0; i < widget.emptyCartItem.length; i++)
              widget.emptyCartItem[i],*/
          Container(
              margin: EdgeInsets.all(16),
              height: 90,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(1.0, 3.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Способ оплаты",
                        style: topMenulight,
                      )),
                  /*    RadioListTile<PayMethod>(
                      activeColor: mainColor,
                      title: Container(
                          child: Text("Карта", style: TextStyle(fontSize: 14))),
                      value: PayMethod.card,
                      groupValue: _payMethod,
                      onChanged: (PayMethod value) {
                        setState(() {
                          _payMethod = value;
                          _paymentMethod = _timeToString(value);
                        });
                      }),*/
                  /*     RadioListTile<PayMethod>(
                      activeColor: mainColor,
                      title: Container(
                          child: Text("Apple Pay",
                              style: TextStyle(fontSize: 14))),
                      value: PayMethod.apple,
                      groupValue: _payMethod,
                      onChanged: (PayMethod value) {
                        setState(() {
                          _payMethod = value;
                          _paymentMethod = _timeToString(value);
                        });
                      }),*/
                  RadioListTile<PayMethod>(
                      activeColor: mainColor,
                      title: Container(
                          child: Text("Наличными",
                              style: TextStyle(fontSize: 14))),
                      value: PayMethod.mon,
                      groupValue: _payMethod,
                      onChanged: (PayMethod value) {
                        setState(() {
                          _payMethod = value;
                          _paymentMethod = _timeToString(value);
                        });
                      }),
                ],
              )),
          _bottomInfo()
        ]));
  }

/*
  _topInfo() {
    return TweenAnimationBuilder<Duration>(
        duration: Duration(minutes: 5),
        tween: Tween(begin: Duration(minutes: 5), end: Duration.zero),
        onEnd: () {
          if (_confirmed == false) {
            _backacc();
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, Duration value, Widget child) {
          final minutes = value.inMinutes;
          final seconds = value.inSeconds % 60;
          return Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(right: 25),
              child: Text('$minutes:$seconds',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20)));
        });
  }
*/
  Widget _bottomInfo() {
    String id = Uuid().v1().toString();
    return BottomAppBar(
        elevation: 0.0,
        child: Container(
            padding: EdgeInsets.only(bottom: 20),
            height: MediaQuery.of(context).size.height / 5.5,
            child: new Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin:
                                EdgeInsets.only(top: 5, left: 15, right: 15),
                            alignment: Alignment.topLeft,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "ИТОГ:",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  Text(
                                    "$_total руб",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ])),
                        new Container(
                            margin: EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 50,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.black),
                                ),
                                disabledColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: Colors.black,
                                onPressed: () async {
                                  convertedCart.forEach((f) {
                                    print(f.name);
                                  });
                                  _onSubmit(
                                    id,
                                    _total,
                                    _firebaseServices.getUserId(),
                                    convertedCart,
                                  );
                                },
                                child: Text("Оформить заказ",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white)))),
                      ],
                    ),
                  )
                ])));
  }

  _popUp(String id) {
    return Scaffold(
        body: Center(
            child: Column(
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
            child:
                Text("Заказ №${id} оформлен!", style: TextStyle(fontSize: 20)),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            RaisedButton(
                color: Colors.black,
                child: Text(
                  'ОК',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  return Navigator.pushAndRemoveUntil(
                      context,
                      NoAnimationMaterialPageRoute(
                          builder: (context) => LandingPage()),
                      (Route<dynamic> route) => false);
                }),
            /*   SizedBox(
              width: 10,
            ),
            RaisedButton(
                color: Colors.white,
                child: Text(
                  'Узнать статус',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  showCupertinoModalPopup(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return DefaultTabBar();
                      });
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => OrderHistory(),
                      fullscreenDialog: true));
                }),*/
          ])
        ])));
  }

  /*_dialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final userpr = Provider.of<UserProvider>(context);
        return AlertDialog(
            title: Center(child: Text('Заказ будет отменен')),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Вы уверены, что хотите выйти?",
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
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
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                userpr.changeLoading();
                              }),
                        ),
                      ]),
                  Column(children: [
                    Container(
                        // alignment: Alignment.centerRight,
                        // margin: EdgeInsets.only(ri: 20),
                        //height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: RaisedButton(
                            child: Text('Отмена'),
                            onPressed: () {
                              setState(() {});
                              Navigator.of(context).pop();
                            })),
                  ]),
                ],
              )
            ]);
      },
    );
  }*/

  _onSubmit(
    String id,
    int total,
    String userId,
    List<CartItemModel> cartList,
  ) {
    setState(() {});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: RaisedButton(
                              color: Colors.black,
                              child: Text(
                                'Да',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                //Navigator.pop(context);

                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      isAvalaible();
                                      isAvalaible();
                                      return Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.red[100]),
                                        ),
                                      );
                                    });
                                await Future.delayed(Duration(milliseconds: 10))
                                    .then((value) async {
                                  await isAvalaible();
                                  await isAvalaible();
                                });

                                await isAvalaible().then((value) {
                                  setState(() {
                                    isAvailableBool = value;
                                  });
                                });

                                print("WTFFF" + isAvailableBool.toString());
                                await conformationAction(id, userId, total);
                              }),
                        ),
                      ]),
                  Column(children: [
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
                  ])
                ],
              )
            ]);
      },
    );
  }

  /*checkAcc() async {
    await Future.delayed(Duration(seconds: 5))
        .then((value) async => await isAvalaible());
  }*/

  String _mailOrder(
      String nordder, List<CartItemModel> items, String email, int itog) {
    var message =
        '<center><img src="https://firebasestorage.googleapis.com/v0/b/flowers-64dcc.appspot.com/o/logo_flowers.png?alt=media&token=e176c590-280c-4a15-bed9-9185451683e0"></center></br><h3>Заказ оформлен</h3><p>Ваш заказ оформлен и ожидает оплаты.</p><p>Если у вас возникнут вопросы, вы можете связаться с нами по телефону +7 499 677 5877 с 11:00 до 21:00 или ответить на это сообщение.</p><center><h2>Заказ №$nordder</h2></center></br><table><table border="1" width="100%" cellpadding="5"><tr><th>Товар</th><th>Цена</th><th>Кол-во</th><th>Сумма</th></tr>';
    var row = '';
    for (int i = 0; i < items.length; i++) {
      row +=
          '<tr><td>${items[i].name}</td><td>${items[i].price}, руб.</td><td>${items[i].quantity} шт.</td><td>${items[i].price}, руб.</td></tr>';
    }
    var itogo =
        '<tr><td colspan="3" style="text-align:left"><b>ИТОГО:</b></td><td><b>$itog, руб.</b></td></tr></table>';
    var info = '<h3>Ваши данные</h3><p><b>Почта:</b> $email</p>';
    print("mail send");
    return message + row + itogo + info;
  }

  void _conformationState(String id, String userId, int total) async {
    await isAvalaible().then((value) async {
      if (value) {
        Navigator.pop(context);
        Navigator.of(context).pop();

        /*   Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DefaultTabBar()));*/
        //window OK
        showCupertinoModalPopup(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return _popUp(id.toUpperCase().substring(0, 7));
            });
        //CREATING ORDER

        _orderServices.createOrder(
            userId: userId,
            id: id,
            totalPrice: total,
            status: "В процессе",
            cartItems: convertedCart,
            payMeth: _paymentMethod);

        //CLEARING CART
        await FirebaseFirestore.instance.collection("mail").add({
          "to": _mainEmail,
          "message": {
            "subject": 'Новый заказ №${id.toUpperCase().substring(0, 7)}',
            "html": _mailOrder(id.toUpperCase().substring(0, 7), convertedCart,
                user.email, _total),
          },
        });
        /////// ОТПРАВЛЯЕТ ИНФО КЛИЕНТУ
        await FirebaseFirestore.instance.collection("mail").add({
          "to": user.email,
          "message": {
            "subject": 'Заказ №${id.toUpperCase().substring(0, 7)} оформлен',
            "html": _mailOrder(
              id.toUpperCase().substring(0, 7),
              convertedCart,
              user.email,
              _total,
            )
          },
        });
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
      } else {
        await _backacc();
        convertedCart.clear();

        Navigator.pop(context);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        print("ощибка");

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(
                  child: Text('Возникла ошибка'),
                ),
                actions: [
                  Center(
                    child: Container(

                        //  margin: EdgeInsets.only(right: 10),
                        //height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black)),
                            child: Text('ОК'),
                            onPressed: () {
                              Navigator.pop(context);

                              didUpdateWidget(ConfirmOrderPage());
                            })),
                  ),
                ],
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "При оформлении заказа\nНе оказалось в наличии товара",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              );
            });
      }
    });
  }

  _timeToString(PayMethod pay) {
    switch (pay) {
      case PayMethod.apple:
        return "Apple Pay";
      case PayMethod.mon:
        return "Наличные";
      case PayMethod.card:
        return "Карта";
      case PayMethod.google:
        return "Google Pay";
      default:
        return "Наличные";
    }
  }
}

enum DeliveryMethod { del, loc }

enum PayMethod {
  mon,
  apple,
  google,
  card,
}
