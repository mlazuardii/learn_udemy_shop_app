import 'package:flutter/material.dart';
import 'package:learn_udemy_shop_app/views/screens/widget/badge_widget.dart';
import 'package:learn_udemy_shop_app/views/screens/widget/location_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationWidget(),
        BadgeWidget()
      ],
    );
  }
}