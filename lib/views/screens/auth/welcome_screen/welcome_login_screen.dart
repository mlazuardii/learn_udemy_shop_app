import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_udemy_shop_app/views/screens/auth/login_screen.dart';
import 'package:learn_udemy_shop_app/views/screens/auth/welcome_screen/welcome_register_screen.dart';

class WelcomeLoginScreen extends StatefulWidget {
  const WelcomeLoginScreen({super.key});

  @override
  State<WelcomeLoginScreen> createState() => _WelcomeLoginScreenState();
}

class _WelcomeLoginScreenState extends State<WelcomeLoginScreen> {
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
              left: screenWidth * 0.024,
              top: screenHeight*0.151,
              child: Image.asset('assets/icons/Illustration.png'),
            ),

            Positioned(
              top: 0,
              left: -40,
              child: Image.asset('assets/icons/doorpng2.png', width: screenWidth + 80,
              height: screenHeight + 100,)
            ),

            Positioned(
              top: screenHeight * 0.641,
              left: screenWidth * 0.07,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return CustomerLoginScreen();
                  }));
                },
                child: Container(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.085,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.white
                  ),
                  child: Center(child: Text('Login As Customer', style: TextStyle(
                    fontSize: screenHeight* 0.022,
                    fontWeight: FontWeight.bold
                  ),)),
                ),
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
                  'Login As Seller', style: TextStyle(
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
              children: [Text('Need an account?', style: TextStyle(color: Colors.white),),
              SizedBox(
                width: screenWidth*0.022,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return WelcomeRegisterScreen();
                  }));
                },
                child: Text('Register', style: TextStyle(
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