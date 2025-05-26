import 'package:cloud_firestore/cloud_firestore.dart';

/// Model class representing a user complaint in the waste management system
/// Stores complaint details including category, description, and submission information
class ComplaintModel {
  /// Unique identifier for the complaint
  final String complaintId;
  final String category;
  final String title;
  final String description;
  final String location;
  final String userName;
  final String userId;
  final Timestamp submittedDateTime;

  /// Creates a new complaint record
  /// All parameters are required to ensure data completeness
  ComplaintModel({
    required this.complaintId,
    required this.category,
    required this.title,
    required this.description,
    required this.location,
    required this.userName,
    required this.userId,
    required this.submittedDateTime,
  });

  /// Converts the model to a map for storing in Firestore
  /// Returns a Map with all complaint properties as key-value pairs
  Map<String, dynamic> toMap() {
    return {
      'complaintId': complaintId,
      'category': category,
      'title': title,
      'description': description,
      'location': location,
      'userName': userName,
      'userId': userId,
      'submittedDateTime': submittedDateTime,
    };
  }

  /// Creates a ComplaintModel instance from a Firestore document
  /// Handles null values with default values
  /// Uses current timestamp as default for submission time
  factory ComplaintModel.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ComplaintModel(
      complaintId: data['complaintId'] ?? '',
      category: data['category'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      userName: data['userName'] ?? '',
      userId: data['userId'] ?? '',
      submittedDateTime: data['submittedDateTime'] ?? Timestamp.now(),
    );
  }
}
