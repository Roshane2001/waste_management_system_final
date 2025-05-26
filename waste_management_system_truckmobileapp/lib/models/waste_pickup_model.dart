import 'package:cloud_firestore/cloud_firestore.dart';

/// WastePickupModel class representing a waste pickup request
class WastePickupModel {
  final String title;
  final Timestamp date;
  final String userName;
  final String userId;
  final GeoPoint coordinates;
  final String address;
  final String id;

  WastePickupModel({
    required this.title,
    required this.date,
    required this.userName,
    required this.userId,
    required this.coordinates,
    required this.address,
    required this.id,
  });

  // Convert model to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'userName': userName,
      'userId': userId,
      'coordinates': coordinates,
      'address': address,
      'id': id,
    };
  }

  // Create model instance from Firestore document
  factory WastePickupModel.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return WastePickupModel(
      id: doc.id,
      title: data['title'] ?? '',
      date: data['date'] as Timestamp,
      userName: data['userName'] ?? '',
      userId: data['userId'] ?? '',
      coordinates: data['coordinates'] as GeoPoint,
      address: data['address'] ?? '',
    );
  }
}
