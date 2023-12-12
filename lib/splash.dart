import 'dart:async';

import 'package:database_project/provider.dart/providerModel.dart';
import 'package:database_project/style/baseColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late ProviderModel providerModel = ProviderModel();


  Widget splashImage(){
    return const Image(
      image: AssetImage('assets/images/logo_white.png'),
    );
  }

  Widget splashProgress(){
    return Container(
      // position is device heivht 10% 
      // padding: EdgeInsets.only(left: 20, right: 20, bottom: MediaQuery.of(context).size.height * 0.1),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: providerModel.splashProgress),
        duration: const Duration(milliseconds: 500),
        builder: (BuildContext context, double value, Widget? child) {
          return LinearProgressIndicator(
            color: Colors.white,
            backgroundColor: Colors.white.withOpacity(0.5),
            value: value,
            borderRadius: BorderRadius.circular(10),
            minHeight: 10,
          );
        },
        onEnd: () async{
          if(providerModel.splashProgress >= 1.0){
          await Future.delayed(const Duration(milliseconds: 500));
              // providerModel.isPageView = true;
              providerModel.isSplash = false;
          }
        },
      )
    );
  }

  Widget spalshLayout(BuildContext context) {
    return Container(
      width:  MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: BaseColor.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: splashImage()
          ),
          splashProgress(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1)
        ],
      )
    );
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      providerModel.splashProgress = 0.25;
      if(providerModel.splashProgress >= 1.0){
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    providerModel = Provider.of<ProviderModel>(context);
    return Scaffold(
      body: spalshLayout(context),
    );
  }
}