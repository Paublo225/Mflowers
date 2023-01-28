import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flowers0/helpers/internet_issuies.dart';
import 'package:flowers0/homepageview/searchresults.dart';
import 'package:flowers0/homepageview/sortpage.dart';
import 'package:flowers0/model/category.dart';
import 'package:flowers0/model/product.dart';
import 'package:flowers0/model_screen/new_item_screen.dart';
import 'package:flowers0/provider/connection_provider.dart';
import 'package:flowers0/provider/product_pr.dart';
import 'package:flowers0/sevices/category.dart';
import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../sevices/product.dart';
import 'package:vertical_tab_bar_view/vertical_tab_bar_view.dart';

class HomePageZ extends StatefulWidget {
  HomePageZ();
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePageZ>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  CategoryServices _categoryServices = CategoryServices();
  List<CategoryModel> categories = [];
  ProductServices _productServices = ProductServices();
  bool _folded = true;

  TabController _tabController;

  final TextStyle topMenuStyle = new TextStyle(
      //  fontFamily: 'Avenir next',
      fontSize: 26,
      color: Colors.black,
      fontWeight: FontWeight.w600);
  final TextStyle buttonInfoStyle = new TextStyle(
      fontFamily: 'Avenir next', fontSize: 14, fontWeight: FontWeight.w600);

  fetchAllCategories() {
    _categoryServices.getCategories().then((value) {
      setState(() {
        categories.addAll(value);
        _tabController = TabController(length: value.length, vsync: this);
      });
    });
    // print(categories);
  }

  fetchAllProducts() {
    _productServices.getProducts().map((event) {
      setState(() {
        _productList.addAll(event);
      });
    });
  }

  String sortAtribute;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings;
  FirebaseServices _firebaseServices = FirebaseServices();

  _tokenget() async {
    settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    String token = await FirebaseMessaging.instance.getToken();
    List<String> tokenList = [];
    bool _tokenCheck = false;
    String unknownToken = "";

    /* _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .set({"token": []});*/
    _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .get()
        .then((tokenItem) {
      setState(() {
        List.from(tokenItem.data()["token"]).forEach((element) {
          //  print(element.toString());
          tokenList.add(element.toString());
        });
      });
      tokenList.forEach((t) {
        //  print("IF $token == $t");
        if (token == t) {
          setState(() {
            _tokenCheck = true;
          });
        }
      });
      if (!_tokenCheck) {
        tokenList.add(token);
        _firebaseServices.usersRef
            .doc(_firebaseServices.getUserId())
            .update({"token": tokenList});
      }
      print(_tokenCheck);
      print("TokemList: $tokenList");
    });

    print(
        'User granted permission: ${settings.authorizationStatus} \nToken: $token');
  }

  int countCategories;

