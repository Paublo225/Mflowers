import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flowers0/homepageview/searchresults.dart';
import 'package:flowers0/main.dart';
import 'package:flowers0/model_screen/new_item_screen.dart';
import 'package:flowers0/sevices/searchservices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SortPage extends StatefulWidget {
  String search;
  SortPage({Key key, this.search}) : super(key: key);
  @override
  _SortPageState createState() => new _SortPageState();
}

class _SortPageState extends State<SortPage>
    with AutomaticKeepAliveClientMixin<SortPage> {
  SearchService _searchService = SearchService();
  List<FilterSearch> filterSearchList = [];
  fetchSort() {
    _searchService.sortList().then((event) {
      setState(() {
        filterSearchList.addAll(event);
      });
    });
  }

  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("products");
  String _searchString = "";

  void initState() {
    // loadData();
    super.initState();
    // controller = ScrollController()..addListener(_scrollListener);
    fetchSort();
    print("called Sort");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white30,
        elevation: 0.0,
        title: Text(
          "Сортировка",
          style: Constants.boldHeading,
        ),
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
                color: Colors.transparent,
                width: 50,
                height: 50,
                child: Icon(
                  CupertinoIcons.back,
                  size: 28.0,
                  color: Colors.pink[200],
                ))),
        bottom: PreferredSize(
            preferredSize: new Size.fromHeight(60.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                onTap: () {
                  showCupertinoModalPopup<void>(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      title: const Text('Сортировать'),
                      actions: <CupertinoActionSheetAction>[
                        CupertinoActionSheetAction(
                          child: const Text("Цена по возрастанию"),
                          onPressed: () {},
                        ),
                        CupertinoActionSheetAction(
                          child: const Text("Цена по убыванию"),
                          onPressed: () {},
                        ),
                        CupertinoActionSheetAction(
                          child: const Text('Отмена'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0.8,
                        blurRadius: 0.1,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sort),
                        Text("Сортировать"),
                      ]),
                  // alignment: AlignmentDirectional.bottomStart,
                  width: 140,
                  height: 40,

                  //    margin: EdgeInsets.all(10),
                ),
              ),
            ])),
      ),
      body: ListView.builder(
          itemCount: filterSearchList.length,
          itemBuilder: (itemBuilder, i) {
            return Column(children: [
              Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.topLeft,
                child: Text(
                  filterSearchList[i].titlez.toUpperCase(),
                  style: Constants.regularDarkText,
                ),
              ),
              Container(
                  height: 80,
                  width: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      for (int j = 0;
                          j < filterSearchList[i].atributz.length;
                          j++)
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                filterSearchList[i].selected =
                                    !filterSearchList[i].selected;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(15),
                              height: 40,
                              width: 60,
                              child: Center(
                                child: Text(
                                  filterSearchList[i].atributz[j],
                                  style: TextStyle(
                                      color: filterSearchList[i].selected
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: filterSearchList[i].selected
                                      ? mainColor
                                      : Colors.grey[300]),
                            )),
                    ],
                  )),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    width: 180,
                    height: 50,
                    decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "Применить",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
              Center(child: Text("\n (!) Этот раздел еще в стадии разработки"))
            ]);
          }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class Constants {
  static const regularHeading = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black);

  static const boldHeading = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black);

  static const regularDarkText = TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black);
}

class FilterSearch {
  static const atribuites = "атрибуты";
  static const value = "значение";
  static const title = "название";
  static const ID = "id";
  FilterSearch({this.atributz, this.titlez, this.valuez, this.selected});
  List<dynamic> atributz;
  String valuez;
  String titlez;
  String id;
  bool selected = false;

  FilterSearch.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    atributz = snapshot.data()[atribuites];
    valuez = snapshot.data()[value];
    titlez = snapshot.data()[title];
  }
}
