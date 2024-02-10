import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../home/home_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>  const HomePage()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.sizeOf(context).height*1;
    final width=MediaQuery.sizeOf(context).width*1;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Image.asset('assets/images/news_splash.jpg',fit: BoxFit.cover,
             height: double.infinity,
          ),
          Positioned(
            top: 650,
            left: 150,
            child: Text('TOP HEADLINES',style: GoogleFonts.anton(
              fontSize: 20,
                letterSpacing: .6,color: Colors.black),),
          ),
          SizedBox(height: height*0.04,),
          const SpinKitChasingDots(
            color: Colors.blue,
            size: 45,
          ),
        ],
      ),
    );
  }
}
