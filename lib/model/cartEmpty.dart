import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CartEmptyModel extends StatefulWidget {
  static const ID = "cartid";
  static const NAME = "name";

  static const PRICE = "summa";
  static const QUANTITY = "kolvo";
  static const IMG = "imageUrl";

  String id;
  String name;
  String imageUrl;
  String productId;
  String price;
  String quantity;

  CartEmptyModel({
    Key key,
    this.id,
    this.name,
    this.imageUrl,
    this.price,
    this.productId,
    this.quantity,
  });

  CartEmptyModelState createState() => new CartEmptyModelState();
}

class CartEmptyModelState extends State<CartEmptyModel> {
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 100,
        width: double.infinity,
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
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: FirebaseImage(widget.imageUrl),
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(
              height: 10,
              width: 10,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: widget.name + "\n",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "${widget.price} руб \n\n",
                          style: TextStyle(
                              color: Colors.black26,
                              fontSize: 16,
                              fontWeight: FontWeight.w300)),
                      TextSpan(
                          text: "Нет в наличии",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
