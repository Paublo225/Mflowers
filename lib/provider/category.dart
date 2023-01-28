import 'package:flowers0/sevices/category.dart';
import 'package:flutter/material.dart';
import '../model/category.dart';

class CategoryProvider with ChangeNotifier {
  CategoryServices _categoryServices = CategoryServices();
  List<CategoryModel> categories = [];

  CategoryProvider.initialize() {
    loadCategories();
  }

  loadCategories() async {
    categories =
        (await _categoryServices.getCategories()).cast<CategoryModel>();
    notifyListeners();
  }
}
