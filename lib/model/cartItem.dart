import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CartItemModel extends StatefulWidget {
  static const ID = "cartid";
  static const NAME = "name";

  static const PRICE = "summa";
  static const QUANTITY = "kolvo";
  static const IMG = "imageUrl";
  static const FULLQ = "quantity";

  String id;
  String name;
  String imageUrl;
  String productId;
  String price;
  String quantity;
  String fullQuantity;
  String dateDelivery;

  CartItemModel(
      {Key key,
      this.id,
      this.name,
      this.imageUrl,
      this.price,
      this.productId,
      this.quantity,
      this.fullQuantity,
      this.dateDelivery});
  Map toMap() => {
        "id": id,
        "imageUrl": imageUrl,
        "name": name,
        "price": price,
        "quantity": quantity,
        //   "опт_w": opt,
        //   "мин_кол-во": min_kolvo,
      };

  CartItemModelState createState() => new CartItemModelState();
}

class CartItemModelState extends State<CartItemModel> {
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
                errorBuilder: (context, obj, stack) {
                  return Image.asset("lib/assets/loading_img.jpg");
                },
                image: FirebaseImage(widget.imageUrl),
                fit: BoxFit.fill,
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(
              height: 10,
              width: 20,
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
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: "${widget.price} руб \n\n",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300)),
                      if (widget.dateDelivery != "" &&
                          widget.dateDelivery != null)
                        TextSpan(
                            text: "Дата поставки: ${widget.dateDelivery} \n",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: "Кол-во: ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: widget.quantity.toString(),
                          style: TextStyle(
                              color: Colors.black,
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
