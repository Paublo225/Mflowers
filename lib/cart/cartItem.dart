import 'package:firebase_image/firebase_image.dart';

import 'package:flowers0/model/product.dart';
import 'package:flowers0/model_screen/item_screen.dart';

import 'package:flowers0/sevices/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CartPageItem extends StatefulWidget {
  List<ProductModel> products;

  CartPageItem({Key key, this.products}) : super(key: key);
  _CartPageItemState createState() => new _CartPageItemState();
}

class _CartPageItemState extends State<CartPageItem> {
  List<ProductModel> _products = [];
  PageController _pageController;
  ProductServices _productServices = ProductServices();
  fetchProductsbyID() {
    _productServices.getProductsbyID().then((value) {
      setState(() {
        widget.products.addAll(value);
      });
      print("object");
      print(value);
    });
  }

  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (ProductModel pr in widget.products)
      return GestureDetector(
          onTap: () {
            /////////
            showBarModalBottomSheet(
                expand: true,
                context: context,
                builder: (context) => FlowerScreen(
                      product: pr,
                    ));
          },
          child: new Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              /*  userpr.changeLoading();
                                print(document.id);
                                convertedCart.clear();
                                _summavsego.remove(document["summa"]);
                                _summavsego = [];
                                _summary -= document["summa"];
                                _firebaseServices.usersRef
                                    .doc(_firebaseServices.getUserId())
                                    .collection("cart")
                                    .doc(document.id)
                                    .delete();
                                userpr.changeLoading();*/
            },
            child: /*Column(
                                          children: [
                                            for (int i = 0;
                                                i < cartItemModel.length;
                                                i++)
                                              cartItemModel[i],
                                            if (cartEmptyModel.length > 0)
                                              for (int i = 0;
                                                  i < cartItemModel.length;
                                                  i++)
                                                cartEmptyModel[i]
                                          ],
                                        )*/

                Padding(
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
                        image: FirebaseImage(pr.imageUrl),
                        fit: BoxFit.fill,
                        width: 100,
                        height: 100,
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
                          Container(
                              width: MediaQuery.of(context).size.width - 190,
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: pr.name + "\n",
                                      style: TextStyle(
                                          color: (int.parse(pr.quantity) >= 2)
                                              ? Colors.black
                                              : Colors.black38,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: "${2} руб \n\n",
                                      style: TextStyle(
                                          color: (int.parse(pr.quantity) >= 2)
                                              ? Colors.black
                                              : Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300)),
                                  TextSpan(
                                      text: (int.parse(pr.quantity) >= 2)
                                          ? "Кол-во: ${2}"
                                          : "Нет в наличии",
                                      style: TextStyle(
                                          color: (int.parse(pr.quantity) >= 2)
                                              ? Colors.black
                                              : Colors.redAccent,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400)),
                                ]),
                              )),
                          IconButton(
                              icon: Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.pink[100],
                              ),
                              onPressed: () async {
                                /*   userpr.changeLoading();
                                print(document.id);
                                convertedCart.clear();
                                _summavsego.remove(document["summa"]);
                                _summavsego = [];
                                _summary -= document["summa"];
                                await _firebaseServices.usersRef
                                    .doc(_firebaseServices.getUserId())
                                    .collection("cart")
                                    .doc(document.id)
                                    .delete();
                                userpr.changeLoading();*/
                              })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
    return Container(
      width: 0,
      height: 0,
    );
  }
}
