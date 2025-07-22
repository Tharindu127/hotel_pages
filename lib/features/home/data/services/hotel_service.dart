import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hotel_model.dart';

class HotelService {
  static const String _baseUrl = 'https://dl.dropboxusercontent.com/s/6nt7fkdt7ck0lue/hotels.json';

  Future<List<HotelModel>> getHotels() async {
    try {
      print('Fetching hotels from API...');

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final hotelResponse = HotelResponse.fromJson(jsonData);

        print('Successfully loaded ${hotelResponse.data.length} hotels');
        return hotelResponse.data;
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } on FormatException catch (e) {
      throw Exception('Invalid response format: $e');
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}