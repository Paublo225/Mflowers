import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowers0/helpers/notification_badge.dart';
import 'package:flowers0/model/pushModel.dart';
import 'package:flowers0/order/orderslist.dart';
import 'package:flowers0/userpage/notification_page.dart';
import 'package:flowers0/userpage/settings.dart';
import 'package:flowers0/userpage/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class UserPage extends StatefulWidget {
  @override
  UserPageState createState() => new UserPageState();
}

class UserPageState extends State<UserPage> {
  int _totalNotificationCounter;
  PushNotification _notificationInfo;
  /*Future<void> _firebaseMessegingForegroundHandler() async {
    await Firebase.initializeApp();
    FirebaseMessaging _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
        alert: true, badge: true, provisional: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("access granted");
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification pushNotification = PushNotification(
            title: message.notification.title,
            body: message.notification.body,
            dataTitle: message.data['title'],
            dataBody: message.data['body']);
        setState(() {
          _totalNotificationCounter++;
          _notificationInfo = pushNotification;
        });
      });
      print("Total" + _totalNotificationCounter.toString());
    }
  }*/

  @override
  void initState() {
    super.initState();
    //_firebaseMessegingForegroundHandler();
  }

  @override
  void dispose() {
    super.dispose();
  }

  User user = FirebaseAuth.instance.currentUser;
  final imo = Image.network(
      "https://api.sbis.ru/retail/point/list?/img?params=eyJPYmplY3RUeXBlIjogInBvaW50IiwgIk9iamVjdElkIjogMTQwLCAiUGhvdG9VUkwiOiAiaHR0cDovL3N0b3JhZ2Uuc2Jpcy5ydS9hcGkvdjEvcmV0YWlsX2ZpbGVzLzJiZmQ1ZWEzLThkODgtNGE5MC05ZDkxLTQ0ODA1NDZlODIzMT9obWFjPTBlMDI1YzU2ZmVkOWE0YmY4ZDI2N2VmZWM3OTAwMWJmYzY5NDU0MTUmbW9kZT13cml0ZSIsICJQaG90b0lkIjogbnVsbCwgIlNpemUiOiBudWxsLCAiQWRkaXRpb25hbFBhcmFtcyI6IG51bGx9");
  @override
  Widget build(BuildContext context) {
    double heightB = MediaQuery.of(context).size.width / 7;
    double widthB = MediaQuery.of(context).size.width / 1.1;
    double fontSize = MediaQuery.of(context).size.width / 26;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "${user.email}",
                style: TextStyle(
                    //  fontFamily: 'Avenir next',
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (builder) => NotificationPage()));
              },
              child: Container(
                  // margin: EdgeInsets.only(top: 15, right: 20),
                  alignment: Alignment.centerRight,
                  child: Stack(children: [
                    Icon(
                      Icons.notifications_outlined,
                      size: 28,
                      color: Colors.black,
                    ),
                    _totalNotificationCounter != null
                        ? NotificationBadge(
                            totalNotifications: _totalNotificationCounter,
                          )
                        : SizedBox()
                  ])),
            )
          ]),
        ),
        body: Stack(children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            width: widthB,
                            height: heightB,
                            margin: EdgeInsets.only(top: 20),
                            child: RaisedButton(
                                /*shape: new RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.black),
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),*/
                                disabledColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              OrderHistory()));
                                },
                                child: Row(children: <Widget>[
                                  Icon(
                                    CupertinoIcons.cart,
                                    size: 36,
                                    color: Colors.black,
                                  ),
                                  Text(" История заказов",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black,
                                      ))
                                ])),
                          ),
                          new Container(
                            width: widthB,
                            height: heightB,
                            margin: EdgeInsets.only(top: 35),
                            child: RaisedButton(
                                disabledColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => SupportPage()));
                                },
                                child: Row(children: <Widget>[
                                  Icon(
                                    Icons.support_agent_sharp,
                                    size: 32,
                                    color: Colors.black,
                                  ),
                                  Text(" Поддержка",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black,
                                      ))
                                ])),
                          ),
                          new Container(
                            width: widthB,
                            height: heightB,
                            margin: EdgeInsets.only(top: 35),
                            child: RaisedButton(
                                disabledColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              SettingsPage()));
                                },
                                child: Row(children: <Widget>[
                                  Icon(
                                    CupertinoIcons.settings,
                                    size: 32,
                                    color: Colors.black,
                                  ),
                                  Text(" Настройки",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.black,
                                      ))
                                ])),
                          ),
                          new Container(
                            width: widthB,
                            height: heightB,
                            margin: EdgeInsets.only(top: 35),
                            child: RaisedButton(
                                disabledColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: Colors.white,
                                onPressed: () async => {
                                      _dialog(),
                                    },
                                child: Row(children: <Widget>[
                                  Icon(
                                    Icons.exit_to_app_outlined,
                                    size: 36,
                                    color: Colors.black,
                                  ),
                                  Text(" Выход",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          color: Colors.black))
                                ])),
                          ),
                          /* new Container(
                            width: widthB,
                            height: heightB,
                            margin: EdgeInsets.only(top: 35),
                            child: RaisedButton(
                                disabledColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (builder) => InternetIssuies()));
                                },
                                child: Row(children: <Widget>[
                                  Icon(
                                    Icons.money,
                                    size: 36,
                                    color: Colors.black,
                                  ),
                                  Text(" Яндекс касса",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: fontSize,
                                          color: Colors.black))
                                ])),
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // _footer(),
          //imo
        ]));
  }

  _dialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogcontext) {
        return AlertDialog(
            title: Center(child: Text('Выйти из системы')),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Вы уверены, что хотите выйти?",
                    textAlign: TextAlign.center,
                    style: TextStyle(),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          width: MediaQuery.of(dialogcontext).size.width * 0.25,
                          child: RaisedButton(
                              color: Colors.black,
                              child: Text(
                                'Да',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();

                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.of(dialogcontext).pop();
                                });

                                /* Navigator.pushReplacement(
                                    dialogcontext,
                                    CupertinoPageRoute(
                                        builder: (builder) => LandingPage()));*/
                                /*showCupertinoModalPopup(
                                    context: dialogcontext,
                                    barrierDismissible: false,
                                    builder: (BuildContext dcontext) {
                                      // FirebaseAuth.instance.signOut();

                                      return LandingPage();
                                    });*/
                              }),
                        ),
                      ]),
                  Column(children: [
                    Container(
                        // alignment: Alignment.centerRight,
                        // margin: EdgeInsets.only(ri: 20),
                        //height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(dialogcontext).size.width * 0.25,
                        child: RaisedButton(
                            child: Text('Отмена'),
                            onPressed: () {
                              Navigator.of(dialogcontext).pop();
                            })),
                  ]),
                ],
              )
            ]);
      },
    );
  }

  _footer() {
    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height - 300),
        height: 100,
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Divider(
                color: Colors.black26,
              ),
              Text(
                "Контакты",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "Email: flowers@mail.ru",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "Телефон: +7 (999)-99-987-99",
                style: TextStyle(fontSize: 12),
              )
            ])));
  }
}

class SizeConfig {
  static double _screenWidth;
  static double _screenHeight;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static double textMultiplier;
  static double imageSizeMultiplier;
  static double heightMultiplier;
  static double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;

    print(_blockSizeHorizontal);
    print(_blockSizeVertical);
  }
}
