import 'package:flutter_test/flutter_test.dart';
import '../lib/models/user.dart'; // Update the path accordingly

void main() {
  group('User Class Tests', () {
    // Test data
    final Map<String, dynamic> json = {
      'user_id': 1,
      'first_name': 'John',
      'last_name': 'Doe',
      'email': 'john.doe@example.com',
      'profile_image': 'https://example.com/profile.jpg',
    };

    test('fromJson should create a User object from JSON', () {
      final user = User.fromJson(json);

      expect(user.user_id, 1);
      expect(user.first_name, 'John');
      expect(user.last_name, 'Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.profile_image, 'https://example.com/profile.jpg');
    });

    test('toJson should create a JSON map from User object', () {
      final user = User(
        user_id: 1,
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        profile_image: 'https://example.com/profile.jpg',
      );

      final jsonResult = user.toJson();

      expect(jsonResult['user_id'], 1);
      expect(jsonResult['first_name'], 'John');
      expect(jsonResult['last_name'], 'Doe');
      expect(jsonResult['email'], 'john.doe@example.com');
      expect(jsonResult['profile_image'], 'https://example.com/profile.jpg');
    });

    test('fromJson should handle missing optional fields', () {
      final jsonWithMissingFields = {
        'user_id': 1,
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john.doe@example.com',
      };

      final user = User.fromJson(jsonWithMissingFields);

      expect(user.user_id, 1);
      expect(user.first_name, 'John');
      expect(user.last_name, 'Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.profile_image, null);
    });

    test('toJson should handle null values for optional fields', () {
      final user = User(
        user_id: 1,
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        profile_image: null,
      );

      final jsonResult = user.toJson();

      expect(jsonResult['user_id'], 1);
      expect(jsonResult['first_name'], 'John');
      expect(jsonResult['last_name'], 'Doe');
      expect(jsonResult['email'], 'john.doe@example.com');
      expect(jsonResult['profile_image'], null);
    });
  });
}
