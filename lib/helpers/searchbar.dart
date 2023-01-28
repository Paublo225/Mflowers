import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget {
  bool folded;
  AnimatedSearchBar({Key key, this.folded}) : super(key: key);
  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool _folded = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: widget.folded ? 45 : 200,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.pink[100],
        // boxShadow: kElevationToShadow[6],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: !widget.folded
                  ? TextField(
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                          hoverColor: Colors.white,
                          hintText: 'Поиск',
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.white),
                          border: InputBorder.none),
                    )
                  : null,
            ),
          ),
          Container(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.folded ? 32 : 0),
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(widget.folded ? 32 : 0),
                  bottomRight: Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    widget.folded ? Icons.search : Icons.close,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  setState(() {
                    widget.folded = !widget.folded;
                  });
                  //  print(widget.folded);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
