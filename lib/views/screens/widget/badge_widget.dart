import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BadgeWidget extends StatefulWidget {
  const BadgeWidget({super.key});

  @override
  State<BadgeWidget> createState() => _BadgeWdgetState();
}

class _BadgeWdgetState extends State<BadgeWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _bannerList = [];

  getBanners(){
    return _firestore.collection('banners').get().then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _bannerList.add(doc['image']);
        });
      });
    });
  }

  @override
  void initState() {
    getBanners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: _bannerList.map((e) {
        return Builder(builder: (context){
          return Container(
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
        imageUrl: e,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
     ),
          );
        });
      }).toList(),
      options: CarouselOptions(
          height: 200,
          aspectRatio: 16/9,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          scrollDirection: Axis.horizontal,
      )
    );
  }
}