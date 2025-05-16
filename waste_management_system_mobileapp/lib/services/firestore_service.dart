import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // User Collection
  Future<void> createUserDocument(
      String uid, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(uid).set({
      ...userData,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc.data() as Map<String, dynamic>?;
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(uid).update({
      ...userData,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Waste Collection Requests
  Future<void> createWasteCollectionRequest(
      Map<String, dynamic> requestData) async {
    await _firestore.collection('waste_collections').add({
      ...requestData,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getWasteCollectionRequests(String userId) {
    return _firestore
        .collection('waste_collections')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Recycling Centers
  Future<void> addRecyclingCenter(Map<String, dynamic> centerData) async {
    await _firestore.collection('recycling_centers').add({
      ...centerData,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getRecyclingCenters() {
    return _firestore
        .collection('recycling_centers')
        .orderBy('name')
        .snapshots();
  }

  // Waste Types
  Future<void> addWasteType(Map<String, dynamic> wasteTypeData) async {
    await _firestore.collection('waste_types').add({
      ...wasteTypeData,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getWasteTypes() {
    return _firestore.collection('waste_types').orderBy('name').snapshots();
  }

  // Create a complaint
  Future<void> createComplaint(Map<String, dynamic> complaintData) async {
    try {
      await _firestore.collection('complaints').add({
        ...complaintData,
        'userId': currentUserId,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating complaint: $e');
      throw 'Failed to create complaint';
    }
  }

  // Get user's complaints
  Stream<QuerySnapshot> getUserComplaints() {
    return _firestore
        .collection('complaints')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Create a recycling guide entry
  Future<void> createRecyclingGuide(Map<String, dynamic> guideData) async {
    try {
      await _firestore.collection('recycling_guides').add({
        ...guideData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error creating recycling guide: $e');
      throw 'Failed to create recycling guide';
    }
  }

  // Get all recycling guides
  Stream<QuerySnapshot> getRecyclingGuides() {
    return _firestore
        .collection('recycling_guides')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Create a notification
  Future<void> createNotification(Map<String, dynamic> notificationData) async {
    try {
      await _firestore.collection('notifications').add({
        ...notificationData,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      print('Error creating notification: $e');
      throw 'Failed to create notification';
    }
  }

  // Get user's notifications
  Stream<QuerySnapshot> getUserNotifications() {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print('Error marking notification as read: $e');
      throw 'Failed to mark notification as read';
    }
  }
}
