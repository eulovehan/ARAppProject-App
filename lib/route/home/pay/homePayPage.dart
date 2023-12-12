import 'package:auto_size_text/auto_size_text.dart';
import 'package:database_project/provider.dart/homeModel.dart';
import 'package:database_project/route/home/homeIndex.dart';
import 'package:database_project/route/home/pay/homePayPop.dart';
import 'package:database_project/sql/pay.dart';
import 'package:database_project/widget/classInfo.dart';
import 'package:database_project/widget/dialog.dart';
import 'package:database_project/widget/other.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PayPage extends StatefulWidget {
  const PayPage({super.key});

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  late HomeModel homeModel = Provider.of<HomeModel>(context);


  Widget payedContainer(){
    return GestureDetector(
      onTap: () async{
        if(homeModel.myCardInfo.isEmpty){
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: homeModel,
              child: const PayPop(),
            ),
          ));
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(homeModel.myCardInfo.isEmpty)
              DottedBorder(
                borderType: BorderType.RRect,
                color: Colors.grey,
                dashPattern: const [5, 5],
                strokeWidth: 1,
                radius: const Radius.circular(10),
                child: SizedBox(
                  width: double.infinity,
                  height: constraints.maxHeight * 0.3,
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      size: 50,
                    ),
                  ),
                ),
              ),
            
              if(homeModel.myCardInfo.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                // height: constraints.maxHeight * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () async{
                          var tmp = await removeCard(homeModel.myCardInfo['id']);
                          if(!apiStatusCheck(tmp)){
                            if(!mounted) return;
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return PopupAlertDialog(
                                  type: PopupdialogType.error,
                                  title: '카드 제거 오류', 
                                  content: [Text(tmp['message'])],
                                );
                            });
                            return;
                          }
                          homeModel.myCardInfo = {};
                        },
                        child: const Icon(
                          Icons.close,
                          size: 20,
                        ),
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Center(
                            child: Image(
                              image: AssetImage('assets/images/water_img.png'),
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              // 2000-2000-2000-2000 to 2000-2000-10**-****
                              '샘수터 카드 ${homeModel.myCardInfo['number'].substring(0,4)}-${homeModel.myCardInfo['number'].substring(4,8)}-${homeModel.myCardInfo['number'].substring(8,10)}**-****',
                              style: const TextStyle(
                                fontFamily: 'NotoSansKR',
                                color: Color.fromARGB(255, 41, 35, 35),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      )
                  ],
                )
              )
             
              
            ],
          );
        },
      )
    );
  }

  Widget pageLayout(){
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AutoSizeText(
            homeModel.myCardInfo.isEmpty ? '간편하게 카드를 등록해두세요' : '이 카드로 자동 결제가 되고있어요',
            style: const TextStyle(
              fontFamily: 'NotoSansKR',
              color: Color.fromARGB(255, 41, 35, 35),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20,),
          // Expanded(
          //   child: payedContainer()
          // ),
          Expanded(
            child: payedContainer()
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
        child: pageLayout()
      ),
    );
  }
}