import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ManageAccountPage extends StatefulWidget {
  const ManageAccountPage({super.key});

  @override
  _ManageAccountPageState createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  File? _imageSelected;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user_id =
        Provider.of<AuthProvider>(context, listen: false).user?.user_id;
    if (user_id == null) {
      print('User ID is null');
      return;
    }

    try {
      print('Fetching user data for user ID: $user_id');
      final response = await http.get(
        Uri.parse('http://16.171.150.101/PowerTrack/backend/users/$user_id'),
      );

      if (response.statusCode == 200) {
        print('User data fetched successfully');
        final data = jsonDecode(response.body);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        setState(() {
          authProvider.user?.first_name = data['first_name'];
          authProvider.user?.last_name = data['last_name'];
          authProvider.user?.email = data['email'];
          authProvider.user?.profile_image = data['profile_image'];
        });
      } else {
        print('Failed to fetch user data');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> selectImageFromGallery() async {
    final ImagePicker _imagePicker = ImagePicker();
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _imageSelected = File(image.path);
      });

      final user_id =
          Provider.of<AuthProvider>(context, listen: false).user?.user_id;
      if (user_id != null) {
        await uploadImage(user_id.toString());
      }
    }
  }

  Future<void> uploadImage(String userId) async {
    if (_imageSelected == null) return;

    final imageExtension =
        path.extension(_imageSelected!.path).replaceAll('.', '');
    final mediaType = MediaType('image', imageExtension);

    final uri =
        Uri.parse('http://16.171.150.101/PowerTrack/backend/upload/$userId');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
          'profile_image', _imageSelected!.path,
          contentType: mediaType));

    final response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully')),
      );
    } else {
      final responseBody = await response.stream.bytesToString();
      print("Status code: ${response.statusCode}");
      print("Response: $responseBody");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
    }
  }

  Future<void> updateUserInfo(
      String userId, String field, String newValue) async {
    final response = await http.post(
      Uri.parse('http://16.171.150.101/PowerTrack/backend/profile/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        field: newValue,
      }),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      fetchUserData();
    } else {
      print('Failed to update profile');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  void _onRefresh() async {
    await fetchUserData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final userProfileImage =
        'http://16.171.150.101/PowerTrack/backend/public/profile_images/${user?.profile_image ?? 'default_user.png'}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Info',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(userProfileImage),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.blue),
                        onPressed: selectImageFromGallery,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildInfoRow('First Name', user?.first_name ?? '', false),
              const Divider(thickness: 1.5),
              _buildInfoRow('Last Name', user?.last_name ?? '', false),
              const Divider(thickness: 1.5),
              _buildInfoRow('Email', user?.email ?? '', false),
              const Divider(thickness: 1.5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, bool isEditable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (isEditable)
            TextButton(
              onPressed: () {
                _showEditDialog(context, title, value, (newValue) {
                  final userId =
                      Provider.of<AuthProvider>(context, listen: false)
                          .user
                          ?.user_id;
                  if (userId != null) {
                    updateUserInfo(
                        userId.toString(), title.toLowerCase(), newValue);
                  }
                });
              },
              child: Text(
                'Change',
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String title, String currentValue,
      Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
