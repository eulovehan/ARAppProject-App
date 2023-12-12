import 'package:auto_size_text/auto_size_text.dart';
import 'package:database_project/provider.dart/homeModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeModel homeModel = Provider.of<HomeModel>(context);

  String calcDay(){
    DateTime now = DateTime.now();
    String tmpdate = '2023.12.06';
    DateTime delivery = DateFormat('yyyy.MM.dd').parse(tmpdate);
    int diff = delivery.difference(now).inDays;
    return diff.toString();
  }

  Widget notWaterHome(){
    return const AutoSizeText(
      '아직 수분공급이 되지 않고있어요!\n당신에게 딱 맞는 물을 알려줄게요',
      style: TextStyle(
        fontFamily: 'NotoSansKR',
        color: Color.fromARGB(255, 41, 35, 35),
        fontWeight: FontWeight.bold,
        fontSize: 20,
        height: 2,
      ),
    );
  }

  Widget useWaterHome(){
    return AutoSizeText(
      '${homeModel.myInfo['leftDay']}일후에 ${homeModel.waterTitle['title']}이 배송되요!\n혹시나 다 못마신 물이 남았다면\n배송 기한을 조절할 수 있어요',
      style: const TextStyle(
        fontFamily: 'NotoSansKR',
        color: Color.fromARGB(255, 41, 35, 35),
        fontWeight: FontWeight.bold,
        fontSize: 20,
        height: 2,
      ),
    );
  }


  Widget homeLayout(){
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: const AssetImage('assets/images/water_img.png'),
            width: MediaQuery.of(context).size.height * 0.13,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: homeModel.isSetWater
            ? useWaterHome()
            : notWaterHome()
          )
        ],
      )
    );
  }



  @override
  Widget build(BuildContext context) {
    homeModel = Provider.of<HomeModel>(context);
    return Scaffold(
      body: Center(
        child: homeLayout()
      ),
    );
  }
}