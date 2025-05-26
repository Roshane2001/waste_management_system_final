//imported packages
import 'package:cloud_firestore/cloud_firestore.dart';

/// UserModel class representing a user in the system
class UserModel {
  final String userId;
  final String userName;
  final String userEmail;
  final String password;
  final String vehicleNumber;
  final DateTime registeredDateTime;
  final DateTime? lastUpdatedDateTime;
  final String userType;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.password,
    required this.vehicleNumber,
    required this.registeredDateTime,
    required this.lastUpdatedDateTime,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'password': password,
      'vehicleNumber': vehicleNumber,
      'registeredDateTime': Timestamp.fromDate(registeredDateTime),
      'lastUpdatedDateTime':
          lastUpdatedDateTime != null
              ? Timestamp.fromDate(lastUpdatedDateTime!)
              : null,
      'userType': userType,
    };
  }

  factory UserModel.fromMap(DocumentSnapshot doc) {
    if (!doc.exists) {
      throw StateError('Document does not exist');
    }

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserModel(
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      password: data['password'] ?? '',
      vehicleNumber: data['vehicleNumber'] ?? '',
      registeredDateTime:
          data['registeredDateTime'] != null
              ? (data['registeredDateTime'] as Timestamp).toDate()
              : DateTime.now(),
      lastUpdatedDateTime:
          data['lastUpdatedDateTime'] != null
              ? (data['lastUpdatedDateTime'] as Timestamp).toDate()
              : null,
      userType: data['userType'] ?? '',
    );
  }
}
