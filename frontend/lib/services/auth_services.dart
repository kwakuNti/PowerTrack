import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Replace with your actual backend URL
  final String baseUrl = "http://localhost/PowerTrack/backend";

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
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 500 || response.statusCode == 503) {
      throw Exception("Server error");
    } else {
      return jsonDecode(
          response.body); // Handle other responses (e.g., invalid credentials)
    }
  }

  // TODO: Create logout method

  // Get the profile details of a user
  Future<Map<String, dynamic>> getProfile(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 500 || response.statusCode == 503) {
      throw Exception("Server error");
    } else {
      throw Exception("Failed to get profile");
    }
  }
}
