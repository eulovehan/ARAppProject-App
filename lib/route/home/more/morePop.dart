import 'package:auto_size_text/auto_size_text.dart';
import 'package:database_project/env/env.dart';
import 'package:database_project/provider.dart/homeModel.dart';
import 'package:database_project/sql/more.dart';
import 'package:database_project/style/baseColor.dart';
import 'package:database_project/widget/appbar.dart';
import 'package:database_project/widget/classInfo.dart';
import 'package:database_project/widget/dialog.dart';
import 'package:database_project/widget/other.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MorePop extends StatefulWidget {
  const MorePop({super.key});

  @override
  State<MorePop> createState() => _MorePopState();
}

class _MorePopState extends State<MorePop> {
  late HomeModel homeModel = Provider.of<HomeModel>(context);
  final PageController pageController = PageController(initialPage: 0);
  final firstformKey = GlobalKey<FormState>();
  
  final Key _animationKey = UniqueKey();
  double _anyProgress = 0.0;

  final address = TextEditingController();
  final detailAddress = TextEditingController();
  final addressPublicPassword = TextEditingController();


  Widget payedContainer(BoxConstraints constraints){
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const AutoSizeText(
              '새로운 카드가 등록되었어요',
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'NotoSansKR',
                color: Color.fromARGB(255, 41, 35, 35),
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
            ),
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
              child: const Center(
                child: Image(
                  image: AssetImage('assets/images/water_img.png'),
                )
              ),
            ),
            const SizedBox(height: 20,),
            TweenAnimationBuilder(
              key: _animationKey,
              tween: Tween<double>(begin: 0, end: _anyProgress),
              duration: const Duration(seconds: 3),
              builder: (BuildContext context, double value, Widget? child) {
                return LinearProgressIndicator(
                  backgroundColor: const Color.fromRGBO(0, 0, 0, 0.11),
                  color: BaseColor.primaryColor,
                  value: value,
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 10,
                );
              },
              onEnd: () async{
                homeModel.menuIndex = 2;
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }


  Widget botNav(String title,int idx, {Function(int)? onTaps}){
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: ()  async{
                if(pageController.page == 0){
                  if(!firstformKey.currentState!.validate()){
                    return;
                  }
                  FocusScope.of(context).unfocus();

                  var tmp = await addressUpdate(
                    address: address.text,
                    detailAddress: detailAddress.text,
                    addressPublicPassword: addressPublicPassword.text,
                  );

                  if(!apiStatusCheck(tmp)){
                    if(!mounted) return;
                    await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return PopupAlertDialog(
                          type: PopupdialogType.error,
                          title: '주소 등록 오류', 
                          content: [Text(tmp['message'])],
                        );
                    });
                    return;
                  }
                  addressList().then((value){
                    homeModel.myAddressInfo = value;
                  });
                  pageController.animateToPage(1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                  setState(() {});
                }
              },
              child: Container(
                color: BaseColor.primaryColor,
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:  Colors.white,
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

  Widget firstPage(){
    return Form(
      key: firstformKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            '배송지를 등록하세요',
            style: const TextStyle(
              fontFamily: 'NotoSansKR',
              color: Color.fromARGB(255, 41, 35, 35),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: Column(
              children: [
                ComInputWidget(
                  cont: address,
                  title: '주소',
                  hintText: '도로명 또는 지번 정자 입력',
                  maxCount: 15,
                  heights: (MediaQuery.of(context).size.height * 0.0875),
                ),
                ComInputWidget(
                  cont: detailAddress,
                  title: '상세주소',
                  hintText: '상세주소 입력',
                  maxCount: 57,
                  heights: (MediaQuery.of(context).size.height * 0.0875),
                  inputType: TextInputType.number,
                ),
                ComInputWidget(
                  cont: addressPublicPassword,
                  title: '공동현관 비밀번호가 있나요?',
                  hintText: '있으면 입력',
                  errText: '공동현관 비밀번호',
                  maxCount: 10,
                  heights: (MediaQuery.of(context).size.height * 0.0875),
                  inputType: TextInputType.number,
                  notValidator: true,
                ),
              ]
            )
          ),
        ],
      )
    );
  }

  Widget thirdPage(){
    _anyProgress  = 1;
    return Container(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children : [
          const AutoSizeText(
            '새로운 배송지가 등록되었어요',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'NotoSansKR',
              color: Color.fromARGB(255, 41, 35, 35),
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 20,),
          TweenAnimationBuilder(
            key: _animationKey,
            tween: Tween<double>(begin: 0, end: _anyProgress),
            duration: const Duration(seconds: 3),
            builder: (BuildContext context, double value, Widget? child) {
              return LinearProgressIndicator(
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0.11),
                color: BaseColor.primaryColor,
                value: value,
                borderRadius: BorderRadius.circular(10),
                minHeight: 10,
              );
            },
            onEnd: () async{
              homeModel.menuIndex = 3;
              Navigator.pop(context);
            },
          )
        ]
      )
    );
  }
 
  Widget pageLayout(){
    return SizedBox(
      width: double.infinity,
      // fistpage and secondPage slide animation
      child: PageView(
        controller: pageController,
        onPageChanged: (idx) {
          if(idx == 1){
            homeModel.isNextButton = false;
          }else{
            homeModel.isNextButton = true;
          }
        },
        children: [
          firstPage(),
          thirdPage(),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      homeModel.isNextButton = true;
      if(homeModel.myAddressInfo.isNotEmpty){
        address.text = homeModel.myAddressInfo['address'];
        detailAddress.text = homeModel.myAddressInfo['detailAddress'];
        addressPublicPassword.text = homeModel.myAddressInfo['addressPublicPassword'] ?? '';
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    homeModel = Provider.of<HomeModel>(context);
    return Scaffold(
      body: CustomAppbar(
        botNav: homeModel.isNextButton
        ? Container(
          height: MediaQuery.of(context).size.height * 0.08,
          color: BaseColor.primaryColor,
          child: Row(
            children: [botNav(
              '다음', 
              3,
              onTaps: (idx) {
                Navigator.pop(context);
                homeModel.menuIndex = idx;
              }
            )]
          )
        )
        : const SizedBox(),
        child: pageLayout()
      )
    );
  }

}