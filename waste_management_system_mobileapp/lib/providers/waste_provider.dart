import 'package:flutter/material.dart';
import 'package:waste_management_system_mobileapp/models/waste_pickup_model.dart';
import 'package:waste_management_system_mobileapp/services/firebase_services.dart';

/// A provider class that manages waste pickup-related state and operations
/// Handles regular and bulk waste pickup scheduling, fetching, and deletion
class WasteProvider extends ChangeNotifier {
  /// List of regular waste pickup requests
  List<WastePickupModel> wastePickups = [];

  /// List of bulk waste pickup requests
  List<WastePickupModel> bulkPickups = [];

  /// Loading state indicator
  bool isLoading = false;

  /// Firebase service instance for database operations
  final FirebaseService _firebaseService = FirebaseService();

  /// Adds a new regular waste pickup request
  /// Stores the request in Firestore and updates local state
  Future<void> addWastePickup(WastePickupModel wastePickup) async {
    try {
      isLoading = true;
      notifyListeners();
      await _firebaseService.uploadDocumentAny(
        "Pickups",
        wastePickup.toMap(),
        wastePickup.id,
      );
      wastePickups.add(wastePickup);
      notifyListeners();
    } catch (error) {
      throw Exception("Error adding waste pickup: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new bulk waste pickup request
  /// Stores the request in Firestore and updates local state
  Future<void> addBulkPickup(WastePickupModel wastePickup) async {
    try {
      isLoading = true;
      notifyListeners();
      await _firebaseService.uploadDocumentAny(
        "Bulks",
        wastePickup.toMap(),
        wastePickup.id,
      );
      bulkPickups.add(wastePickup);
      notifyListeners();
    } catch (error) {
      throw Exception("Error adding waste pickup: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches all regular waste pickup requests for a specific user
  /// Updates the wastePickups list with the results
  Future<void> fetchWastePickups(String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _firebaseService.getDocumentsWithField(
        collection: "Pickups",
        fieldName: "userId",
        fieldValue: userId,
      );
      if (data == null || data.docs.isEmpty) {
        wastePickups = [];
        notifyListeners();
        return;
      }
      wastePickups =
          data.docs.map((doc) => WastePickupModel.fromMap(doc)).toList();

      notifyListeners();
    } catch (error) {
      throw Exception("Error fetching waste pickups: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches all bulk waste pickup requests for a specific user
  /// Updates the bulkPickups list with the results
  Future<void> fetchBulkPickups(String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _firebaseService.getDocumentsWithField(
        collection: "Bulks",
        fieldName: "userId",
        fieldValue: userId,
      );
      if (data == null || data.docs.isEmpty) {
        bulkPickups = [];
        notifyListeners();
        return;
      }
      bulkPickups =
          data.docs.map((doc) => WastePickupModel.fromMap(doc)).toList();

      notifyListeners();
    } catch (error) {
      throw Exception("Error fetching waste pickups: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Deletes a regular waste pickup request
  /// Removes the request from both Firestore and local state
  Future<void> deleteWastePickup(String id) async {
    try {
      isLoading = true;
      notifyListeners();
      await _firebaseService.deleteDocument("Pickups", id);
      wastePickups.removeWhere((pickup) => pickup.id == id);
      notifyListeners();
    } catch (error) {
      throw Exception("Error deleting waste pickup: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
