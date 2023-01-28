import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flowers0/auth/initilization.dart';

import 'package:flowers0/homepageview/homie.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flowers0/provider/category.dart';
import 'package:flowers0/provider/connection_provider.dart';
import 'package:flowers0/provider/product_pr.dart';
import 'package:flowers0/provider/user_pr.dart';
import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/services.dart';
import 'userpage/user.dart';
import 'cart/cart.dart';
import 'package:provider/provider.dart';

Color mainColor = Colors.pink[100];
StreamSubscription<Map> _notificationSubscription;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  return runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: UserProvider.initialize()),
    ChangeNotifierProvider.value(value: CategoryProvider.initialize()),
    ChangeNotifierProvider.value(value: ProductProvider.initialize()),
    ChangeNotifierProvider(
        create: (context) => ConnectivityProvider(), child: HomePageZ()),
    ChangeNotifierProvider<Cart>(create: (_) => Cart()),
  ], child: MainApp()));
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context)
            .appBarTheme
            .copyWith(brightness: Brightness.light),
      ),

      locale: Locale("ru", "RU"),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      ////  localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      // onGenerateRoute: (settings) {},
      home: LandingPage(),
    );
  }
}

class DefaultTabBar extends StatefulWidget {
  int indexTab;
  int mainIndex;
  bool cartFlag;
  DefaultTabBar({Key key, this.indexTab, this.mainIndex, this.cartFlag})
      : super(key: key);
  @override
  BottomRock createState() => new BottomRock();
}

class BottomRock extends State<DefaultTabBar>
    with SingleTickerProviderStateMixin {
  CupertinoTabController _tabController;
  int _tabIndex = 0;
  FirebaseServices _firebaseServices = FirebaseServices();
  int cartItems = 0;

  int indexPrevValue = 0;
  bool _techWorks = false;

  _technicalWorks() async {
    await FirebaseFirestore.instance
        .collection("технические_работы")
        .doc("технические_работы")
        .get()
        .then((value) {
      setState(() {
        _techWorks = value.data()["тех_работы"];
        print(_techWorks);
      });
    });
  }

  void doc(int list) async {
    QuerySnapshot querySnapshot = await _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("cart")
        .get();
    list = querySnapshot.docs.length;
    setState(() {
      cartItems = list;
    });
  }

  void initState() {
    super.initState();
    _technicalWorks();
    _tabController = new CupertinoTabController(initialIndex: 0);

    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
      //print('my index is' + _tabController.index.toString());
    });
    doc(cartItems);
    _sums();
  }

  List<int> _summavsego = [];
  int summary = 0;
  int summaryz = 0;

  Future<int> _sums() async {
    var ggg = await _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("cart")
        .get();

    for (int i = 0; i < ggg.size; i++) _summavsego.add(ggg.docs[i]["summa"]);

    _summavsego.forEach((i) {
      summary += i;
    });

    _summavsego = [];
    return summary;
  }

  int lengthCart;

  @override
  Widget build(BuildContext context) {
    //   final productprov = Provider.of<ProductProvider>(context);
    final userpr = Provider.of<UserProvider>(context);
    var media = MediaQuery.of(context).size.height / 24;
    var topCir = MediaQuery.of(context).size.height / 120;
    var leftCir = MediaQuery.of(context).size.height / 46;
    var radius = MediaQuery.of(context).size.height / 110;

    var fontCir = MediaQuery.of(context).size.height / 90;

    if (_techWorks == false)
      return CupertinoTabScaffold(
        controller: _tabController,
        tabBar: CupertinoTabBar(
          activeColor: mainColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: media,
              ),
            ),
            BottomNavigationBarItem(
              icon: new Stack(
                children: <Widget>[
                  new Icon(
                    Icons.shopping_basket,
                    size: media,
                  ),
                  new Positioned(
                      top: topCir,
                      left: leftCir,
                      child: FutureBuilder<int>(
                          future: userpr.getLengthCartProvider(),
                          initialData: cartItems,
                          builder: (context, AsyncSnapshot<int> snapshot) {
                            cartItems = snapshot.data;

                            if (snapshot.hasData) {
                              return new CircleAvatar(
                                  radius: radius,
                                  backgroundColor: Colors.red,
                                  child: new Text(
                                    snapshot.data.toString(),
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: fontCir,
                                        fontWeight: FontWeight.w500),
                                  ));
                            } else
                              return new CircleAvatar(
                                  radius: radius,
                                  backgroundColor: Colors.red,
                                  child: new Text(
                                    cartItems.toString(),
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: fontCir,
                                        fontWeight: FontWeight.w500),
                                  ));
                          })),
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_fill, size: media),
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: HomePageZ(),
                );
              });
              break;
            case 1:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: Cart(
                    key: Key("cart"),
                  ),
                );
              });
              break;
            case 2:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: UserPage(),
                );
              });
              break;
            default:
              return CupertinoTabView(builder: (context) {
                return CupertinoPageScaffold(
                  child: HomePageZ(),
                );
              });
              break;
          }
        },
      );
    else
      return nointernet();
  }

  nointernet() {
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
            "Проводятся технические работы.Скоро все исправим\nПопробуйте обновить или зайти.",
            textAlign: TextAlign.center,
            // style: _textStyle,
          ),
          GestureDetector(
            onTap: () {
              print("refreshed");
              setState(() {});
            },
            child: Container(
              margin: EdgeInsets.only(top: 45),
              width: 90,
              height: 40,
              child: Center(
                child: Text(
                  "Обновить",
                  // style: _textStyleBtn,
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
}
