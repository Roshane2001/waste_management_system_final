import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waste_management_system_mobileapp/models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<DocumentSnapshot> getDocumentDetails(
    String collection,
    String document,
  ) async {
    try {
      return await _db.collection(collection).doc(document).get();
    } catch (e) {
      throw Exception('Failed to fetch document: $e');
    }
  }

  Future<QuerySnapshot> getDocuments(String collection) async {
    try {
      return await _db.collection(collection).get();
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }

  Future<QuerySnapshot?> getDocumentsWithField({
    required String collection,
    required String fieldName,
    required dynamic fieldValue,
  }) async {
    try {
      return await _db
          .collection(collection)
          .where(fieldName, isEqualTo: fieldValue)
          .get();
    } catch (e) {
      throw Exception('Failed to fetch documents with field $fieldName: $e');
    }
  }

  Future<DocumentReference> uploadDocument(
    String collection,
    UserModel userData,
    String documentId,
  ) async {
    try {
      final docRef = _db.collection(collection).doc(documentId);
      await docRef.set(userData.toMap());
      return docRef;
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<DocumentReference> uploadDocumentAny(
    String collection,
    Map<String, dynamic> patientData,
    String documentId,
  ) async {
    try {
      final docRef = _db.collection(collection).doc(documentId);
      await docRef.set(patientData);
      return docRef;
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<DocumentReference> updateField(
    String collection,
    UserModel userData,
    String documentId,
  ) async {
    try {
      final docRef = _db.collection(collection).doc(documentId);
      await docRef.update(userData.toMap());
      return docRef;
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<DocumentReference> updateFieldAny({
    required String collectionName,
    required String docId,
    required Map<String, dynamic> fieldData,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection(collectionName)
          .doc(docId);

      await docRef.update(fieldData);
      return docRef;
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<void> deleteDocument(String collection, String document) async {
    try {
      await _db.collection(collection).doc(document).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }
}
