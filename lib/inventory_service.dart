import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryService {
  final CollectionReference<Map<String, dynamic>> _items =
  FirebaseFirestore.instance.collection('stockItems');

  Future<void> saveItem({
    required String sku,
    required String itemName,
    required String category,
    required int quantity,
    required double unitPrice,
    required int reorderLevel,
  }) async {
    await _items.add({
      'sku': sku,
      'itemName': itemName,
      'category': category,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'reorderLevel': reorderLevel,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getItems() {
    return _items.snapshots();
  }
}