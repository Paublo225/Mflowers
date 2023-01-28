/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flowers0/homepageview/searchresults.dart';
import 'package:flowers0/model_screen/new_item_screen.dart';
import 'package:flowers0/sevices/category.dart';
import 'package:scrollable_list_tabview/scrollable_list_tabview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../model_screen/item_info.dart';
import '../main.dart';
import '../sevices/product.dart';
import 'package:vertical_scrollable_tabview/vertical_scrollable_tabview.dart';

class HomePage extends StatefulWidget {
  HomePage();
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  CategoryServices categoryServices;
  ProductServices productServices;
  bool _folded = true;
  TabController _tabController;
  FirebaseMessaging _firebaseMessaging;

  final TextStyle topMenuStyle = new TextStyle(
      //  fontFamily: 'Avenir next',
      fontSize: 26,
      color: Colors.black,
      fontWeight: FontWeight.w600);
  final TextStyle buttonInfoStyle = new TextStyle(
      fontFamily: 'Avenir next', fontSize: 14, fontWeight: FontWeight.w600);

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings;
  _tokenget() async {
    settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  int countCategories;

  void initState() {
    //  _getListName();
    super.initState();
    _tokenget();
    _pageController = PageController(initialPage: 0, viewportFraction: 4);
  }

  void firebaseCloudMessagingListeners(BuildContext context) {
    _firebaseMessaging.getToken().then((deviceToken) {
      print("Firebase Device token: $deviceToken");
    });
  }

  List<String> _namesCategory = [
    "Новинки",
    "На свидание",
    "Упаковки",
    "Популярное",
    "На праздник",
    "Роза Эквадор",
  ];
  _getListName() async {
    await FirebaseFirestore.instance.collection("category").get().then((value) {
      for (int i = 0; i < value.docs.length; i++)
        _namesCategory.add(value.docs[i]["name"]);
    });
    print(_namesCategory);
    return _namesCategory;
  }

  String _searchString = "";

  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("products");

  final CollectionReference dataPostavki =
      FirebaseFirestore.instance.collection("data_postavki");
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  PageController _pageController;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('User granted permission: ${settings.authorizationStatus}');
    return new DefaultTabController(
        length: 1,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            appBar: new AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      _folded ? "Каталог" : "Поиск",
                      style: topMenuStyle,
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      width: _folded
                          ? 45
                          : MediaQuery.of(context).size.width - 150,
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
                                      style: TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      decoration: InputDecoration(
                                          hoverColor: Colors.white,
                                          hintText: 'Поиск',
                                          hintStyle: TextStyle(
                                            height: 1.3,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                          border: InputBorder.none),
                                      onChanged: (val) {
                                        setState(() {
                                          _searchString = val.toLowerCase();
                                        });
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
                                  topLeft: Radius.circular(_folded ? 32 : 0),
                                  topRight: Radius.circular(32),
                                  bottomLeft: Radius.circular(_folded ? 32 : 0),
                                  bottomRight: Radius.circular(32),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    _folded ? Icons.search : Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _folded = !_folded;
                                    _searchString = "";
                                  });

                                  //  print(widget.folded);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
            ),
            backgroundColor: Colors.white,
            body: _folded
                ? FutureBuilder(
                    future:
                        FirebaseFirestore.instance.collection("category").get(),
                    builder: (context, snapshot) {
                      //var doc = snapshot.data["name"];
                      return ScrollableListTabView(
                          tabHeight: 48,
                          bodyAnimationDuration:
                              const Duration(milliseconds: 200),
                          tabAnimationCurve: Curves.easeInToLinear,
                          bodyAnimationCurve: Curves.ease,
                          tabAnimationDuration:
                              const Duration(milliseconds: 200),
                          tabs: [
                            for (int i = 0; i < _namesCategory.length; i++)
                              ScrollableListTab(
                                  tab: ListTab(
                                      label: Text(
                                        _namesCategory[i],
                                        style: buttonInfoStyle,
                                      ),
                                      activeBackgroundColor: mainColor,
                                      showIconOnList: false),
                                  body: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: 1,
                                      itemBuilder: (context, index) {
                                        return new FutureBuilder<QuerySnapshot>(
                                            future: _productsRef
                                                .where("category",
                                                    isEqualTo:
                                                        _namesCategory[i])
                                                .get(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Column(
                                                    children: snapshot.data.docs
                                                        .map((document) {
                                                  return document.get(
                                                              'quantity') ==
                                                          "0"
                                                      ? SizedBox()
                                                      : FlowerItemZ(
                                                          id: document.id,
                                                          title: document
                                                              .data()['name'],
                                                          imageUrl:
                                                              document.data()[
                                                                  'imageUrl'],
                                                          price: document
                                                              .data()['price'],
                                                          description: document
                                                                  .data()[
                                                              'description'],
                                                          qpak: document
                                                              .data()['qpak'],
                                                          opt: document
                                                              .data()['опт'],
                                                          minKolvo:
                                                              document.data()[
                                                                  'мин_кол-во'],
                                                          categories:
                                                              document.data()[
                                                                  'category'],
                                                          quantity:
                                                              document.data()[
                                                                  "quantity"],
                                                          page: _pageController,
                                                        );
                                                }).toList());
                                              }
                                              if (!snapshot.hasData) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  valueColor:
                                                      new AlwaysStoppedAnimation<
                                                              Color>(
                                                          Colors.pink[100]),
                                                ));
                                              }

                                              return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                            Color>(
                                                        Colors.pink[100]),
                                              ));
                                            });
                                      }))
                          ]);
                    })
                : SearchResultPage(
                    // search: _searchString,
                    )));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
*/