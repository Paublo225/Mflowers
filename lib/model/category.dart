import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class CategoryModel {
  static const ID = "categoryId";
  static const NAME = "name";
  CategoryModel({this.id, this.name});
  int id;
  String name;

  // int get id => id;
  // String get name => name;

  CategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.data()[ID];
    name = snapshot.data()[NAME];
  }
}
