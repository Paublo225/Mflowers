/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers0/homepageview/homepage.dart';
import 'package:flowers0/model/category.dart';
import 'package:flowers0/sevices/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flowers0/main.dart';

TextStyle categoryStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

// ignore: must_be_immutable
class CategoryListPage extends StatefulWidget {
  final CategoryModel categoryModel;
  String category;
  TabController tabBar;
  int indexs;
  CategoryListPage(
      {Key key, this.categoryModel, this.indexs, this.category, this.tabBar})
      : super(key: key);
  @override
  _CategoryListPageState createState() => new _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  CategoryServices categoryServices;
  final CollectionReference _categoriesRef =
      FirebaseFirestore.instance.collection("category");
  TextEditingController _searchController = TextEditingController();
  void initState() {
    super.initState();

    print("called CategoryListPage");
  }

  @override
  void dispose() {
    super.dispose();
  }

  List listofcategory;
  @override
  Widget build(BuildContext context) {
    return new Stack(children: [
      FutureBuilder<QuerySnapshot>(
          future: _categoriesRef.get(),
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
              var categoryL = snapshot.data.docs;
              print(categoryL.length);
              return GridView.builder(
                  shrinkWrap: true,
                  itemCount: categoryL.length,
                  itemBuilder: (context, index) {
                    return Container(
                        child: SizedBox(
                      //height: MediaQuery.of(context).size.height / 5,
                      //width: Curves.easeInOut.transform(1) * 250.0,
                      child: GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                                transitionDuration: Duration(seconds: 0),
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        HomePage(
                                            // indexs: index,
                                            ))),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 150,
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Center(
                                child: Hero(
                                  tag: "${categoryL[index]["name"]}",
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Text(
                                        "${categoryL[index]["name"]}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
                  },
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20));
            }
            return Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink[100]),
              )),
            );
          })
    ]);
  }
}
*/