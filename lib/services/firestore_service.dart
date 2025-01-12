import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a document to a specific collection
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).add(data);
      print("Document added successfully");
    } catch (e) {
      print("Error adding document: $e");
    }
  }

  // Get all documents from a specific collection
  Stream<List<Map<String, dynamic>>> getDocuments(String collectionPath) {
    return _db.collection(collectionPath).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList());
  }

  // Get a single document by ID
  Future<Map<String, dynamic>?> getDocumentById(String collectionPath, String docId) async {
    try {
      DocumentSnapshot doc = await _db.collection(collectionPath).doc(docId).get();
      if (doc.exists) {
        return {"id": doc.id, ...doc.data() as Map<String, dynamic>};
      }
      return null;
    } catch (e) {
      print("Error fetching document: $e");
      return null;
    }
  }

  // Update a document
  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      await _db.collection(collectionPath).doc(docId).update(data);
      print("Document updated successfully");
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  // Delete a document
  Future<void> deleteDocument(String collectionPath, String docId) async {
    try {
      await _db.collection(collectionPath).doc(docId).delete();
      print("Document deleted successfully");
    } catch (e) {
      print("Error deleting document: $e");
    }
  }
}
