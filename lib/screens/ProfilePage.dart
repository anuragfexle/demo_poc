import 'dart:io';

import 'package:demo_poc/bloc/profile/profile_bloc.dart';
import 'package:demo_poc/bloc/profile/profile_event.dart';
import 'package:demo_poc/bloc/profile/profile_state.dart';
import 'package:demo_poc/bloc/theme/theme_cubit.dart';
import 'package:demo_poc/models/profile.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final String? params;
  final Function(int, {String? params})? onNavigate;

  const ProfilePage({super.key, this.params, this.onNavigate});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _mobileController = TextEditingController();
  String? _profilePhotoPath;

  @override
  void initState() {
    super.initState();
    // Initialize fields with current state data if available
    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded && state.profile != null) {
      _updateControllers(state.profile!);
    }
  }

  void _updateControllers(Profile profile) {
    _nameController.text = profile.name;
    _ageController.text = profile.age;
    _genderController.text = profile.gender;
    _mobileController.text = profile.mobileNumber;
    setState(() {
      _profilePhotoPath = profile.profilePhotoPath;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profilePhotoPath = pickedFile.path;
      });
      Navigator.of(context).pop();
      _saveProfile();
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final profile = Profile(
        name: _nameController.text.trim(),
        age: _ageController.text.trim(),
        gender: _genderController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        profilePhotoPath: _profilePhotoPath,
      );
      context.read<ProfileBloc>().add(UpdateProfile(profile));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Updated Successfully')),
      );
    }
  }

  ImageProvider? _getImageProvider() {
    if (_profilePhotoPath == null) return null;
    if (kIsWeb) {
      return NetworkImage(_profilePhotoPath!);
    } else {
      return FileImage(File(_profilePhotoPath!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final photoSize = deviceWidth / 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded && state.profile != null) {
            _updateControllers(state.profile!);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Photo
                GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: photoSize,
                        height: photoSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                          image: _profilePhotoPath != null
                              ? DecorationImage(
                                  image: _getImageProvider()!,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _profilePhotoPath == null
                            ? Icon(
                                Icons.person,
                                size: photoSize * 0.5,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Fields
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter name'
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  maxLength: 3,
                  buildCounter:
                      (
                        BuildContext context, {
                        int? currentLength,
                        int? maxLength,
                        bool? isFocused,
                      }) => null,
                  inputFormatters: [LengthLimitingTextInputFormatter(3)],
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                    // hintText: "Type something... 3 chars max",
                    counterText: "",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value:
                      [
                        'Male',
                        'Female',
                        'Other',
                      ].contains(_genderController.text)
                      ? _genderController.text
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.wc),
                  ),
                  items: ['Male', 'Female', 'Other']
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _genderController.text = value ?? '';
                    });
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select gender'
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                    counterText: '',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter mobile number';
                    }
                    if (value.length != 10) {
                      return 'Mobile number must be 10 digits';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Mobile number must be numeric';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: _saveProfile,
                    child: const Text('Update Profile'),
                  ),
                ),

                const SizedBox(height: 24),
                Card(
                  child: BlocBuilder<ThemeCubit, AppThemeMode>(
                    builder: (context, themeMode) {
                      final isDark = themeMode == AppThemeMode.dark;
                      return SwitchListTile(
                        title: const Text('Dark Mode'),
                        value: isDark,
                        onChanged: (value) {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                        secondary: Icon(
                          isDark ? Icons.dark_mode : Icons.light_mode,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.pie_chart),
                        label: const Text('Expense Insights'),
                        onPressed: () {
                          widget.onNavigate?.call(0, params: 'show_chart');
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.bar_chart),
                        label: const Text('Budget Insights'),
                        onPressed: () {
                          widget.onNavigate?.call(1, params: 'show_chart');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
