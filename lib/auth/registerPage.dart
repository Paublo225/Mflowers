import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowers0/main.dart';
import 'package:flowers0/sevices/authentification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailControllerZ = TextEditingController();
  TextEditingController _nameControllerZ = TextEditingController();
  TextEditingController _firstPassControllerZ = TextEditingController();
  TextEditingController _secondPassControllerZ = TextEditingController();
  final AuthService _authService = AuthService();

  User user = FirebaseAuth.instance.currentUser;
  final String collectionPath = "технические_работы";

  Future<bool> checkIfVerifificetionIsNeeded() async {
    bool isVerNeeded = false;
    isVerNeeded = await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(collectionPath)
        .get()
        .then((value) => value.data()["верификация"]);
    debugPrint(isVerNeeded.toString());
    return isVerNeeded;
  }

  sendVerification() async {
    user = await _authService.registerWithEmailAndPassword(
        _emailControllerZ.text.trim(), _firstPassControllerZ.text.trim());
    user.updateDisplayName(_nameControllerZ.text);
    print(user.email);

    if (!await checkIfVerifificetionIsNeeded()) {
      debugPrint(' Успешная Регистрация ');
      Fluttertoast.showToast(
          msg: "Регистрация прошла успешно",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        _authService.logOut();
        print(' Верификация ');
        Fluttertoast.showToast(
            msg: "На вашу почту отправлено подтверждение",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    }
  }

  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<bool> fetchUsersEmails() async {
    List<String> emailList = [];
    await _fAuth
        .fetchSignInMethodsForEmail(_emailControllerZ.text)
        .then((value) => setState(() {
              emailList = value;
            }));
    if (emailList.isEmpty)
      return true;
    else
      return false;
  }

  _registerNewUser() async {
    if (await fetchUsersEmails()) {
      if (_firstPassControllerZ.text.length < 6) {
        Fluttertoast.showToast(
            msg: "Пароль должен содержать не менее 6 символов",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _firstPassControllerZ.clear();
        _secondPassControllerZ.clear();
      } else {
        if (_firstPassControllerZ.text != _secondPassControllerZ.text) {
          Fluttertoast.showToast(
              msg: "Пароли не совпадают",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          _firstPassControllerZ.clear();
          _secondPassControllerZ.clear();
        } else {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.red[100]),
                  ),
                );
              });
          await new Future.delayed(const Duration(seconds: 2), () async {
            sendVerification();
          });
          // ignore: missing_return

        }
      }
    } else {
      Fluttertoast.showToast(
          msg: "Пользователь уже зарегистрирован",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Widget inputBox(String title, Icon icon,
      TextEditingController texEditingController, TextInputType textInputType,
      {bool secure}) {
    return Container(
        padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
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
          onChanged: (value) => setState(() {}),
          cursorColor: mainColor,
          obscureText: secure != null ? secure : false,
          keyboardType: textInputType,
          autofocus: false,
          autocorrect: false,
          controller: texEditingController,
          decoration: InputDecoration(
            prefixIcon: icon,
            hintText: title,
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
  }

  Widget titleAbove(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      // margin: EdgeInsets.only(bottom: ),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.grey[900], fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget registerButton = GestureDetector(
      onTap: () async {
        _registerNewUser();
      },
      child: Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: _emailControllerZ.text != "" &&
                    _nameControllerZ.text != "" &&
                    _firstPassControllerZ.text != "" &&
                    _secondPassControllerZ.text != ""
                ? mainColor
                : Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                spreadRadius: 0.8,
                blurRadius: 0.1,
                offset: Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
              child: Text('Зарегистрироваться',
                  style: TextStyle(
                      color: _emailControllerZ.text != "" &&
                              _nameControllerZ.text != "" &&
                              _firstPassControllerZ.text != "" &&
                              _secondPassControllerZ.text != ""
                          ? Colors.white
                          : Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)))),
    );
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
          Expanded(
              child: ListView(children: [
            Padding(
                padding: EdgeInsets.only(left: 20, bottom: 20),
                child: Text(
                  "Регистрация",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                )),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
              child: Column(
                children: [
                  titleAbove("Как вас зовут?"),
                  inputBox(
                      "Имя",
                      Icon(
                        CupertinoIcons.person,
                        size: 28.0,
                        color: Colors.black45,
                      ),
                      _nameControllerZ,
                      TextInputType.name),
                  SizedBox(
                    height: 15,
                  ),
                  titleAbove("Ваша почта"),
                  inputBox(
                      "Почта",
                      Icon(
                        CupertinoIcons.mail,
                        size: 28.0,
                        color: Colors.black45,
                      ),
                      _emailControllerZ,
                      TextInputType.emailAddress),
                  SizedBox(
                    height: 15,
                  ),
                  titleAbove("Введите пароль"),
                  inputBox(
                      "Пароль",
                      Icon(
                        Icons.lock_outline,
                        size: 28.0,
                        color: Colors.black45,
                      ),
                      _firstPassControllerZ,
                      TextInputType.visiblePassword,
                      secure: true),
                  SizedBox(
                    height: 15,
                  ),
                  inputBox(
                      "Повторите пароль",
                      Icon(
                        Icons.lock,
                        size: 28.0,
                        color: Colors.black45,
                      ),
                      _secondPassControllerZ,
                      TextInputType.visiblePassword,
                      secure: true),
                  SizedBox(
                    height: 20,
                  ),
                  registerButton
                ],
              ),
            ),
          ]))
        ]));
  }
}
