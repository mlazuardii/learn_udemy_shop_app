import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_udemy_shop_app/controllers/auth_controller.dart';
import 'package:learn_udemy_shop_app/views/screens/auth/register_screen.dart';
import 'package:learn_udemy_shop_app/views/screens/map_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _form_key = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  late String email;
  late String password;
  bool _isLoading = false;

  loginUser() async {
    setState(() {
      _isLoading = true;
    });

    if(_form_key.currentState!.validate()){
      String res = await _authController.loginUser(email, password);

      if(res == 'Success'){
        Get.snackbar('Login Success', 'You are now logged in.',
        backgroundColor: Colors.green,
        colorText: Colors.white);

        Get.to(MapScreen());
      }else{
        Get.snackbar('Login Error', res.toString(),
        backgroundColor: Colors.pink,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form_key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4
                ),
              ),
              SizedBox(height: 25,),
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
                ),
              ),
              SizedBox(height: 25,),
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
                ),
              ),
              SizedBox(height: 25,),
              InkWell(
                onTap: () {
                  loginUser();
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: _isLoading? CircularProgressIndicator(color: Colors.white)
                  : Text('Login',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Colors.white
                    ),))
                ),
              ),
              SizedBox(height: 25,),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return RegisterScreen();
                }));
              }, child: Text('Need an account?'))
            ],
          ),
        ),
      ),
    );
  }
}