import 'package:flowers0/provider/connection_provider.dart';
import 'package:flowers0/provider/user_pr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InternetIssuies extends StatefulWidget {
  const InternetIssuies({Key key}) : super(key: key);

  @override
  _InternetIssuiesState createState() => _InternetIssuiesState();
}

class _InternetIssuiesState extends State<InternetIssuies> {
  TextStyle _textStyle = const TextStyle(
    color: Colors.black45,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  TextStyle _textStyleBtn = const TextStyle(
    color: Colors.black45,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  void updateUI() {
    setState(() {
      ConnectivityProvider().startMonitoring();
      //You can also make changes to your state here.
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //Provider.of<ConnectivityProvider>(context, listen: false).dispose();
    super.dispose();
    //_InternetIssuiesState().dispose();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("lib/assets/internet_check.png"))),
          ),
          Text(
            "Упс. Какие-то проблемы с соединением.\nПопробуйте обновить или подключиться к сети.",
            textAlign: TextAlign.center,
            style: _textStyle,
          ),
          GestureDetector(
            onTap: () {
              print("refreshed");
            },
            child: Container(
              margin: EdgeInsets.only(top: 45),
              width: 90,
              height: 40,
              child: Center(
                child: Text(
                  "Обновить",
                  style: _textStyleBtn,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black54)),
            ),
          )
        ],
      ),
    ));
  }
}
