/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'item_screen.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final TextStyle topMenuStyle = new TextStyle(
    fontFamily: 'Avenir next',
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.w600);

// ignore: must_be_immutable
class FlowerItem extends StatefulWidget {
  String id;
  String imageUrl;
  String title;
  String categories;
  String price;
  String description;
  String quantity;
  String opt;
  PageController page;
  FlowerItem(
      {this.id,
      this.imageUrl,
      this.title,
      this.categories,
      this.price,
      this.description,
      this.quantity,
      this.page,
      this.opt});

  Map toMap() => {
        "id": id,
        "imageUrl": imageUrl,
        "name": title,
        "price": price,
        "quantity": quantity,
        //   "опт_w": opt,
        //   "мин_кол-во": min_kolvo,
      };
  _FlowerItemState createState() => new _FlowerItemState();
}

class _FlowerItemState extends State<FlowerItem> {
  inistate() {
    super.initState();
    setState(() {});
    print("flowerrr");
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future getDocs() async {
    Future<DocumentSnapshot> querySnapshot =
        _firestore.collection("products").doc("title").get();
    print(querySnapshot);
  }

  getProductsOfCategory(String category) async => _firestore
          .collection("products")
          .where("category", isEqualTo: category)
          .snapshots()
          .listen((data) {
        print(data.docs[0]["name"].toString());
      });
  FlowerItem flowerItem;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.page,
      builder: (BuildContext context, Widget widget) {
        return Center(
          child: Container(
            height: 350,
            width: Curves.easeInOut.transform(1) * 250.0,
            child: widget,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => showBarModalBottomSheet(
          expand: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) =>
              FlowerScreen(flowersID: widget.id, title: widget.title),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Hero(
                    tag: "${widget.imageUrl}",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                        image: FirebaseImage(
                          widget.imageUrl,
                        ),
                        width: 120,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              bottom: 40.0,
              child: Container(
                width: 250.0,
                child: Text(
                  widget.title.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black38,
                          offset: Offset(3.0, 3.0),
                        ),
                      ]),
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              bottom: 20.0,
              child: Container(
                width: 250.0,
                child: Text(
                  "${widget.price} р/шт".toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black38,
                          offset: Offset(3.0, 3.0),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
final List<FlowerItem> flowers = [
  FlowerItem(
    id: "1",
    imageUrl: 'lib/assets/bouquet_PNG8.png',
    title: 'Букет Солнечный',
    categories: 'К празднику',
    length: 455,
    description: 'Яркий букет для яркого настроения. Срок после обреза 7 дней.',
    count: 2409,
  ),
  FlowerItem(
    id: "2",
    imageUrl: 'lib/assets/букеты_DoV.png',
    title: 'Букет Прелесть',
    categories: 'На свидание',
    length: 455,
    description: 'Яркий букет для яркого настроения. Срок после обреза 7 дней.',
    count: 3609,
  ),
  FlowerItem(
    id: "3",
    imageUrl: 'lib/assets/bouq_nezh.png',
    title: 'Букет Нежность',
    categories: 'На свидание',
    length: 455,
    description: 'Яркий букет для яркого настроения. Срок после обреза7 дней.',
    count: 1401,
  ),
];
*/
*/