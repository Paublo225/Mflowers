import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class PayMethod extends StatefulWidget {
  PayMethod({Key key}) : super(key: key);
  @override
  _PayMethodState createState() => new _PayMethodState();
}

class _PayMethodState extends State<PayMethod> {
  List<MethodPay> methodList = [
    MethodPay(" Apple Pay", AssetImage("lib/assets/applepay.png"), false),
    MethodPay(" Картой", AssetImage("lib/assets/credit.png"), false),
    MethodPay(" Наличными", AssetImage("lib/assets/wallet.png"), true),
  ];
  int _selectedIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(left: 20, bottom: 20),
              child: Text(
                "Способы оплаты",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              )),
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height / 3,
            child: ListTileTheme(
                selectedColor: Colors.pink[200],
                child: ListView(
                  children: List.generate(methodList.length, (index) {
                    return ListTile(
                        subtitle:
                            Divider(thickness: 0.5, color: Colors.grey[600]),
                        focusColor: Colors.pink[200],
                        selected: index == _selectedIndex,
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                            //  methodList[index].selected = value;
                          });
                        },
                        title: Row(
                          children: [
                            Image(
                              image: methodList[index].iconData,
                              width: 35,
                              height: 35,
                            ),
                            Text(methodList[index].title),
                          ],
                        ));
                    //value: methodList[index].selected);
                  }),
                )),
          ),
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              "В настоящий момент доступен только способ оплаты наличными",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          ))
        ],
      ),
    );
  }
}

class MethodPay {
  final String title;
  final AssetImage iconData;
  bool selected;
  MethodPay(this.title, this.iconData, this.selected);
}
