//imported packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:waste_management_system_truckmobileapp/models/user_model.dart';

/// FirebaseService class for handling Firestore operations
class FirebaseService {
  //Instalization firestore and auth instance
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
  // Fetch all documents from a collection
  Future<QuerySnapshot> getDocuments(String collection) async {
    try {
      return await _db.collection(collection).get();
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }
  // Fetch documents with a specific field value
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

  //Uploads a user document to Firestore
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

  //Uploads any document to Firestore with custom data
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

  //Deletes a document from Firestore
  Future<void> deleteDocument(String collection, String document) async {
    try {
      await _db.collection(collection).doc(document).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  //Updates a user document in Firestore
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

  //Updates any document in Firestore with custom field data
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

  //Sending rest passwords emails to email address
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }
}
