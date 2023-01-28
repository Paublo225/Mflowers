import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const ID = "id";
  static const ART = "артикул";
  static const NAME = "name";
  static const QPAK = "qpak";
  static const PICTURE = "imageUrl";
  static const PRICE = "price";
  static const QUANTITY = "quantity";
  static const DESCRIPTION = "description";
  static const CATEGORY = "category";
  static const SEARCH = "search_field";
  static const OPT = "опт";
  static const PRODUCER = "производитель";
  static const LENGTH = "длина";
  static const SORT = "сорт";
  static const DELIVERY_DATE = "дата_поставки";
  ProductModel({
    this.id,
    this.name,
    this.imageUrl,
    this.description,
    this.category,
    this.quantity,
    this.qpak,
    this.price,
    this.opt,
    this.search,
    this.sort,
    this.art,
    this.length,
    this.producer,
    this.deliveryDate,
  });
  String id;
  String name;
  String imageUrl;
  String description;
  String category;
  String quantity;
  int qpak;
  int price;
  String opt;
  String search;
  String sort;
  String length;
  String producer;
  String art;
  String deliveryDate;

/*  String get id => _id;

  String get name => _name;

  String get imageUrl => _imageUrl;

  String get searh => _search;

  String get category => _category;

  String get description => _description;

  String get quantity => _quantity;

  String get price => _price;

  //bool get featured => _featured;

  //bool get sale => _sale;

  //List get colors => _colors;

  //List get sizes => _sizes;
  String get opt => _opt;
  int get qpak => _qpak;
*/
  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot.data()[NAME];
    qpak = snapshot.data()[QPAK];
    imageUrl = snapshot.data()[PICTURE];
    price = snapshot.data()[PRICE];
    quantity = snapshot.data()[QUANTITY];
    category = snapshot.data()[CATEGORY];
    opt = snapshot.data()[OPT];
    search = snapshot.data()[SEARCH];
    art = snapshot.data()[ART];
    sort = snapshot.data()[SORT];
    producer = snapshot.data()[PRODUCER];
    length = snapshot.data()[LENGTH];
    description = snapshot.data()[DESCRIPTION];
    deliveryDate = snapshot.data()[DELIVERY_DATE];
  }

  static ProductModel fromMap(Map<String, dynamic> data) {
    return ProductModel(
      id: data[ID],
      name: data[NAME],
      qpak: data[QPAK],
      imageUrl: data[PICTURE],
      price: data[PRICE],
      quantity: data[QUANTITY],
      category: data[CATEGORY],
      opt: data[OPT],
      search: data[SEARCH],
      art: data[ART],
      sort: data[SORT],
      producer: data[PRODUCER],
      length: data[LENGTH],
      description: data[DESCRIPTION],
      deliveryDate: data[DELIVERY_DATE],
    );
  }
}
