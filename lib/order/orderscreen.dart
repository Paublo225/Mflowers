import 'package:firebase_image/firebase_image.dart';
import 'package:flowers0/model/product.dart';
import 'package:flowers0/model_screen/item_screen.dart';
import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flowers0/sevices/product.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class OrderScreen extends StatefulWidget {
  String orderID;
  int indexs;
  String title;
  OrderScreen({this.orderID, this.title, this.indexs});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with AutomaticKeepAliveClientMixin<OrderScreen> {
  int count = 0;
  FirebaseServices _firebaseServices = FirebaseServices();
  ProductServices _productServices = ProductServices();
  List<ProductModel> _productList = [];
  fetchAllOrder(String id) {
    _productServices.getOrderProducts(id).then((value) {
      setState(() {
        _productList.addAll(value);
      });
    });
    print(_productList);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print(_productList);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          title: Text(
            "Заказ",
            style: TextStyle(color: Colors.black),
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
        ),
        body: Stack(children: [
          FutureBuilder(
            future: _firebaseServices.orderRef.doc(widget.orderID).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map _productMap = snapshot.data.data();
                var mapl = _productMap["заказ"];

                return Column(children: [
                  Container(
                    height: 50,
                    child: ListTile(
                      title: Text("Номер заказа"),
                      subtitle: Text(widget.orderID),
                    ),
                  ),
                  Container(
                    height: 50,
                    // padding: EdgeInsets.only(bottom: 30),
                    child: ListTile(
                      title: Text("Время"),
                      subtitle:
                          Text("${_productMap["time"]} ${_productMap["date"]}"),
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(bottom: 30),
                    child: ListTile(
                      title: Text("Итог"),
                      subtitle: Text(_productMap["total"].toString()),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: mapl.length,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              FutureBuilder(
                                  future: _firebaseServices.productsRef
                                      .doc(mapl[index]["id"])
                                      .get(),
                                  builder: (context, productSnap) {
                                    if (productSnap.connectionState ==
                                        ConnectionState.done) {
                                      Map _productMapZ =
                                          productSnap.data.data();
                                      return GestureDetector(
                                          onTap: () {
                                            showBarModalBottomSheet(
                                                expand: true,
                                                context: context,
                                                builder: (context) =>
                                                    FlowerScreen(
                                                      id: mapl[index]["id"],
                                                      imageUrl: _productMapZ[
                                                          "imageUrl"],
                                                      name:
                                                          _productMapZ["name"],
                                                      price:
                                                          _productMapZ["price"],
                                                      quantity: _productMapZ[
                                                          "quantity"],
                                                      opt: _productMapZ["опт"],
                                                      qpak:
                                                          _productMapZ["qpak"],
                                                      description: _productMapZ[
                                                          "description"],
                                                      producer: _productMapZ[
                                                          "производитель"],
                                                      length:
                                                          _productMapZ["длина"],
                                                      sort:
                                                          _productMapZ["сорт"],
                                                      deliveryDate:
                                                          _productMapZ[
                                                              "дата_поставки"],
                                                    ));
                                          },
                                          child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Container(
                                                height: 100,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Image(
                                                        errorBuilder: (context,
                                                            obj, stack) {
                                                          return Image.asset(
                                                              "lib/assets/loading_img.jpg");
                                                        },
                                                        image: FirebaseImage(
                                                            mapl[index]
                                                                ["imageUrl"]),
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
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          RichText(
                                                            text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                      text: mapl[index]
                                                                              [
                                                                              "name"] +
                                                                          "\n",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                  TextSpan(
                                                                      text:
                                                                          "${mapl[index]["price"]} руб \n\n",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w300)),
                                                                  TextSpan(
                                                                      text:
                                                                          "Кол-во: ",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w400)),
                                                                  TextSpan(
                                                                      text: mapl[index]
                                                                              [
                                                                              "quantity"]
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w400)),
                                                                ]),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )));
                                    }
                                    return Container(
                                      child: Center(child: Text("")),
                                    );
                                  })
                            ]);
                          })),
                ]);
              }
              return Scaffold(
                body: Center(
                    child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.pink[100]),
                )),
              );
            },
          ),
        ]));
  }

  @override
  bool get wantKeepAlive => true;
}
