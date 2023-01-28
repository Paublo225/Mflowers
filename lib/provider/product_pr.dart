import '../model/product.dart';
import '../sevices/product.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  ProductServices _productServices = ProductServices();
  List<ProductModel> products = [];
  List<ProductModel> productsSearched = [];
  int _count = 0;
  ProductProvider.initialize() {
    loadProducts();
  }
  getCartItems() async {
    _count = _productServices.getCartItems() as int;
  }

  loadProducts() async {
    products = _productServices.getProducts() as List<ProductModel>;
    print(products);
    notifyListeners();
  }

  Future search({String productName}) async {
    productsSearched =
        await _productServices.searchProducts(productName: productName);
    notifyListeners();
  }
}
