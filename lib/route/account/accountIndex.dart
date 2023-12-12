import 'package:auto_size_text/auto_size_text.dart';
import 'package:database_project/env/env.dart';
import 'package:database_project/provider.dart/homeModel.dart';
import 'package:database_project/route/home/homeIndex.dart';
import 'package:database_project/provider.dart/providerModel.dart';
import 'package:database_project/sql/account.dart';
import 'package:database_project/sql/pay.dart';
import 'package:database_project/sql/water.dart';
import 'package:database_project/widget/appbar.dart';
import 'package:database_project/widget/classInfo.dart';
import 'package:database_project/widget/dialog.dart';
import 'package:database_project/widget/other.dart';
import 'package:provider/provider.dart';
import 'package:database_project/style/baseColor.dart';
import 'package:flutter/material.dart';

class AccountIndex extends StatefulWidget {
  const AccountIndex({super.key});

  @override
  State<AccountIndex> createState() => _AccountIndexState();
}


class _AccountIndexState extends State<AccountIndex> {
  late ProviderModel providerModel = Provider.of<ProviderModel>(context);
  late HomeModel homeModel = Provider.of<HomeModel>(context);
  final loginID = TextEditingController();
  final loginPW = TextEditingController();
  Key _animationKey = UniqueKey();
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  late List<Map> pageing =
  [
    {'widget' : pageIndex(), 'next' : false},
    {'widget' : inputAccount(), 'next' : true},
    {'widget' : pageBigText('환영합니다.',1, 30), 'next' : false},
    {'widget' : pageBigText('샘물 링거는 맞춤 서비스를 위해\n고객님의 성향을 듣고 있습니다.',2, 25), 'next' : false},    
    {'widget' : pageSelection(providerModel.radioSelection[0]), 'next' : true},
    {'widget' : pageSelection(providerModel.radioSelection[1]), 'next' : true},    
    {'widget' : pageSelection(providerModel.radioSelection[2]), 'next' : true},
    {'widget' : pageBigText('맞춤 조사가 끝났습니다\n다시 한번 환영합니다!',2, 25), 'next' : false},    
  ];


