import 'package:auto_size_text/auto_size_text.dart';
import 'package:database_project/provider.dart/homeModel.dart';
import 'package:database_project/sql/account.dart';
import 'package:database_project/sql/water.dart';
import 'package:database_project/style/baseColor.dart';
import 'package:database_project/widget/appbar.dart';
import 'package:database_project/widget/classInfo.dart';
import 'package:database_project/widget/dialog.dart';
import 'package:database_project/widget/other.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeWaterPop extends StatefulWidget {
  const HomeWaterPop({super.key});

  @override
  State<HomeWaterPop> createState() => _HomeWaterPopState();
}

class _HomeWaterPopState extends State<HomeWaterPop> {
  late HomeModel homeModel = Provider.of<HomeModel>(context);

  
  Widget botNav(String title,int idx, {Function(int)? onTaps}){
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async{
                  if(homeModel.waterListSelcted['id'] == null || homeModel.waterListSelcted['id'] == ''){
                    homeModel.waterListSelcted['id'] = 
                      homeModel.waterList.where((item) => item['title'] == homeModel.waterListSelcted['title'] && item['price'] == homeModel.waterListSelcted['price']).first['id'];
                  }

                  var tmp = await setWater(
                    homeModel.waterListSelcted['id'],
                    homeModel.waterListSelcted['waterAmount'],
                    homeModel.waterListSelcted['cycle'],
                  );

                  if(!apiStatusCheck(tmp)){
                    // ignore: use_build_context_synchronously
                    await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return PopupAlertDialog(
                          type: PopupdialogType.error,
                          title: '물바꾸기 실패', 
                          content: [Text(tmp['message'])],
                        );
                    });
                  }
                  // ignore: use_build_context_synchronously
                  var tmp2 = await userInfo();
                  if(!apiStatusCheck(tmp2)){
                    // ignore: use_build_context_synchronously
                    await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return PopupAlertDialog(
                          type: PopupdialogType.error,
                          title: '물바꾸기 실패', 
                          content: [Text(tmp['message'])],
                        );
                    });
                  };
                  
                  homeModel.myInfo = tmp2;
                  homeModel.waterTitle['leftDay'] = homeModel.myInfo['leftDay'];
                  homeModel.waterTitle = homeModel.myInfo['water'];
                  homeModel.waterTitle['imageUrl'] = 'assets/images/water_img.png';
                  homeModel.waterTitle['waterAmount'] = homeModel.myInfo['waterAmount'];
                  homeModel.waterTitle['cycle'] = homeModel.myInfo['cycle'];
                  homeModel.isSetWater = true;
                  Navigator.pop(context);
                  homeModel.menuIndex = idx;
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
  
  Widget waterinput(BoxConstraints constraints, String title, String keys){
    homeModel.waterListSelcted[keys] ??= 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.5,
          ),
          maxLines: 1,
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container( 
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        int counted = 0;
                        if(homeModel.waterListSelcted.containsKey(keys)){
                          counted = homeModel.waterListSelcted[keys] <= 1
                            ? 1
                            : homeModel.waterListSelcted[keys] - 1;
                        }else{
                          counted = 1;
                        }
                        homeModel.setValueWaterListSelcted(keys, counted);
                      },
                      child: Container(
                        height: double.infinity,
                        width: constraints.maxWidth * 0.3,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Colors.grey,
                              width: 1,
                              style: BorderStyle.solid
                            ),
                          ),
                        ),
                        child: const Icon(Icons.remove),
                      ),
                    ),
                    Text(
                      (homeModel.waterListSelcted[keys] ?? 0).toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        int counted = 0;
                        if(homeModel.waterListSelcted.containsKey(keys)){
                          counted = homeModel.waterListSelcted[keys] + 1;
                        }else{
                          counted = 1;
                        }
                        homeModel.setValueWaterListSelcted(keys, counted);
                      },
                      child: Container(
                        height: double.infinity,
                        width: constraints.maxWidth * 0.3,
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors.grey,
                              width: 1,
                              style: BorderStyle.solid
                            ),
                          ),
                        ),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );    
  }
  
  Widget payedContainer(){
    return LayoutBuilder(
      builder: (contexts, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: constraints.maxHeight * 0.3,
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
                  image: AssetImage(homeModel.waterListSelcted['imageUrl']),
                )
              ),
            ),
            const SizedBox(height: 10),
            AutoSizeText(
              homeModel.waterListSelcted['title'],
              style: const TextStyle(
                fontSize: 20,
                height: 1.5,
              ),
              maxLines: 1,
            ),
            AutoSizeText(
              '${homeModel.waterListSelcted['price']}원',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
              maxLines: 1,
            ),
          
            //acount input, minusbutton, input, plusbutton
            const SizedBox(height: 20,),
            waterinput(constraints, '수량','waterAmount'),
            const SizedBox(height: 20,),
            waterinput(constraints, '배송주기(월)','cycle'),
            const SizedBox(height: 20,),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const AutoSizeText(
                  '물바꾸기',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    decoration: TextDecoration.underline
                  ),
                )
              )
            )

          ],
        );
      },
    );
  }
  Widget pageLayout(){
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: payedContainer()
          )
        ],
      )
    );
  }
  

  @override
  void dispose() {
    // TODO: implement dispose
    // homeModel.setWaterListSelcted({}, noti: false);
    super.dispose();
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
            children: [
              botNav(
                '다음', 
                2,
              )
            ]
          )
        ),
        child: pageLayout()
      )
    );
  }
}