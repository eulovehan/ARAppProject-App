import 'package:database_project/route/home/main/homeMainPage.dart';
import 'package:database_project/route/home/more/moreIndex.dart';
import 'package:database_project/route/home/pay/homePayPage.dart';
import 'package:database_project/route/home/water/homeWaterPage.dart';
import 'package:database_project/provider.dart/homeModel.dart';
import 'package:database_project/provider.dart/providerModel.dart';
import 'package:database_project/style/baseColor.dart';
import 'package:database_project/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeIndex extends StatefulWidget {
  const HomeIndex({super.key});

  @override
  State<HomeIndex> createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex> {
  late HomeModel homeModel = Provider.of<HomeModel>(context);

  Widget botNav(String title,int idx, {Function(int)? onTaps}){
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTaps == null
              ? () {
                setState(() => homeModel.menuIndex = idx);
              }
              : () {
                onTaps(idx);
              },
              child: Container(
                color: homeModel.menuIndex == idx ? Colors.white : BaseColor.primaryColor,
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: homeModel.menuIndex == idx ? BaseColor.primaryColor : Colors.white,
                    ),
                  ),
                )
              )
            )
          )
        ],
      ),
    );
  }

  List<Widget> buildBotNavWidgets() {
    return homeModel.menuList.asMap().entries.map((entry) {
      int idx = entry.key;
      String title = entry.value;
      return botNav(
        title, 
        idx
      );
    }).toList();
  }

  Widget menueSelected(){
    switch(homeModel.menuIndex){
      case 0:
        return const HomePage();
      case 1:
        return const WaterPage();
      case 2:
        return const PayPage();
      case 3:
        return const MoreIndexPage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    homeModel = Provider.of<HomeModel>(context);
    return Scaffold(
        body: CustomAppbar(
          botNav: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            color: BaseColor.primaryColor,
            child: Row(
              children: buildBotNavWidgets()
            )
          ),
          child: menueSelected()
        )
      );
  }
}