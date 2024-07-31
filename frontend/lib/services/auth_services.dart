import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/Meter.dart';

class AuthService {
  // Replace with your actual backend URL
  final String baseUrl = "http://16.171.150.101/PowerTrack/backend";

  // Register users
  Future<Map<String, dynamic>> register(
      String firstName, String lastName, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'confirm_password':
            password, // Assuming backend needs this field for confirmation
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 500 || response.statusCode == 503) {
      throw Exception("Server error");
    } else {
      return jsonDecode(
          response.body); // Handle other responses (e.g., validation errors)
    }
  }

  // Log users into the application
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 500 || response.statusCode == 503) {
        throw Exception("Server error");
      } else {
        return jsonDecode(response
            .body); // Handle other responses (e.g., invalid credentials)
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Failed to login: $e');
    }
  }

  // TODO: Create logout method

  // Get the profile details of a user
  Future<Map<String, dynamic>> getProfile(int user_id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$user_id'),
        headers: {'Content-Type': 'application/json'},
      );
      print('GetProfile response status: ${response.statusCode}');
      print('GetProfile response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 500 || response.statusCode == 503) {
        throw Exception("Server error");
      } else {
        throw Exception("Failed to get profile");
      }
    } catch (e) {
      print('Error during getProfile: $e');
      throw Exception('Failed to get profile: $e');
    }
  }

  // Create meter
// Create meter
  Future<Map<String, dynamic>> createMeter({
    required int userId,
    required String meterNumber,
    required String location,
    required String meterName,
    required String customerName,
    required String customerNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/meters'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'meter_number': meterNumber,
          'location': location,
          'meter_name': meterName,
          'customer_name': customerName,
          'customer_number': customerNumber,
        }),
      );

      print('CreateMeter response status: ${response.statusCode}');
      print('CreateMeter response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        // Debug print to check the structure of the response
        print('CreateMeter response: $responseBody');

        // Check if the response contains the expected keys and values
        if (responseBody.containsKey('status') &&
            responseBody.containsKey('message')) {
          // Handle success
          if (responseBody['status'] == 'success') {
            return responseBody;
          } else {
            throw Exception('API response error: ${responseBody['message']}');
          }
        } else {
          throw Exception('Unexpected response format: $responseBody');
        }
      } else if (response.statusCode == 500 || response.statusCode == 503) {
        throw Exception("Server error");
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during createMeter: $e');
      throw Exception('Failed to create meter: $e');
    }
  }

  // Get meters by user ID
  Future<List<Meter>> getMetersByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/meters/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      print('GetMetersByUserId response status: ${response.statusCode}');
      print('GetMetersByUserId response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Meter.fromJson(json)).toList();
      } else if (response.statusCode == 500 || response.statusCode == 503) {
        throw Exception("Server error");
      } else {
        throw Exception("Failed to get meters");
      }
    } catch (e) {
      print('Error during getMetersByUserId: $e');
      throw Exception('Failed to get meters: $e');
    }
  }
}
