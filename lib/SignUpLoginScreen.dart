import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SignUpLoginScreen extends StatefulWidget {
  @override
  _SignUpLoginScreenState createState() => _SignUpLoginScreenState();
}

class _SignUpLoginScreenState extends State<SignUpLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _statusMessage = '';
  File? _selectedImage;

  Future<void> _signUp() async {
    try {
      final UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        setState(() {
          _statusMessage = 'Sign up successful!';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Sign up failed. Error: $e';
      });
    }
  }

  Future<void> _signIn() async {
    try {
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        setState(() {
          _statusMessage = 'Login successful!';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Login failed. Error: $e';
      });
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile = await _imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      final reference = _storage.ref().child('images/${DateTime.now()}.png');
      final uploadTask = reference.putFile(_selectedImage!);

      await uploadTask.whenComplete(() => null);

      final imageUrl = await reference.getDownloadURL();
      setState(() {
        _statusMessage = 'Image uploaded: $imageUrl';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Sign Up/Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
            ),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 16.0),
            Text(_statusMessage),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 200,
              ),
          ],
        ),
      ),
    );
  }
}
