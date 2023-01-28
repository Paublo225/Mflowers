import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowers0/homepageview/sortpage.dart';

class SearchService {
  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('name', isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }

  String collection = "sort_filter";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
//  FirebaseServices _firebaseServices = FirebaseServices();
  Future<List<FilterSearch>> sortList() async =>
      _firestore.collection(collection).get().then((result) {
        List<FilterSearch> filters = [];
        for (DocumentSnapshot filter in result.docs) {
          filters.add(FilterSearch.fromSnapshot(filter));
        }
        return filters;
      });
}
