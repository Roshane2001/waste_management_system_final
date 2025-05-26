import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing a user in the waste management system
/// Stores user profile information and authentication details
class UserModel {
  /// Unique identifier for the user
  final String userId;
  
  /// User's full name
  final String userName;
  
  /// User's email address (used for authentication)
  final String userEmail;
  
  /// User's contact phone number
  final String userPhoneNumber;
  
  /// User's location coordinates (latitude and longitude)
  final GeoPoint locationCordinates;
  
  /// Date and time when the user registered
  final DateTime registeredDateTime;
  
  /// Date and time of the last profile update
  final DateTime? lastUpdatedDateTime;
  
  /// Type of user (e.g., "User", "Admin", "Collector")
  final String userType;
  
  /// User's physical address
  final String address;

  /// Creates a new user profile
  /// All parameters are required to ensure data completeness
  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhoneNumber,
    required this.locationCordinates,
    required this.registeredDateTime,
    required this.lastUpdatedDateTime,
    required this.userType,
    required this.address,
  });

  /// Converts the model to a map for storing in Firestore
  /// Handles DateTime conversion to Timestamp for Firestore compatibility
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhoneNumber': userPhoneNumber,
      'locationCordinates': locationCordinates,
      'registeredDateTime': Timestamp.fromDate(registeredDateTime),
      'lastUpdatedDateTime': Timestamp.fromDate(lastUpdatedDateTime!),
      'userType': userType,
      'address': address,
    };
  }

  /// Creates a UserModel instance from a Firestore document
  /// Throws StateError if document doesn't exist
  /// Handles null values with default values
  factory UserModel.fromMap(DocumentSnapshot doc) {
    if (!doc.exists) {
      throw StateError('Document does not exist');
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserModel(
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      userPhoneNumber: data['userPhoneNumber'] ?? '',
      locationCordinates: data['locationCordinates'] ?? const GeoPoint(0, 0),
      registeredDateTime: (data['registeredDateTime'] as Timestamp).toDate(),
      lastUpdatedDateTime: (data['lastUpdatedDateTime'] as Timestamp).toDate(),
      userType: data['userType'] ?? '',
      address: data['address'] ?? '',
    );
  }
}
