import 'dart:convert';
import 'package:http/http.dart' as http;

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
}
