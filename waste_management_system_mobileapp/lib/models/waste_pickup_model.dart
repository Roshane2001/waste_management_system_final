import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing a waste pickup request
/// Used for both regular and bulk waste pickup scheduling
class WastePickupModel {
  /// Title or description of the waste pickup request
  final String title;

  /// Scheduled date and time for the pickup
  final Timestamp date;

  /// Name of the user requesting the pickup
  final String userName;

  /// Unique identifier of the user requesting the pickup
  final String userId;

  /// Geographic coordinates of the pickup location
  final GeoPoint coordinates;

  /// Human-readable address of the pickup location
  final String address;

  /// Unique identifier for the pickup request
  final String id;

  /// Creates a new waste pickup request
  /// All parameters are required to ensure data completeness
  WastePickupModel({
    required this.title,
    required this.date,
    required this.userName,
    required this.userId,
    required this.coordinates,
    required this.address,
    required this.id,
  });

  /// Converts the model to a map for storing in Firestore
  /// Returns a Map with all model properties as key-value pairs
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

  /// Creates a WastePickupModel instance from a Firestore document
  /// Handles null values with default empty strings
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
