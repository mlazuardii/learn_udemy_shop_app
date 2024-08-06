import 'package:flutter/material.dart';
import 'package:learn_udemy_shop_app/views/screens/widget/badge_widget.dart';
import 'package:learn_udemy_shop_app/views/screens/widget/category_text_widget.dart';
import 'package:learn_udemy_shop_app/views/screens/widget/home_product.dart';
import 'package:learn_udemy_shop_app/views/screens/widget/location_widget.dart';
import 'package:learn_udemy_shop_app/views/screens/widget/men_products_widget.dart';
import 'package:learn_udemy_shop_app/views/screens/widget/reuse_text.dart';
import 'package:learn_udemy_shop_app/views/screens/widget/women_products_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationWidget(),
          SizedBox(height: 20),
          BadgeWidget(),
          SizedBox(
            height: 10,
          ),
          CategoryItemWidget(),
          SizedBox(
            height: 10,
          ),
          HomeProduct(),
          SizedBox(
            height: 10,
          ),
          ReuseTextWidget(title: 'Mens Products'),
          SizedBox(
            height: 10,
          ),
          MenProductsWidget(),
          SizedBox(
            height: 10,
          ),
          ReuseTextWidget(title: 'Women\s Products'),
          SizedBox(
            height: 10,
          ),
          WomenProductsWidget(),
        ],
      ),
    );
  }
}