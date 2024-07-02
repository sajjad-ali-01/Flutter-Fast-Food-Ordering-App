import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class UserScreen extends StatefulWidget {
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  File? _selectedImage;
  String? _imageUrl;

  void selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("User not logged in");

    final storageRef = FirebaseStorage.instance.ref().child('user_images').child('$userId.jpg');
    await storageRef.putFile(image);
    return await storageRef.getDownloadURL();
  }

  void _saveUserDetails() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;
      final userDoc = FirebaseFirestore.instance.collection('Users').doc(userId);

      final dob = _dobController.text;
      if (!_isValidAge(dob)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User must be at least 12 years old.')),
        );
        return;
      }

      final updatedData = {
        'Email': _emailController.text,
        'FName': _nameController.text.split(' ').first,
        'LName': _nameController.text.split(' ').last,
        'Phone': _phoneController.text,
        'DOB': dob, // Storing in "dd/MM/yyyy" format
        'Gender': _genderController.text,
      };

      if (_selectedImage != null) {
        _imageUrl = await _uploadImage(_selectedImage!);
        updatedData['ImageUrl'] = _imageUrl!;
      }

      await userDoc.update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User details updated successfully.')),
      );
    }
  }

  bool _isValidAge(String dob) {
    final DateTime birthDate = DateFormat('dd/MM/yyyy').parse(dob);
    final DateTime currentDate = DateTime.now();
    final int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      return age > 12;
    }
    return age >= 12;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        backgroundColor: Colors.cyanAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to the edit screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditUserScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('UserId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          }
          final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          _emailController.text = data['Email'];
          _nameController.text = '${data['FName']} ${data['LName']}';
          _phoneController.text = data['Phone'];

          // Check if dob and gender are null, then set initial values
          if (data['DOB'] == null) {
            _dobController.text = 'DD/MM/YYYY';
          } else {
            _dobController.text = _formatDateOfBirth(data['DOB']);
          }

          if (data['Gender'] == null) {
            _genderController.text = 'Select Gender';
          } else {
            _genderController.text = data['Gender'];
          }

          _imageUrl = data['ImageUrl'];

          return SingleChildScrollView(child:Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.white
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 95, vertical: 10),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : (_imageUrl != null ? NetworkImage(_imageUrl!) : AssetImage("assets/images/profileLogo.jpg")) as ImageProvider,
                            foregroundColor: Colors.indigo,
                          ),
                          Positioned(
                            child: IconButton(
                              onPressed: () {
                                selectImage();
                              },
                              icon: Icon(Icons.add_a_photo_sharp),
                              color: Colors.red,
                            ),
                            bottom: -10,
                            left: 80,
                          )
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Email:',
                        labelStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                    SizedBox(height: 2),
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Name:',
                        labelStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                    SizedBox(height: 2),
                    TextFormField(
                      controller: _phoneController,
                      enabled: false,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Mobile Number:',
                        labelStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                    SizedBox(height: 2),
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Date of Birth (dd/mm/yyyy):',
                        labelStyle: TextStyle(color: Colors.black54),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null)
                              _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
                          },
                          icon: Icon(Icons.calendar_today),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 2),
                    TextFormField(
                      controller: _genderController,
                      readOnly: true,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Gender:',
                        labelStyle: TextStyle(color: Colors.black54),
                        suffixIcon: PopupMenuButton<String>(
                          icon: Icon(Icons.arrow_drop_down),
                          itemBuilder: (BuildContext context) {
                            return ['Male', 'Female', 'Transgender'].map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                          onSelected: (String? choice) {
                            if (choice != null) {
                              _genderController.text = choice;
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16), backgroundColor: Colors.indigo, // Button background color
                        ),
                        onPressed: _saveUserDetails,
                        child: Text(
                          'Save Modified Details',
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          );
        },
      ),
    );
  }
}

String _formatDateOfBirth(String? dob) {
  if (dob == null) return 'DD/MM/YYYY'; // Return empty string if date of birth is null
  DateTime dateTime = DateFormat('dd/MM/yyyy').parse(dob);
  String formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  return formattedDate;
}

class EditUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Center(
        child: Text('Edit user details here'),
      ),
    );
  }
}
