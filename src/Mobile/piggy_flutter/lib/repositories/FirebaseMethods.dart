import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piggy_flutter/models/models.dart';

class FirebaseApi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final String path;
  late CollectionReference ref;

  FirebaseApi(path) {
    ref = _db.collection(path);
  }

  Future<Query> getDataCollection(List<String> params) async {
    Query result = ref;
    for (var i = 0; i < params.length; i++) {
      result = await result.where(params[i]);
    }

    return result;
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.doc(id).delete();
  }

  Future<void> addDocument(Map data, String? id, String params) {
    var doc = id != null ? ref.doc(id) : ref.doc();
    var value = doc.id;
    data[params] = value;
    return doc.set(data);
  }

  Future<void> updateDocument(Map<String, dynamic> data, String id) {
    return ref.doc(id).update(data);
  }
}

class CRUDModel<T> {
  late String collection;
  late FirebaseApi _api;
  CRUDModel(String coll) {
    collection = coll;
    _api = FirebaseApi(coll);
  }

  List<T> Result = [];

  Future fetch(List<String> query) async {
    var result = await _api.getDataCollection(query);

    // await for (var snapshot in result.snapshots()) {
    //   for (var doc in snapshot.docs) {
    //     var firstconvert = jsonEncode(doc.data().toString());
    //     var secondconvert = jsonDecode(firstconvert);
    //     T data = fromJson(secondconvert);
    //     Result.add(data);
    //   }
    // }
    // Result = result.snapshots()
    //     .map((doc) => fromJson(jsonDecode(doc.docs.().toString())))
    //     .toList<();
    return result.snapshots().toList();
  }
//fetch data as a stream
  Stream<QuerySnapshot> fetchAsStream() {
    return _api.streamDataCollection();
  }
//get by id
  Future<Map<String, dynamic>> getById(String id) async {
    var doc = await _api.getDocumentById(id);
    return jsonDecode(doc.data().toString());
  }
//this is to delete the object
  Future remove(String id) async {
    await _api.removeDocument(id);
    return;
  }
//update the something in the db
  Future updateProduct(Map<String, dynamic> data, String id) async {
    await _api.updateDocument(data, id);
    return;
  }
//add anything in the product, 
  Future addProduct(
      Map<String, dynamic> data, String? id, String paramname) async {
    var result = await _api.addDocument(data, id, paramname);

    return result;
  }

  Future registerWithEmailandPassword(String email, String password) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future loginWithEmailandPassword(String email, String password) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future updateTransaction() async {}
}
