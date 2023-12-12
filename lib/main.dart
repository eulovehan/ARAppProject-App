import 'package:database_project/route/home/homeIndex.dart';
import 'package:database_project/index.dart';
import 'package:database_project/provider.dart/homeModel.dart';
import 'package:database_project/provider.dart/providerModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async{
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 세로 모드
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<ProviderModel>(
            create: (context) => ProviderModel(),
          ),
          ChangeNotifierProvider<HomeModel>(
            create: (context) => HomeModel(context),
          ),
        ],
        child: const IndexPage(),
      ),
    );
  }
}