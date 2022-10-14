import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<List<Map<String, dynamic>>> fetch(List<String> query) async {
    var result = await _api.getDataCollection(query);
    List<Map<String, dynamic>> alllists = [];

    var resultsnapshot = await result.get();
    var resultdocs = await resultsnapshot.docs.toList();
    for (var i in resultdocs) {
      print(i.data() as Map<String, dynamic>);
      alllists.add(i.data() as Map<String, dynamic>);
    }
    return alllists;
  }

//fetch data as a stream
  Stream<QuerySnapshot> fetchAsStream() {
    return _api.streamDataCollection();
  }

//get by id
  Future<Map<String, dynamic>> getById(String id) async {
    var doc = await _api.getDocumentById(id);

    return (doc.data() as Map<String, dynamic>);
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