  progressRun() async{
    _animationKey = UniqueKey(); 
    providerModel.anyProgress  = 1;
  } 
  void previousPage(){
    if(!isNextPage(pageSerach() - 1)){
      providerModel.isNextPageView = false;
    }else{
      providerModel.isNextPageView = true;
    }
    providerModel.pageAccountController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut
    );
  }
  nextPage() async{
      if(((pageSerach() == pageing.length-1) && (pageSerach() != 0)) || providerModel.isLogin && (pageSerach() == 2)){
        providerModel.isMainView = true;
        return;
      }
      if(!isNextPage(pageSerach() + 1)){
        providerModel.isNextPageView = false;
      }else{
        providerModel.isNextPageView = true;
      }
      providerModel.pageAccountController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut
      );
  }
  bool isNextPage(double page){
    return pageing[page.toInt()]['next'];
  }
  
  Widget nextButton(){
    // if(pageing[pageController.page.toInt()].runtimeType == pageBigText())
    if (!providerModel.isNextPageView) {
      return Container();
    }
    return Container(
      decoration: const BoxDecoration(
        color: BaseColor.primaryColor,
      ),
      child: TextButton(
        onPressed: ()  async{
            if(providerModel.pageAccountController.page == 1){
              if(!_fromKey.currentState!.validate()){
                return;
              }

              var tmp = await login(
                loginID.text,
                loginPW.text,
              );
              if(!apiStatusCheck(tmp)){
                if(tmp['opcode'].toString() != 'NotFindEmail'){
                  if(!mounted) return;
                  await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return PopupAlertDialog(
                        type: PopupdialogType.error,
                        title: '계정 오류', 
                        content: [Text(tmp['message'])],
                      );
                  });
                return;
                }
              }else{
                token = tmp['token'];
                providerModel.isLogin = true;
                userInfo().then((value) {
                  homeModel.myInfo = value;
                  homeModel.loginSetting();
                });
                waterList().then((value){
                  if(apiStatusCheck(tmp)){
                    homeModel.waterList = value['waters'];
                  }
                });
                cardList().then((value){
                  if(apiStatusCheck(tmp)){
                    homeModel.myCardInfo = value['cards'][0];
                  }
                });
              }
            }
            if(providerModel.pageAccountController.page == pageing.length-2){
              
              var tmp = await regi(
                email: loginID.text,
                password: loginPW.text,
                survey_inmate: providerModel.radioSelection[0]['selection'][providerModel.radioSelection[0]['selected']],
                survey_residence: providerModel.radioSelection[1]['selection'][providerModel.radioSelection[1]['selected']],
                survey_taste: providerModel.radioSelection[2]['selection'][providerModel.radioSelection[2]['selected']],
                survey_amount: providerModel.radioSelection[3]['selection'][providerModel.radioSelection[3]['selected']],
              );
              if(!apiStatusCheck(tmp)){
                if(tmp['opcode'].toString() != 'NotFindEmail'){
                  if(!mounted) return;
                  await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return PopupAlertDialog(
                        type: PopupdialogType.error,
                        title: '회원가입 오류', 
                        content: [Text(tmp['message'])],
                      );
                  });
                  providerModel.pageAccountController.animateToPage(0, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                  return;
                }
              }else{
                token = tmp['token'];
                providerModel.isLogin = true;
                userInfo().then((value) {
                  homeModel.myInfo = value;
                  homeModel.loginSetting();
                });
                waterList().then((value){
                  if(apiStatusCheck(tmp)){
                    homeModel.waterList = value['waters'];
                  }
                });
                cardList().then((value){
                  if(apiStatusCheck(tmp)){
                    homeModel.myCardInfo = value['cards'].length == 0 ? {} : value['cards'][0];
                  }
                });
              }
            }
            nextPage();   
        },
        child: const Text(
          '다음',
          style: TextStyle(
            fontFamily: 'NotoSansKR',
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900
          ),
        ),
      ),
    );
  }
  double pageSerach(){
    if(providerModel.pageAccountController.positions.isEmpty){
      return 0;
    }
    return providerModel.pageAccountController.page ?? 0;
  }
  


  Widget pageIndex(){
    return Container(
      width:  MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: BaseColor.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                splashImage(),
                Text(
                  '샘물 링거',
                  style: TextStyle(
                    fontFamily: 'NotoSansKR',
                    color: BaseColor.primaryColor,
                    fontSize: 23,
                    fontWeight: FontWeight.w700
                  ),
                )
              ],
            )
          ),
          Column(
            children: [
              accountButton(
                '이메일로 시작하기',
                Border.all(color: const Color.fromRGBO(0, 0, 0, 0.11)),
                BaseColor.backgroundColor,
                () async{
                  nextPage();
                }
              ),
              accountButton(
                '카카오톡 시작하기',
                Border.all(color: Colors.black),
                BaseColor.kakaoColor,
                () {
                }
              ),
            ],
          ),
        
        ],
      )
    );
  }
  Widget inputAccount(){
    return Form(
      key: _fromKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ComInputWidget(
            title: '이메일', 
            hintText: 'example@google.com', 
            heights: (MediaQuery.of(context).size.height * 0.0875), 
            cont: loginID,
            isCountLength: true,
            maxCount: 150,
            inputType: TextInputType.emailAddress,
          ),
          ComInputWidget(
            title: '비밀번호', 
            hintText: '', 
            heights: (MediaQuery.of(context).size.height * 0.0875), 
            cont: loginPW,
            isCountLength: true,
            maxCount: 80,
            inputType: TextInputType.text,
            isSecure: true,
          ),
        ],
      )
    );
  }
  Widget pageBigText(String text, int maxline, double fontsize){
    // 위에서 35%구간
    progressRun();
    return Container(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children : [
          AutoSizeText(
            text,
            textAlign: TextAlign.center,
            maxLines: maxline,
            style: TextStyle(
              fontFamily: 'NotoSansKR',
              color: const Color.fromARGB(255, 41, 35, 35),
              fontSize: fontsize,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 20,),
          TweenAnimationBuilder(
            key: _animationKey,
            tween: Tween<double>(begin: 0, end: providerModel.anyProgress),
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
              nextPage(); 
            },
          )
        ]
      )
    );
  }
  
  Widget pageSelection(Map group){
    return Consumer<ProviderModel>(
      builder: (context, providerModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group['title'].toString(),
              style: const TextStyle(
                fontFamily: 'NotoSansKR',
                color: Color.fromARGB(255, 41, 35, 35),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25,),
            Expanded(
              child: Column(
                children: group['selection'].map<Widget>((e) => 
                  useRadioButton(
                    context: context,
                    idx: group['selection'].indexOf(e), 
                    name: e, 
                    checked: providerModel.getRadioSelectionSelected(group['group']),
                    onChanged: (idx) {
                      providerModel.setRadioSelectionSelected(group['group'],idx);
                    },
                  )
                ).toList(),
              )
            )
            
            // useRadioButton(
            //   idx: 1, 
            //   name: '혼자산다', 
            //   checked: providerModel.getRadioSelectionSelected(group['group']),
            //   onChanged: (idx) {
            //     providerModel.setRadioSelectionSelected(group['group'],idx);
            //   },
            // ),
          ],
        );
      }
    );
  }

  Widget slideWidget(){
      return PageView(
        controller: providerModel.pageAccountController,
        pageSnapping: false,
        physics: const NeverScrollableScrollPhysics(),
        children: pageing.map((e) => e['widget'] as Widget).toList()                  
      );
  }
  Widget accountLayout(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: slideWidget()
        )
      ],
    );
  }


    // providerModel = Provider.of<ProviderModel>(context);
  Widget splashImage(){
    return const Padding(
      padding: EdgeInsets.all(15),
      child: Image(
        image: AssetImage('assets/images/logo_color.png'),
      )
    );
  }

  Widget accountButton(String text, BoxBorder border, Color backgroundColor, Function()? onPressed){
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: MediaQuery.of(context).size.height * 0.0875,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.height * 0.0875 * 0.4
        ),
        border: border
      ),
      child: TextButton(
        onPressed: () {
          onPressed!();
          // Navigator.pushNamed(context, '/login');
        },
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'NotoSansKR',
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w900
          ),
        ),
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    providerModel = Provider.of<ProviderModel>(context);
    homeModel = Provider.of<HomeModel>(context);
    return Scaffold(
      body: CustomAppbar(
        backgroundColor: BaseColor.backgroundColor,
        leading: pageSerach() == 5 || pageSerach() == 6 
        ? Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () {
              if(providerModel.pageAccountController.page == 0){
                Navigator.pop(context);
                return;
              }
              previousPage();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
            ),
          ),
        )
        : null,
        botNav: nextButton(),
        // leading: Align(
        //   alignment: Alignment.centerLeft,
        //   child: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: const Icon(
        //       Icons.arrow_back_ios_new_rounded,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        child: accountLayout(context),
      ),
    );
  }
}