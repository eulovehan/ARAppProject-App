import 'dart:async';

import 'package:database_project/route/account/accountIndex.dart';
import 'package:database_project/route/home/homeIndex.dart';
import 'package:database_project/provider.dart/providerModel.dart';
import 'package:database_project/splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late ProviderModel providerModel = ProviderModel();


  


  Widget loadSplash(BuildContext context) {
    return const SplashPage();
  }

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    providerModel = Provider.of<ProviderModel>(context);
    return providerModel.isSplash 
        ? const SplashPage() 
        : providerModel.isMainView
          ? const HomeIndex()
          : const AccountIndex();
        
        
  }
}