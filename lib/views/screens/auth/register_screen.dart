import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learn_udemy_shop_app/controllers/auth_controller.dart';
import 'package:learn_udemy_shop_app/views/screens/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController();

  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();

  late String email;
  late String fullname;
  late String password;
  bool _isLoading = false;

  Uint8List? _image;

  selectGalleryImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  selectCameraImage() async {
    Uint8List im = await _authController.pickProfileImage(ImageSource.camera);

    setState(() {
      _image = im;
    });
  }

  registerUser() async {
    if(_image != null){
      if(_form_key.currentState!.validate()){
        setState(() {
          _isLoading = true;
        });

        String res = await _authController.createNewUser(email, fullname, password, _image);

        if(res == 'Success'){
          setState(() {
            _isLoading = false;
          });

          Get.to(LoginScreen());

          Get.snackbar('Success', 'Your account has been created',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: EdgeInsets.all(15)
          );
        }else{
          setState(() {
            _isLoading = false;
          });

          Get.snackbar('Error', 'Invalid input',
            backgroundColor: Colors.pink,
            colorText: Colors.white,
            icon: Icon(Icons.error, color: Colors.white)
          );
        }
      }else{
        Get.snackbar('Error', 'Invalid input',
          backgroundColor: Colors.pink,
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white)
        );
      }
    }else{
      Get.snackbar('Error', 'No image picked',
        backgroundColor: Colors.pink,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form_key,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Register Account',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4
                  ),),
              
                  SizedBox(height: 20),
              
                  Stack(
                    children: [
                      _image == null?
                        CircleAvatar(
                          radius: 65,
                          child : Icon(
                            Icons.person,
                            size: 55,
                          )
                        ):CircleAvatar(
                          radius: 65,
                          backgroundImage: MemoryImage(_image!),
                        ),
                      Positioned(
                        right: 0,
                        top: 15,
                        child: IconButton(onPressed: (){
                          selectGalleryImage();
                        }, icon: Icon(Icons.photo))
                      )
                    ],
                  ),
              
                  SizedBox(height: 20),
              
                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if(value!.isEmpty){
                        return 'Required';
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'e.g. a@a.com',
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.pink,
                      )
                    )
                  ),
              
                  SizedBox(height: 20),
              
                  TextFormField(
                    onChanged: (value) {
                      fullname = value;
                    },
                    validator: (value) {
                      if(value!.isEmpty){
                        return 'Required';
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'First Name Last Name',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.pink,
                      )
                    )
                  ),
              
                  SizedBox(height: 20),
              
                  TextFormField(
                    onChanged: (value) {
                      password = value;
                    },
                    validator: (value) {
                      if(value!.isEmpty){
                        return 'Required';
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Alphanumeric combination',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.pink,
                      )
                    )
                  ),
              
                  SizedBox(height: 25,),
              
                  InkWell(
                    onTap: () {
                      registerUser();
                    },
                    child: Container(
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(child: _isLoading? 
                          CircularProgressIndicator(color: Colors.white):
                          Text('Register',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                            color: Colors.white
                          ),))
                      ),
                    ),
                  ),
              
                  SizedBox(height: 25,),
              
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return LoginScreen();
                    }));
                  }, child: Text('Already have an account?'))
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}