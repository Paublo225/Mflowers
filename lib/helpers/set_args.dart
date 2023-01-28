import 'package:flutter/material.dart';

class SetArgs extends StatefulWidget {
  final String kolvo;
  final String summa;
  final Function(String) onSelected;
  SetArgs({this.kolvo, this.summa, this.onSelected});

  @override
  _SetArgsState createState() => _SetArgsState();
}

class _SetArgsState extends State<SetArgs> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
      ),
      child: Row(
        children: [
          for (var i = 0; i < widget.kolvo.length; i++)
            GestureDetector(
              onTap: () {
                widget.onSelected("");
                setState(() {
                  _selected = i;
                });
              },
              child: Container(
                width: 42.0,
                height: 42.0,
                decoration: BoxDecoration(
                  color: _selected == i
                      ? Theme.of(context).accentColor
                      : Color(0xFFDCDCDC),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                child: Text(
                  "",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _selected == i ? Colors.white : Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