  @override
  void initState() {
    fetchAllCategories();
    // fetchAllProducts();
    super.initState();
    _tokenget();

    _pageController = PageController(initialPage: 0, viewportFraction: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    Provider.of<ConnectivityProvider>(context, listen: false).dispose();
    super.dispose();
  }

  String _searchString = "";

  final CollectionReference dataPostavki =
      FirebaseFirestore.instance.collection("data_postavki");
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ProductProvider productProvider;
  PageController _pageController;
  List<ProductModel> _productList = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();

    return Consumer<ConnectivityProvider>(builder: (context, model, child) {
      if (model.isOnline != null) {
        return model.isOnline
            ? new DefaultTabController(
                length: 1,
                child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    key: _scaffoldKey,
                    appBar: new AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      bottom: _tabController == null
                          ? null
                          : _folded
                              ? TabBar(
                                  indicator: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                  controller: _tabController,
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.black,
                                  isScrollable: true,
                                  tabs: [
                                    for (CategoryModel category in categories)
                                      Tab(
                                        text: category.name,
                                        height: 35,
                                      )
                                  ],
                                )
                              : null,
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _folded
                                ? new Text(
                                    "Каталог",
                                    style: topMenuStyle,
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      return showCupertinoModalPopup<void>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CupertinoActionSheet(
                                          title: const Text('Сортировать'),
                                          cancelButton:
                                              CupertinoActionSheetAction(
                                            child: const Text('Отмена'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          actions: <CupertinoActionSheetAction>[
                                            CupertinoActionSheetAction(
                                              child: const Text(
                                                  "Цена по возрастанию"),
                                              onPressed: () {
                                                setState(() {
                                                  sortAtribute =
                                                      "По возрастанию";
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                            CupertinoActionSheetAction(
                                              child: const Text(
                                                  "Цена по убыванию"),
                                              onPressed: () {
                                                setState(() {
                                                  sortAtribute = "По убыванию";
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: mainColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          "lib/assets/sort_icon.png",
                                          scale: 1.5,
                                        ),
                                      ),
                                    )),
                            Hero(
                                transitionOnUserGestures: true,
                                tag: "searchbar",
                                child: AnimatedContainer(
                                  curve: Curves.fastOutSlowIn,
                                  duration: Duration(milliseconds: 1600),
                                  width: _folded
                                      ? 45
                                      : MediaQuery.of(context).size.width - 100,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    color: Colors.pink[100],
                                    // boxShadow: kElevationToShadow[6],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: !_folded
                                              ? TextField(
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  cursorColor: Colors.white,
                                                  textInputAction:
                                                      TextInputAction.search,
                                                  decoration: InputDecoration(
                                                      hoverColor: Colors.white,
                                                      hintText: 'Поиск',
                                                      hintStyle: TextStyle(
                                                        height: 1.3,
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                      ),
                                                      border: InputBorder.none),
                                                  onChanged: (val) async {
                                                    setState(() {
                                                      _searchString =
                                                          val.toLowerCase();
                                                    });
                                                    /* await _productServices.searchProducts(
                                            productName: val);*/
                                                  },
                                                )
                                              : null,
                                        ),
                                      ),
                                      Container(
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: InkWell(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                  _folded ? 32 : 0),
                                              topRight: Radius.circular(32),
                                              bottomLeft: Radius.circular(
                                                  _folded ? 32 : 0),
                                              bottomRight: Radius.circular(32),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Icon(
                                                _folded
                                                    ? Icons.search
                                                    : Icons.close,
                                                color: Colors.white,
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                _folded = !_folded;
                                                _searchString = "";
                                                sortAtribute = null;
                                              });

                                              //  print(widget.folded);
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ]),
                    ),
                    backgroundColor: Colors.white,
                    body: _folded
                        ? _tabController == null
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.pink[100]),
                                ),
                              )
                            : VerticalTabBarView(
                                controller: _tabController,
                                children: [
                                    for (CategoryModel category in categories)
                                      ListView(children: [
                                        FlowerItemZ(
                                          category: category.name,
                                          page: _pageController,
                                        )
                                      ])
                                  ])
                        : SearchResultPage(
                            sort_atribute: sortAtribute,
                            search: _searchString,
                          )))
            : _nointernet();
      }
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.red[100]),
        ),
      );
    });
  }

  TextStyle _textStyle = const TextStyle(
    color: Colors.black45,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  TextStyle _textStyleBtn = const TextStyle(
    color: Colors.black45,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
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
            style: _textStyle,
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
                  style: _textStyleBtn,
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

  _filterSearch() {
    GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              /* barrierDismissible: barrierDismissible,
             // routeSettings: routeSettings,
              useRootNavigator: useRootNavigator,
              useSafeArea: useSafeArea,*/
              builder: (BuildContext context) {
                return Dialog(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    //insetPadding: insetPadding,
                    child: Scaffold(
                      appBar: AppBar(
                        leading: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: mainColor,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        title: Text(
                          "Сортировка",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      body: GridView.count(
                        shrinkWrap: true,
                        primary: true,
                        childAspectRatio: 1.5,
                        //  padding: const EdgeInsets.all(5.0),
                        //  crossAxisSpacing: 2.0,
                        crossAxisCount: 3,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.all(10),
                              height: 10,
                              width: 15,
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                              ),
                              child: Text("Длина: 70 см")),
                          Container(
                              margin: EdgeInsets.all(10),
                              height: 10,
                              width: 15,
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                              ),
                              child: Center(child: Text("Длина: 70 см"))),
                          Container(
                              margin: EdgeInsets.all(10),
                              height: 10,
                              width: 15,
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                              ),
                              child: Text("Длина: 70 см")),
                          Container(
                              margin: EdgeInsets.all(10),
                              height: 10,
                              width: 15,
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                              ),
                              child: Text("Длина: 70 см")),
                        ],
                      ),
                    ));
              });
        },
        child: Container(
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          width: 45,
          child: Center(
            child: Icon(CupertinoIcons.sort_down),
          ),
          height: 40,
        ));
  }

  @override
  bool get wantKeepAlive => false;
}
