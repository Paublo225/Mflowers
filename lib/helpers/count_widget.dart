import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CountWidget extends StatefulWidget {
  final Function(int) onSelected;
  final Function(int) onSelected1;
  final Function(int) onSelected2;
  int quantity;
  int count;
  int price;
  int kolvo;
  int minkolvo;
  List<dynamic> optKolvo;
  List<dynamic> optPrices;
  Map<dynamic, dynamic> opt;

  CountWidget(
      {this.onSelected,
      this.count,
      this.price,
      this.kolvo,
      this.onSelected1,
      this.onSelected2,
      this.quantity,
      this.minkolvo,
      this.opt,
      this.optKolvo,
      this.optPrices});

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget>
    with AutomaticKeepAliveClientMixin<CountWidget> {
  int st;
  @override
  void initState() {
    super.initState();

    st = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    int _selected = widget.kolvo != null ? widget.kolvo : widget.count;
    int _price = widget.price;
    int start = st;
    return Row(
      children: <Widget>[
        /////MINUS///////
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(40, 25),
              minimumSize: Size(5, 5),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(4.0),
              ),
              primary: Colors.white,
              // disabledBackgroundColor: Colors.white,
            ),
            onPressed: () {
              if (widget.count >= start) {
                setState(() {
                  _selected -= start;

                  widget.count = _selected;
                  widget.kolvo = _selected;
                  // widget.price = _price;
                  print("EYO $_price");
                  // print(_selected);
                  //  print(widget.kolvo);
                  print(start);
                  // summa = widget.price / _selected;
                });
                widget.onSelected1(_selected);
              }
              if (widget.minkolvo != null) {
                setState(() {
                  _selected = widget.minkolvo;
                  widget.count = _selected;
                  widget.kolvo = _selected;
                });
                widget.onSelected1(_selected);
              }
            },
            child:
                Text("-", style: TextStyle(fontSize: 20, color: Colors.grey))),
        SizedBox(
          width: 10,
        ),
        Center(
            child: Text(widget.kolvo.toString(),
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height / 40,
                    //    fontWeight: FontWeight.w600,
                    color: Colors.white))),
        /*SizedBox(
                    width: MediaQuery.of(context).size.height / 10,
                    height: MediaQuery.of(context).size.height / 20,
                    child: OutlineButton(
                        disabledBorderColor: Colors.black,
                        onPressed: null,
                        child: Text("${widget.count}",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 40,
                                color: Colors.black)))),*/
        SizedBox(
          width: 10,
        ),

        /////PLUS//////
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(40, 25),
              minimumSize: Size(5, 5),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(4.0),
              ),
              primary: Colors.white,
              // disabledBackgroundColor: Colors.white,
            ),
            onPressed: () {
              if (widget.quantity - start >= _selected) {
                setState(() {
                  // if(_selected <= widget.optKolvo[2])

                  _selected = _selected + start;
                  print("EYO $_price");
                  widget.count = _selected;
                  widget.kolvo = _selected;
                  // summa = _price * kolvo;
                  print(_selected);
                });
                widget.onSelected(_selected);
              }
            },
            child:
                Text("+", style: TextStyle(fontSize: 20, color: Colors.grey))),
        SizedBox(
          width: 20,
        ),

        _sumCount(widget.kolvo != null ? widget.kolvo : _selected,
            widget.kolvo != null ? widget.kolvo * _price : _price, widget.opt)
      ],
    );
  }

  _sumCount(
    int _selected,
    int _price,
    Map<dynamic, dynamic> opt,
  ) {
    _price = widget.price;
    opt.keys.toList(growable: false).sort();
    //opt.update(key, (value) => null)
    opt.values.toList().sort();
    // print(opt);

    opt.forEach((key, value) {
      ////////PLUS//////////

      if (_selected >= int.parse(key)) {
        print(key);
        setState(() {
          _price = value;
          widget.onSelected2(_price);
        });
        // _price = value;
      }
      if (_selected >= int.parse(opt.keys.first))
        setState(() {
          _price = opt.values.first;
          widget.onSelected2(_price);
        });
////////////////////////////////////////////////////

      if (_selected < int.parse(opt.keys.toList()[1])) {
        setState(() {
          _price = widget.price;
          widget.onSelected2(_price);
        });
        print("start");
        print(_price);
      }
      // widget.onSelected2(_price);
    });

    List k = [];
    opt.keys.forEach((element) {
      k.add(int.parse(element));
    });
    List v = opt.values.toList();
    k.sort();
    v.sort((b, a) => a.compareTo(b));
    //print(k);
    //print(v);

    for (int i = 0; i < k.length; i++) {
      if (_selected >= k[i]) {
        setState(() {
          _price = v[i];
          widget.onSelected2(_price);
        });
      }
    }
    /* if (_selected >= k.first) {
        print("Kol ${k.first}");
        setState(() {
          _price = v.first;
          widget.onSelected2(_price);
        });
        print(_price);
      }
    k.forEach((k1) {
      v.forEach((v1) {
        if (_selected >= k1) {
          print("Kol $k1");
          setState(() {
            _price = v1;
            widget.onSelected2(_price);
          });
          // _price = value;
          print(_price);
        }

////////////////////////////////////////////////////

        /* if (_selected < k[1]) {
          setState(() {
            _price = widget.price;
            widget.onSelected2(_price);
          });
          print("start");
          print(_price);
        }*/
      });
    });
*/
    return Padding(
        padding: EdgeInsets.only(top: 1),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(
            "$_price₽/шт.",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 45,
                color: Colors.white,
                fontWeight: FontWeight.w200),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "${_price * _selected}₽",
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 30,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ]));
  }
  /*else
        return Padding(
          padding: EdgeInsets.only(top: 1),
          child: Text(
            "${widget.price * _selected}₽",
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 30,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        );*/

  Widget _createIncrementDicrementButton(IconData icon, Function onPressed) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      constraints: BoxConstraints(minWidth: 32.0, minHeight: 32.0),
      onPressed: onPressed,
      elevation: 2.0,
      fillColor: Colors.black12,
      child: Icon(
        icon,
        color: Colors.black,
        size: 12.0,
      ),
      shape: CircleBorder(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
