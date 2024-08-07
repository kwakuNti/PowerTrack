/// Class to model a user
// ignore_for_file: non_constant_identifier_names

class User {
  int user_id;
  String first_name;
  String last_name;
  String email;
  String? profile_image;

  User({
    required this.user_id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.profile_image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        user_id: json['user_id'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        email: json['email'],
        profile_image: json['profile_image'],
      );
    } catch (e) {
      print('Error parsing User from JSON: $e');
      print('JSON received: $json');
      throw Exception('Failed to parse User from JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'profile_image': profile_image,
    };
  }
}
