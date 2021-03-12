import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compras/models/productos_model.dart';
import 'dart:async';

final CollectionReference productCollection =
FirebaseFirestore.instance.collection('productos');

class FirebaseService {

  static final FirebaseService _instance = new FirebaseService.internal();
  factory FirebaseService() => _instance;

  FirebaseService.internal();

  Future<ProductosModel> createProduct(String name, String image, int price, int quantity) async{
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(productCollection.doc());

      final ProductosModel producto = new ProductosModel(ds.id, name, image, price, quantity);
      final Map<String, dynamic> data = producto.toMap();

      await tx.set(ds.reference, data);

      return data;
    };

    return FirebaseFirestore.instance.runTransaction(createTransaction).then((mapData) {
      return ProductosModel.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Stream<QuerySnapshot> getProductList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshot = productCollection.snapshots();

    if (offset != null) {
      snapshot = snapshot.skip(offset);
    }

    if (limit != null) {
      snapshot = snapshot.skip(limit);
    }

    return snapshot;
  }
}