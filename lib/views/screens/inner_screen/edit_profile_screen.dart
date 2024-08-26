// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _fullNameController = TextEditingController();

  @override
  void initState() {
    _populateController();
    super.initState();
  }

  void _populateController() async {
    String? userEmail = getUserEmail();
    String? UserFullName = await getUserFullName();

    if (userEmail !=  null) {
      _emailController.text = userEmail;
    }

    if (UserFullName != null) {
      _fullNameController.text = UserFullName;
      
    }
  }

  String? getUserEmail(){
    User? user = _auth.currentUser;

    if (user != null) {
      return user.email;
    } else {
      return null;
    }
  }

  Future<String?> getUserFullName() async {
    User? user = _auth.currentUser;

    if (user != null){
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('buyers')
        .doc(user.uid)
        .get();

        return userDoc['fullName'];
      } catch (e) {
        print('Error fetching user fullname : $e');
      }

    }else{
      return null;
    }
  }

  // Update user profile
  Future<void> _updateProfile() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.verifyBeforeUpdateEmail(_emailController.text);

        await FirebaseFirestore.instance.collection('buyers').doc(user.uid).update({
          'email':_emailController.text,
          'fullname':_fullNameController.text
        });

        // Update controller text after successfull update
        _emailController.text = _emailController.text;
        _fullNameController.text = _fullNameController.text;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
          'Profile update initiated. Plesase check your email to confirm'
        )));
        
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
        'Failed to update: $e'
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Edit your profile",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
          
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter email'
                ),
              ),
          
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  hintText: 'Enter full name'
                ),
              ),
          
              SizedBox(height: 20,),
          
              InkWell(
                onTap: () {
                  _updateProfile();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Center(
                    child: Text(
                      'Update Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}