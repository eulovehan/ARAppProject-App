import 'package:auto_size_text/auto_size_text.dart';
import 'package:database_project/route/home/water/homeWaterPop.dart';
import 'package:database_project/provider.dart/homeModel.dart';
import 'package:database_project/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  @override
  State<WaterPage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage> {
  late HomeModel homeModel = Provider.of<HomeModel>(context);


  Widget gridBox(String img, String title, String price, String id){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            onTap: () async{
              homeModel.waterListSelcted = {
                'id' : id,
                'imageUrl': img,
                'title': title,
                'price': price,
              };
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: homeModel,
                  child: const HomeWaterPop(),
                ),
              ));
            },
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Center(
                child: Image(
                  image: AssetImage(img),
                )
              ),
            )
          )
        ),
        const SizedBox(height: 5),
        AutoSizeText(
          title,
          style: const TextStyle(
            fontSize: 12,
          ),
          maxLines: 2,
        ),
        AutoSizeText(
          price,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
  Widget defaultConatiner(){
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              padding: const EdgeInsets.only(bottom: 20),
              children: homeModel.waterList.isEmpty
              ? [
                gridBox(
                  'assets/images/water_img.png',
                  '현재 물을 준비중입니다.', 
                  '',
                  ''
                )
              ]: List.generate(homeModel.waterList.length, (index) {
                return gridBox(
                  homeModel.waterList[index]['imageUrl'],
                  homeModel.waterList[index]['title'], 
                  homeModel.waterList[index]['price'].toString(),
                  (homeModel.waterList[index]['id'] ?? '').toString()
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget pageLayout(){
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: defaultConatiner()
          )
        ],
      )
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // build이후 실행
    WidgetsBinding.instance!.addPostFrameCallback((_) async{
      if(homeModel.isSetWater && homeModel.menuIndex == 1){
        homeModel.waterListSelcted = homeModel.waterTitle;
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: homeModel,
            child: const HomeWaterPop(),
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    homeModel = Provider.of<HomeModel>(context);
    return Scaffold(
      body: Center(
        child: pageLayout()
      ),
    );
  }
}