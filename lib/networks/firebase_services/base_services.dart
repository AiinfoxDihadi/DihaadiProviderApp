import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nb_utils/nb_utils.dart';

abstract class BaseService {
  CollectionReference? ref;

  BaseService({this.ref});

  Future<DocumentReference> addDocument(Map data) async {
    var doc = await ref!.add(data);
    doc.update({'uid': doc.id});
    return doc;
  }

  Future<DocumentReference> addDocumentWithCustomId(String id, Map<String, dynamic> data) async {
    var doc = ref!.doc(id);

    return await doc.set(data).then((value) {
      return doc;
    }).catchError((e) {
      log(e);
      throw e;
    });
  }

  Future<void> updateDocument(Map<String, dynamic> data, String? id) async {
    if (id == null) {
      throw Exception("Document ID cannot be null");
    }
    try {
      await ref!.doc(id).update(data);
    } catch (e) {
      print("Error updating document: $e");
    }
  }


  Future<void> removeDocument(String id) => ref!.doc(id).delete();

  Future<bool> isUserExist(String? email) async {
    Query query = ref!.limit(1).where('email', isEqualTo: email);
    var res = await query.get();

    return res.docs.isNotEmpty;
  }

  Future<Iterable> getList() async {
    var res = await ref!.get();
    Iterable it = res.docs;
    return it;
  }
}
