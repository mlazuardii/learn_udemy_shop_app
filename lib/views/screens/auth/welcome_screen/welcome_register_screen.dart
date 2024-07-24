import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_udemy_shop_app/views/screens/auth/welcome_screen/welcome_login_screen.dart';

class WelcomeRegisterScreen extends StatefulWidget {
  const WelcomeRegisterScreen({super.key});

  @override
  State<WelcomeRegisterScreen> createState() => _WelcomeRegisterScreenState();
}

class _WelcomeRegisterScreenState extends State<WelcomeRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.yellow.shade900
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              top: 0,
              left: -40,
              child: Image.asset('assets/icons/doorpng2.png', width: screenWidth + 80,
              height: screenHeight + 100,)
            ),

            Positioned(
              top: screenHeight * 0.641,
              left: screenWidth * 0.07,
              child: Container(
                width: screenWidth * 0.85,
                height: screenHeight * 0.085,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.white
                ),
                child: Center(child: Text('Register As Customer', style: TextStyle(
                  fontSize: screenHeight* 0.022,
                  fontWeight: FontWeight.bold
                ),)),
              )
            ),

            Positioned(
              top: screenHeight * 0.77,
              left: screenWidth* 0.07,
              child: Container(
              width: screenWidth * 0.85,
              height: screenHeight * 0.085,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.white
              ),
              child: Center(
                child: Text(
                  'Register As Seller', style: TextStyle(
                    fontSize: screenHeight* 0.022,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )),

            Positioned(
              top: screenHeight * 0.88,
              left: screenWidth * 0.06,
              child: Row(
              children: [Text('Already have account?', style: TextStyle(color: Colors.white),),
              SizedBox(
                width: screenWidth*0.022,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return WelcomeLoginScreen();
                  }));
                },
                child: Text('Login', style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),),
              )],
            ))
          ],
        ),
      ),
    );
  }
}