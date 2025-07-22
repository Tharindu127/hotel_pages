import 'package:flutter/material.dart';
import '../../data/models/hotel_model.dart';
import '../../data/services/hotel_service.dart';

class HotelProvider with ChangeNotifier {
  final HotelService _hotelService = HotelService();

  List<HotelModel> _hotels = [];
  bool _isLoading = false;
  String? _error;

  List<HotelModel> get hotels => _hotels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchHotels() async {
    _setLoading(true);
    _error = null;

    try {
      _hotels = await _hotelService.getHotels();
      print('Hotels loaded successfully in provider');
    } catch (e) {
      _error = e.toString();
      _hotels = [];
      print('Error loading hotels: $e');

    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> refreshHotels() async {
    await fetchHotels();
  }
}