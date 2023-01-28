import 'package:flowers0/auth/newPassword.dart';
import 'package:flowers0/auth/registerPage.dart';
import 'package:flowers0/main.dart';
import 'package:flowers0/sevices/authentification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);
  @override
  _AuthPageState createState() => new _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthService _authService = AuthService();
  final FirebaseAuth _fSAuth = FirebaseAuth.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _email;
  String _password;
  bool showLogin = true;

  Future<User> createUser() async {
    UserCredential uz;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: "barry.allen@example.com",
              password: "SuperSecretPassword!");
      uz = userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  _signInButtonAction() async {
    _email = _emailController.text;
    _password = _passwordController.text;
    AlertDialog alert = AlertDialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        content: Center(
            child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink[100]),
        )));

    /* showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return alert;
      },
    );*/
    if (_email.isEmpty || _password.isEmpty) return;
    User user = await _authService.signInWithEmailAndPassword(
        _email.trim(), _password.trim());
    if (user == null)
      Fluttertoast.showToast(
          msg: "Проверьте вашу почту или пароль",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    else {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        Fluttertoast.showToast(
            msg:
                "На вашу почту отправлено подтверждение.\nДля входа подтвердите вашу почту",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Вход выполнен",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        //   _emailController.clear();
        //   _passwordController.clear();

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('lib/assets/logo.png'),
      ),
    );

    final email = Container(
        //padding: EdgeInsets.only(top: ),
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
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          autocorrect: false,
          cursorColor: mainColor,
          controller: _emailController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person_outlined,
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

    final password = Container(
        padding: EdgeInsets.only(top: 15),
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
          obscureText: true,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          autocorrect: false,
          controller: _passwordController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.grey,
            ),
            hintText: 'Пароль',
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
    showAlertDialog(BuildContext context) {
      AlertDialog alert = AlertDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          content: Center(
              child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.pink[100]),
          )));

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop(true);
          });
          return alert;
        },
      );
    }

    final loginButton = GestureDetector(
      onTap: () {
        //  showAlertDialog(context);

        _signInButtonAction();
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
              child: Text('Войти',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)))),
    );

    final registerButton = GestureDetector(
      onTap: () {
        //  showAlertDialog(context);
        Navigator.push(
            context, CupertinoPageRoute(builder: (builder) => RegisterPage()));
        //   _signInButtonAction();
      },
      child: Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0.8,
                blurRadius: 0.1,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
              child: Text('Создать профиль',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)))),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Забыли пароль?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        showModalBottomSheet(
            context: context, builder: (builder) => NewPassPage());
      },
    );

    return Theme(
        data: ThemeData(
          bottomAppBarColor: Colors.lightBlue,
          backgroundColor: Colors.lightBlue,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
                //shrinkWrap: true,
                //height: MediaQuery.of(context).size.height / 2,
                width: double.infinity,
                padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 50),
                child: Center(
                    child: Column(children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: [
                        logo,
                        SizedBox(height: 48.0),
                        email,
                        SizedBox(height: 8.0),
                        password,
                        SizedBox(height: 24.0),
                        loginButton,
                        SizedBox(height: 8.0),
                        registerButton,
                        SizedBox(height: 14.0),
                        forgotLabel
                      ],
                    ),
                  ),
                ])))));
  }
}
