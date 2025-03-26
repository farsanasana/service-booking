import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:secondproject/features/auth/presentation/bloc/profile/profile_event.dart';
import 'package:secondproject/features/auth/presentation/bloc/profile/profile_state.dart';

class ProfileImageSection extends StatelessWidget {
  final Function(String) onImageSelected;

  const ProfileImageSection({Key? key, required this.onImageSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileImageBloc, ProfileImageState>(
      listener: (context, state) {
        if (state is ProfileImageUploaded) {
          onImageSelected(state.imageUrl);
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                context.read<ProfileImageBloc>().add(PickImageEvent());
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: state is ProfileImagePicked
                    ? FileImage(state.image)
                    : const AssetImage('assets/images/user.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 10),
            Text('Tap to select profile image'),
            if (state is ProfileImagePicked)
              ElevatedButton(
                onPressed: () {
                  context.read<ProfileImageBloc>().add(UploadImageEvent(state.image));
                },
                child: state is ProfileImageUploading
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : const Text('Upload Image'),
              ),
          ],
        );
      },
    );
  }
}
