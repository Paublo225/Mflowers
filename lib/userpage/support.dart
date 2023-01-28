import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowers0/sevices/authentification.dart';
import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class SupportPage extends StatefulWidget {
  SupportPage({Key key}) : super(key: key);
  @override
  _SupportPageState createState() => new _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  FirebaseServices _firebaseServices = FirebaseServices();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  String whatsAppNumber = "";
  String whatsAppText = "";
  String contactInformation = "";
  String contactEmail = "";
  String collectionContacts = "контактная_информация";

  AuthService _auth = new AuthService();
  String userUID =
      FirebaseAuth.instance.currentUser.uid.toUpperCase().substring(0, 3);
  _getWhatsAppInfo() async {
    await firebaseFirestore
        .collection(collectionContacts)
        .doc("whatsapp")
        .get()
        .then((value) {
      setState(() {
        whatsAppNumber = value.data()["номер"];
        whatsAppText = value.data()["текст"];
      });
    });
  }

  _getContactInfo() async {
    await firebaseFirestore
        .collection(collectionContacts)
        .doc("текст")
        .get(GetOptions(source: Source.cache))
        .then((value) {
      setState(() {
        contactInformation = value.data()["контакты"];
        contactEmail = value.data()["почта"];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getContactInfo();
    _getWhatsAppInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _launched;

  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  openwhatsapp() async {
    var whatsappURlandroid = "whatsapp://send?phone=" +
        whatsAppNumber.toString() +
        "&text=$whatsAppText";
    var whatappURLios =
        "https://wa.me/${whatsAppNumber.toString()}/?text=${Uri.encodeFull("$whatsAppText")}";
    // "https://api.whatsapp.com/send?phone=$whatsAppNumber=${Uri.parse(whatsAppText)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURLios)) {
        await launch(whatappURLios, forceSafariVC: true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("What's app не установлен")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlandroid)) {
        await launch(whatsappURlandroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("What's app не установлен")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightB = MediaQuery.of(context).size.width / 7;
    double widthB = MediaQuery.of(context).size.width / 1.1;
    double fontSize = MediaQuery.of(context).size.width / 26;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                "Поддержка",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              )),
          Container(
              //color: Colors.grey,
              margin: EdgeInsets.only(top: 10),
              //height: MediaQuery.of(context).size.height / 0.2,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /* new Container(
                    width: widthB,
                    height: heightB,
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: RaisedButton(
                        disabledColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        color: Colors.white,
                        onPressed: () {
                          print("object");
                        },
                        child: Row(children: <Widget>[
                          Icon(
                            CupertinoIcons.cube_box,
                            size: 32,
                            color: Colors.black54,
                          ),
                          Text(" Доставка",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: fontSize,
                                color: Colors.black,
                              ))
                        ])),
                  ),*/
                  /* new Container(
                    width: widthB,
                    height: heightB,
                    margin: EdgeInsets.only(top: 35, bottom: 10),
                    child: RaisedButton(
                        disabledColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        color: Colors.white,
                        onPressed: () {
                          print("object");
                        },
                        child: Row(children: <Widget>[
                          Icon(
                            CupertinoIcons.creditcard,
                            size: 32,
                            color: Colors.black54,
                          ),
                          Text(" Возврат/Оплата",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: fontSize,
                                color: Colors.black,
                              ))
                        ])),
                  ),*/
                  new Container(
                    width: widthB,
                    height: heightB,
                    margin: EdgeInsets.only(top: 35, bottom: 30),
                    child: RaisedButton(
                        disabledColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        color: Colors.white,
                        onPressed: () {
                          _getWhatsAppInfo();
                          print(whatsAppNumber);
                          print(whatsAppText);
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext dialogcontext) =>
                                CupertinoActionSheet(
                              title: const Text('Написать в поддержку'),
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('Отмена'),
                                onPressed: () {
                                  Navigator.pop(dialogcontext);
                                },
                              ),
                              actions: <CupertinoActionSheetAction>[
                                CupertinoActionSheetAction(
                                  child: const Text("What's app"),
                                  onPressed: () {
                                    openwhatsapp();
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text("Почта"),
                                  onPressed: () {
                                    setState(() {
                                      String uidv1 = Uuid()
                                          .v1()
                                          .toString()
                                          .toUpperCase()
                                          .substring(0, 4);
                                      _launched = _openUrl(
                                          'mailto:$contactEmail?subject=${Uri.encodeFull("Обращение №$userUID-$uidv1")}&body=${Uri.encodeFull("Здравствуйте! ")}');
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Row(children: <Widget>[
                          Icon(
                            Icons.support,
                            size: 32,
                            color: Colors.black54,
                          ),
                          Text(" Написать в поддержку",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: fontSize,
                                color: Colors.black,
                              ))
                        ])),
                  ),
                  Text(
                    "Контакты",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    contactInformation.replaceAll("\\n", "\n"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
