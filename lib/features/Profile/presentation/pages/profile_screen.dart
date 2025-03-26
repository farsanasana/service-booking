import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';
import 'package:secondproject/features/Profile/domain/usecases/get_user_profile.dart';
import 'package:secondproject/features/Profile/presentation/bloc/profile_bloc.dart';
import 'package:secondproject/features/Profile/presentation/bloc/profile_event.dart';
import 'package:secondproject/features/Profile/presentation/bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('No user logged in.', style: TextStyle(fontSize: 16)),
      );
    }
    context.read<ProfileBloc>().add(LoadProfile(user.uid));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            }
            if (state is ProfileLoaded) {
              final user = state.user;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Profile Image Section
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: ColorSys.secoundry,
                              ),
                            ),
                            child: ClipOval(
                              child: user.imageUrl != null && user.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      user.imageUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/user.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                  : Image.asset(
                                      'assets/images/user.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                _showImagePickerDialog(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorSys.primary,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.edit, 
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user.username,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildEditableProfileItem(
                      context, 
                      'Name', 
                      user.username, 
                      Icons.person,
                      (newValue) {
                        // Implement name update logic
                        _updateUserField(context, 'username', newValue);
                      }
                    ),
                    const SizedBox(height: 10),
                    _buildNonEditableProfileItem(
                      'Email', 
                      user.email, 
                      Icons.email
                    ),
                    const SizedBox(height: 10),
                    _buildEditableProfileItem(
                      context, 
                      'Phone Number', 
                      user.phoneNumber, 
                      Icons.call,
                      (newValue) {
                        // Implement phone number update logic
                        _updateUserField(context, 'phoneNumber', newValue);
                      }
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                            _showLogoutConfirmationDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorSys.secoundry,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        child: const Text('Logout'),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('No data available.'));
          },
        ),
      ),
    );
  }
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildNonEditableProfileItem(
    String title, 
    String subtitle, 
    IconData iconData
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: ColorSys.secoundry,
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(iconData, color: ColorSys.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildEditableProfileItem(
    BuildContext context, 
    String title, 
    String subtitle, 
    IconData iconData,
    Function(String) onUpdateField
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: ColorSys.secoundry,
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(iconData, color: ColorSys.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () {
            _showEditDialog(context, title, subtitle, onUpdateField);
          },
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context, 
    String title, 
    String currentValue,
    Function(String) onUpdateField
  ) {
    final TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter new $title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onUpdateField(controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                 onTap: () {
                  _pickAndUploadImage(context,ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  _pickAndUploadImage(context,ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateUserField(BuildContext context, String field, String newValue) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({field: newValue});

      // Refresh the profile
      context.read<ProfileBloc>().add(LoadProfile(user.uid));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$field updated successfully')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update $field: $e')),
      );
    }
  }
    Future<void> _pickAndUploadImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;
    
    final cloudinary = CloudinaryPublic('dwhmt3yt2', 'profileImg', cache: false);
    final response = await cloudinary.uploadFile(CloudinaryFile.fromFile(pickedFile.path));
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'imageUrl': response.secureUrl});
      context.read<ProfileBloc>().add(LoadProfile(user.uid));
    }
  }
}