import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_services.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String? _token;
  String? _socketChannel;
  bool _registrationSuccess = false;
  bool _loginSuccess = false;
  String? _errorMessage;
  bool isLoading = false;

  User? get user => _user;
  String? get token => _token;
  String? get socketChannel => _socketChannel;
  bool? get registrationSuccess => _registrationSuccess;
  bool? get loginSuccess => _loginSuccess;
  String? get errorMessage => _errorMessage;

  // Temporarily store registration details
  Map<String, String> _registrationDetails = {};

  Map<String, String> get registrationDetails => _registrationDetails;

  // Set loading state
  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  // Set registration details
  void setRegistrationDetails(Map<String, String> details) {
    _registrationDetails = details;
    notifyListeners();
  }

  // Clear registration details
  void clearRegistrationDetails() {
    _registrationDetails.clear();
    notifyListeners();
  }

  // User login
  Future<void> login(String email, String password) async {
    setLoading(true);
    print('Starting login process...');
    print('Email: $email');

    try {
      final loginResponse = await _authService.login(email, password);
      print('Login response received: $loginResponse');

      if (loginResponse['success'] == true) {
        _loginSuccess = true;
        _token = loginResponse['token'];
        _socketChannel = loginResponse['socket-channel'];
        print(
            'Login successful. Token: $_token, Socket Channel: $_socketChannel');

        try {
          final profileDetails =
              await _authService.getProfile(loginResponse['id']);
          print('Profile details received: $profileDetails');

          _user = User.fromJson(profileDetails);
          print('User profile set: $_user');
        } catch (profileError) {
          print('Error fetching profile details: $profileError');
          _loginSuccess = false;
          _errorMessage = 'Failed to fetch profile details';
        }
      } else {
        _loginSuccess = false;
        _errorMessage = loginResponse['error'];
        print('Login failed with error: $_errorMessage');
      }

      setLoading(false);
      print('Login process completed.');
    } catch (e) {
      _loginSuccess = false;
      _errorMessage = e.toString();
      print('Exception during login: $_errorMessage');
      setLoading(false);
    }
  }

  // User registration
  Future<void> registerUser() async {
    setLoading(true);
    try {
      final registerResponse = await _authService.register(
        _registrationDetails['first_name']!,
        _registrationDetails['last_name']!,
        _registrationDetails['email']!,
        _registrationDetails['password']!,
      );

      if (registerResponse['success'] == true) {
        _registrationSuccess = true;
        clearRegistrationDetails(); // Clear registration details after successful registration
      } else {
        _registrationSuccess = false;
        _errorMessage = registerResponse['error'];
      }
      setLoading(false);
    } catch (e) {
      _registrationSuccess = false;
      _errorMessage = e.toString();
      setLoading(false);
    }
  }

  // Update user information
  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}
