import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/category.dart';

class CategoryServices {
  String collection = "category";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CategoryModel>> getCategories() async =>
      _firestore.collection(collection).get().then((result) {
        List<CategoryModel> categories = [];
        for (DocumentSnapshot category in result.docs) {
          categories.add(CategoryModel.fromSnapshot(category));
        }
        // print(categories);
        return categories;
      });
}
