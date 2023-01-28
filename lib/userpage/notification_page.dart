import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers0/main.dart';
import 'package:flowers0/order/orderscreen.dart';

import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flowers0/sevices/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);
  @override
  _NotificationPageState createState() => new _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  FirebaseServices _firebaseServices = FirebaseServices();
  UserServices _userServices = UserServices();
  List<NotificationModel> _globalNotifications = [];
  fetchAllNotifications() {
    _userServices.getGlobalNotifications().then((event) {
      setState(() {
        _globalNotifications.addAll(event);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllNotifications();
  }

  List<NotificationModel> _userNotifications = [
    NotificationModel(
        title: "Приветствуем у нас!",
        shortBody: "Узнайте про наше приложение здесь",
        body: "Lorem  ipsum")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                CupertinoSliverNavigationBar(
                  //  elevation: 0.0,
                  stretch: true,

                  largeTitle: Text(
                    "Уведомления",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  backgroundColor: Colors.white,
                  leading: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.transparent,
                          width: 50,
                          height: 50,
                          child: Icon(
                            CupertinoIcons.back,
                            size: 28.0,
                            color: Colors.pink[200],
                          ))),
                )
              ];
            },
            body: ListView.builder(
                shrinkWrap: true,
                itemCount: _globalNotifications.length,
                itemBuilder: (itemBuilder, i) {
                  return _globalNotifications[i];
                })));
  }
}

class NotificationModel extends StatefulWidget {
  static const ID = "id";
  static const TITLE = "title";
  static const BODY = "body";
  static const SHORT = "shortBody";
  static const PICTURE = "imgUrl";
  static const DATA = "dataCreated";

  String id;
  Timestamp datatime;
  String title;
  String body;
  String shortBody;
  String imgUrl;
  NotificationModel({this.title, this.body, this.shortBody});
  NotificationModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot.data()[TITLE];
    body = snapshot.data()[BODY];
    shortBody = snapshot.data()[SHORT];
    imgUrl = snapshot.data()[PICTURE];
    datatime = snapshot.data()[DATA];
  }
  _NotificationModelState createState() => new _NotificationModelState();
}

class _NotificationModelState extends State<NotificationModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListTile(
          shape: Border(bottom: BorderSide(color: Colors.grey, width: 0.6)),
          selectedTileColor: Colors.white,
          title: Text(widget.title),
          trailing: Icon(Icons.arrow_right),
          subtitle: Text(widget.shortBody),
          onTap: () {
            showCupertinoModalBottomSheet(
                context: context,
                builder: (context) {
                  return NotificationInfo(
                    title: widget.title,
                    shortBody: widget.shortBody,
                    body: widget.body,
                    imgUrl: widget.imgUrl,
                  );
                });
          },
        ));
  }
}

class NotificationInfo extends StatefulWidget {
  String title;
  String body;
  String shortBody;
  String imgUrl;
  NotificationInfo({this.title, this.body, this.shortBody, this.imgUrl});
  _NotificationInfoState createState() => new _NotificationInfoState();
}

class _NotificationInfoState extends State<NotificationInfo> {
  double _imgheight = 250.00;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: Center(
                      child: Icon(
                    Icons.close,
                    color: mainColor,
                    size: 20,
                  ))),
            )),
        body: Column(
          children: [
            if (widget.imgUrl != null || widget.imgUrl != "")
              Container(
                  color: Colors.white,
                  height: _imgheight,
                  width: double.infinity,
                  child: Center(
                      child: Hero(
                          tag: "assetPath",
                          child: Image.network(widget.imgUrl,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.pink[100]),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Text('Попробуйте перезагрузить'),
                              height: _imgheight,
                              width: double.infinity,
                              fit: BoxFit.fill)))),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(5),
              child: Text(
                widget.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(5),
              child: Text(widget.body,
                  style: TextStyle(
                    fontSize: 15,
                  )),
            ),
          ],
        ));
  }
}
