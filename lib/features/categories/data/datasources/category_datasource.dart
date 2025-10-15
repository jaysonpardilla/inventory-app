// lib/features/categories/data/datasources/category_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config.dart';
// Updated import to the new Entity location
import '../../domain/entities/category.dart'; 

class CategoryDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Categories Stream
  Stream<List<Category>> streamCategories(String ownerId) {
    return _db
        .collection(Config.categoriesCollection)
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Category.fromMap(d.id, d.data())).toList());
  }

  // 🔹 Get Category By ID
  Future<Category?> getCategoryById(String id) async {
    final doc = await _db.collection(Config.categoriesCollection).doc(id).get();
    if (doc.exists && doc.data() != null) {
      return Category.fromMap(doc.id, doc.data()!);
    }
    return null;
  }

  // 🔹 Add Category
  Future<String> addCategory(Category category) async {
    final doc = _db.collection(Config.categoriesCollection).doc();
    await doc.set(category.toMap());
    return doc.id;
  }

  // 🔹 Update Category
  Future<void> updateCategory(Category category) async {
    await _db
        .collection(Config.categoriesCollection)
        .doc(category.id)
        .update(category.toMap());
  }

  // 🔹 Delete Category
  Future<void> deleteCategory(String id) async {
    await _db.collection(Config.categoriesCollection).doc(id).delete();
  }
}