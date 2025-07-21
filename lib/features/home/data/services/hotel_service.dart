import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hotel_model.dart';

class HotelService {
  static const String _baseUrl = 'https://dl.dropboxusercontent.com/s/6nt7fkdt7ck0lue/hotels.json';

  Future<List<HotelModel>> getHotels() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final hotelResponse = HotelResponse.fromJson(jsonData);
        return hotelResponse.data;
      } else {
        throw Exception('Failed to load hotels: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching hotels: $e');
    }
  }
}