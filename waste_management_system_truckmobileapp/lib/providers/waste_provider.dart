//imported packages
import 'package:flutter/material.dart';
import 'package:waste_management_system_truckmobileapp/models/waste_pickup_model.dart';
import 'package:waste_management_system_truckmobileapp/services/firebase_services.dart';

/// WasteProvider class to manage waste pickup data
class WasteProvider extends ChangeNotifier {
  List<WastePickupModel> wastePickups = [];
  List<WastePickupModel> bulkPickups = [];
  bool isLoading = false;

  final FirebaseService _firebaseService = FirebaseService();

  // Getter to access waste pickup coordinates
  List<WastePickupModel> get allWastePickups => wastePickups;

  // Getter to access bulk pickup coordinates
  List<WastePickupModel> get allBulkPickups => bulkPickups;

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

  /// Adds a bulk pickup to the database
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

  /// Fetches waste pickups from the database
  Future<void> fetchWastePickups(String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _firebaseService.getDocuments("Pickups");
      if (data.docs.isEmpty) {
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

  /// Fetches bulk pickups from the database
  Future<void> fetchBulkPickups(String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _firebaseService.getDocuments("Bulks");
      if (data.docs.isEmpty) {
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

  //delete waste pickup
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
  //delete bulk pickup
  Future<void> deleteBulkPickup(String id) async {
    try {
      isLoading = true;
      notifyListeners();
      await _firebaseService.deleteDocument("Bulks", id);
      bulkPickups.removeWhere((pickup) => pickup.id == id);
      notifyListeners();
    } catch (error) {
      throw Exception("Error deleting bulk pickup: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
