import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers0/main.dart';
import 'package:flowers0/sevices/firebase_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);
  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User user = FirebaseAuth.instance.currentUser;

  TextEditingController _pass1Contr = TextEditingController();
  TextEditingController _pass2Contr = TextEditingController();
  String _pass1;
  String _pass2;
  String _name = "Пользователь";
  String _email = "";

  bool _onChangedLine = false;

  FirebaseServices _firebaseServices = FirebaseServices();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool exist = false;

  void checkExist() async {
    await _firebaseServices.usersRef
        .doc("${_firebaseServices.getUserId()}")
        .get()
        .then((doc) {
      if (doc.data()["имя"] != null) {
        setState(() {
          exist = true;
          print(exist);
        });
      } else
        setState(() {
          exist = false;
          print(exist);
        });
    });
  }

  _getName() async {
    await _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .get()
        .then((value) async {
      if (exist == false) {
        if (user.displayName.isNotEmpty)
          await _firebaseServices.usersRef
              .doc(_firebaseServices.getUserId())
              .set({"имя": user.displayName});
        else {
          await _firebaseServices.usersRef
              .doc(_firebaseServices.getUserId())
              .set({"имя": "Пользователь"});
          user.updateDisplayName("Пользователь");
        }
      }
      setState(() {
        _name = value.data()["имя"];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkExist();

    _getName();
    setState(() {
      _email = user.email;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightB = MediaQuery.of(context).size.width / 7;
    double widthB = MediaQuery.of(context).size.width / 1.1;
    double fontSize = MediaQuery.of(context).size.width / 26;

    titleText(String title) {
      return Padding(
        padding: EdgeInsets.only(
          left: 5.0,
          top: 10,
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    final email = Container(
        //padding: EdgeInsets.only(top: ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(bottom: BorderSide()),
        ),
        child: TextFormField(
          //keyboardType: TextInputType.emailAddress,
          readOnly: true,
          autofocus: false,
          onChanged: (value) {
            setState(() {
              _onChangedLine = true;
            });
          },
          autocorrect: false,
          cursorColor: mainColor,
          controller: _emailController,
          decoration: InputDecoration(
            hintText: _email,
            hintStyle: TextStyle(color: Colors.black),
            contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 10.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.0),
                borderSide: BorderSide(color: Colors.transparent)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.0),
                borderSide: BorderSide(color: Colors.red)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
        ));
    final name = Container(
        //padding: EdgeInsets.only(top: ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(bottom: BorderSide()),
        ),
        child: TextFormField(
          //keyboardType: TextInputType.emailAddress,
          autofocus: false,
          autocorrect: false,
          cursorColor: mainColor,
          controller: _nameController,
          onChanged: (value) {
            setState(() {
              _onChangedLine = true;
            });
          },
          decoration: InputDecoration(
            hintText: user.displayName,
            hintStyle: TextStyle(color: Colors.black),
            contentPadding: EdgeInsets.fromLTRB(5.0, 10.0, 20.0, 10.0),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.0),
                borderSide: BorderSide(color: Colors.transparent)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13.0),
                borderSide: BorderSide(color: Colors.red)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
        ));

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
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: EdgeInsets.only(left: 20, bottom: 20),
            child: Text(
              "Настройки",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            )),
        Container(
          //shrinkWrap: true,
          //height: MediaQuery.of(context).size.height / 2,
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 12.0,
            right: 24.0,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5.0),
                titleText("Имя"),
                name,
                Center(
                    child: Container(
                  // alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 20),
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: _emailController.text != "" ||
                                _nameController.text != ""
                            ? mainColor
                            : Colors.white),
                    onPressed: () {
                      //  if (_emailController.text != "" || _emailController.text != null)
                      // _emailChange();
                      //   if (_nameController.text != "" || _nameController.text != null)
                      _nameChange();
                    },
                    child: Text(
                      "Изменить",
                      style: TextStyle(
                          color: _emailController.text != "" ||
                                  _nameController.text != ""
                              ? Colors.white
                              : Colors.black54),
                    ),
                  ),
                )),
                SizedBox(height: 8.0),
                titleText("Почта"),
                email,
                SizedBox(height: 15.0),
                Container(
                  // alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 5, bottom: 10),
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Scaffold(
                                body: Column(
                              children: [
                                Row(children: [
                                  GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                          color: Colors.transparent,
                                          width: 50,
                                          height: 50,
                                          child: Icon(
                                            Icons.close,
                                            size: 28.0,
                                            color: Colors.pink[200],
                                          ))),
                                  Center(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: Text(
                                          "Сменить пароль",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        )),
                                  )
                                ]),
                                SizedBox(
                                  height: 5,
                                ),
                                new Container(
                                    width: widthB,
                                    height: heightB,
                                    padding: EdgeInsets.only(
                                      left: 15.0,
                                    ),
                                    child: TextField(
                                      obscureText: true,
                                      controller: _pass1Contr,
                                      decoration: InputDecoration(
                                        fillColor: mainColor,
                                        focusColor: mainColor,
                                        hoverColor: mainColor,
                                        labelText: "Новый пароль",
                                      ),
                                    )),
                                new Container(
                                    width: widthB,
                                    height: heightB,
                                    padding: EdgeInsets.only(
                                      left: 15.0,
                                    ),
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 15),
                                    child: TextField(
                                      controller: _pass2Contr,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: "Повторите пароль",
                                      ),
                                    )),
                                Center(
                                    child: Container(
                                  // alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 20),
                                  width: 120,
                                  height: 40,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white),
                                    onPressed: () {
                                      _passChange();
                                    },
                                    child: Text(
                                      "Изменить",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ))
                              ],
                            ));
                          });
                    },
                    child: Text(
                      "Сменить пароль",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /* new Container(
            width: widthB,
            height: heightB,
            padding: EdgeInsets.only(
              left: 15.0,
            ),
            child: TextField(
              obscureText: true,
              controller: _mailContr,
              decoration: InputDecoration(
                fillColor: mainColor,
                focusColor: mainColor,
                hoverColor: mainColor,
                labelText: "Новый пароль",
              ),
            )),
        new Container(
            width: widthB,
            height: heightB,
            padding: EdgeInsets.only(
              left: 15.0,
            ),
            margin: EdgeInsets.only(top: 10, bottom: 15),
            child: TextField(
              controller: _passContr,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Повторите пароль",
              ),
            )),;ъ*/
        /*  Center(
            child: Container(
          // alignment: Alignment.center,
          margin: EdgeInsets.only(top: 20),
          width: 120,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary:
                    _emailController.text != "" || _nameController.text != ""
                        ? mainColor
                        : Colors.white),
            onPressed: () {
              //  if (_emailController.text != "" || _emailController.text != null)
              // _emailChange();
              //   if (_nameController.text != "" || _nameController.text != null)
              _nameChange();
            },
            child: Text(
              "Изменить",
              style: TextStyle(
                  color:
                      _emailController.text != "" || _nameController.text != ""
                          ? Colors.white
                          : Colors.black54),
            ),
          ),
        ))*/
      ]),
    );
  }

  _passChange() async {
    _pass1 = _pass1Contr.text;
    _pass2 = _pass2Contr.text;

    if (_pass1.isEmpty || _pass1.isEmpty) return;
    if (_pass1 != _pass2) {
      Fluttertoast.showToast(
          msg: "Пароль не совпадает",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    if (_pass1 == _pass2) {
      if (_pass2.length >= 6) {
        user.updatePassword(_pass2).then((_) {
          print("Successfully changed password");
        }).catchError((error) {
          print("Password can't be changed" + error.toString());
          //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
        });

        Fluttertoast.showToast(
            msg: "Пароль успешно изменен",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else
        Fluttertoast.showToast(
            msg: "Пароль должен содержать не менее 6 символов",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
    }
  }

  _nameChange() async {
    _name = _nameController.text;
    // _pass2 = _pass2Contr.text;

    if (_name.isEmpty)
      return;
    else {
      await _firebaseServices.usersRef
          .doc(_firebaseServices.getUserId())
          .update({"имя": _name});
      user.updateDisplayName(_name);
      Fluttertoast.showToast(
          msg: "Имя успешно изменено",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  _emailChange() async {
    _email = _emailController.text;
    // _pass2 = _pass2Contr.text;

    if (_email.isEmpty)
      return;
    else {
      User firebaseUser = FirebaseAuth.instance.currentUser;
      firebaseUser.updateEmail(_email).then((_) {
        print("Successfully changed email");
        Fluttertoast.showToast(
            msg: "На почту придет уведомление",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }).catchError((error) {
        print("Email can't be changed" + error.toString());
        Fluttertoast.showToast(
            msg: "Произошла ошибка.\nПопробуйте еще раз",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            // webPosition: "center",
            fontSize: 16.0);
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    }
  }
}
