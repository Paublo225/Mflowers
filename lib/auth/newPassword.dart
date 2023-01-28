import 'package:flowers0/main.dart';
import 'package:flowers0/sevices/authentification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewPassPage extends StatefulWidget {
  NewPassPage({Key key}) : super(key: key);
  @override
  _NewPassPageState createState() => new _NewPassPageState();
}

class _NewPassPageState extends State<NewPassPage> {
  TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  String _email;

  _resetPassword() async {
    _email = _emailController.text;

    if (_email.isEmpty)
      return;
    else {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
      // if (user == null)
      /*Fluttertoast.showToast(
          msg: "Проверьте вашу почту",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);*/
      // else {
      Fluttertoast.showToast(
          msg: "Пароль отправлен на почту",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pop(context);
      //   _emailController.clear();
      //   _passwordController.clear();
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final email = Container(
        // padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.8,
              blurRadius: 0.1,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: TextFormField(
          cursorColor: mainColor,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          autocorrect: false,
          controller: _emailController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
            hintText: 'Почта',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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

    final passResetBtn = GestureDetector(
      onTap: () {
        _resetPassword();
      },
      child: Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0.8,
                blurRadius: 0.1,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
              child: Text('Сбросить пароль',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)))),
    );

    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
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
        body: Center(
            child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
          child: Column(
            children: [
              Expanded(
                  child: ListView(children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text(
                    "Введите почту",
                    style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                email,
                SizedBox(
                  height: 10,
                ),
                passResetBtn
              ]))
            ],
          ),
        )));
  }
}
