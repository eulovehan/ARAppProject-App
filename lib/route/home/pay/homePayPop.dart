import 'package:auto_size_text/auto_size_text.dart';
import 'package:database_project/provider.dart/homeModel.dart';
import 'package:database_project/route/home/more/morePop.dart';
import 'package:database_project/sql/pay.dart';
import 'package:database_project/style/baseColor.dart';
import 'package:database_project/widget/appbar.dart';
import 'package:database_project/widget/classInfo.dart';
import 'package:database_project/widget/dialog.dart';
import 'package:database_project/widget/other.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PayPop extends StatefulWidget {
  const PayPop({super.key});

  @override
  State<PayPop> createState() => _PayPopState();
}

class _PayPopState extends State<PayPop> {
  late HomeModel homeModel = Provider.of<HomeModel>(context);
  bool isCheck = false;
  final firstformKey = GlobalKey<FormState>();
  final secondformKey = GlobalKey<FormState>();
  bool checkError =false;
  Key _animationKey = UniqueKey();
  double _anyProgress = 0.0;

  final number = TextEditingController();
  final password = TextEditingController();
  final expMonth = TextEditingController();
  final expYear = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  final birth = TextEditingController();


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
              onTap: () async{
                if(homeModel.payPageController.page == 0){
                  if(!firstformKey.currentState!.validate()){
                    return;
                  }
                  homeModel.payPageController.animateToPage(1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                }else {
                  if(!secondformKey.currentState!.validate()){
                    setState(() {
                      if(isCheck == false){
                        checkError = true;
                      }else{
                        checkError = false;
                      }
                    });
                    return;
                  }
                  var tmp = await cardRegister(number: number.text, password: password.text, exp_month: expMonth.text, exp_year: expYear.text, name: name.text, phone: phone.text, birth: birth.text);
                  if(!apiStatusCheck(tmp)){
                    // ignore: use_build_context_synchronously
                    await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return PopupAlertDialog(
                          type: PopupdialogType.error,
                          title: '카드 등록 오류', 
                          content: [Text(tmp['message'])],
                        );
                    });
                    return;
                  }


                  cardList().then((value){
                    if(apiStatusCheck(tmp)){
                      homeModel.myCardInfo = value['cards'][0];
                    }
                  });
                  homeModel.payPageController.animateToPage(2, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
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
        children: [
          ComInputWidget(
            cont: number,
            title: '카드번호',
            hintText: '‘-’를 제외하고 숫자입력',
            isCountLength: true,
            maxCount: 16,
            heights: (MediaQuery.of(context).size.height * 0.0875),
            inputType: TextInputType.number,
            lengthValidator: true,
          ),
          Row(
            children: [
              Expanded(
                child: ComInputWidget(
                  cont: expMonth,
                  title: '유효기간',
                  hintText: '월 2자리',
                  errText: '월 2자리',
                  isCountLength: false,
                  maxCount: 2,
                  heights: (MediaQuery.of(context).size.height * 0.0875),
                  inputType: TextInputType.number,
                  lengthValidator: true,
                ),
              ),
              const Text(' / ', style: TextStyle(fontSize: 20, color: Colors.grey)),
              Expanded(
                child: ComInputWidget(
                  cont: expYear,
                  title: '유효기간',
                  hidetitle: true,
                  hintText: '연도 2자리',
                  errText: '연도 2자리',
                  isCountLength: false,
                  maxCount: 2,
                  heights: (MediaQuery.of(context).size.height * 0.0875),
                  inputType: TextInputType.number,
                  lengthValidator: true,
                ),
              ),
            ],
          ),
          ComInputWidget(
            cont: password,
            title: '카드 비밀번호',
            hintText: '앞 2자리',
            isCountLength: true,
            maxCount: 2,
            heights: (MediaQuery.of(context).size.height * 0.0875),
            inputType: TextInputType.number,
            lengthValidator: true,
          ),
        ],
      )
    );
  }
  
  Widget secondPage(){
    return Form(
      key: secondformKey,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                ComInputWidget(
                  cont: name,
                  title: '성함',
                  hintText: '홍길동',
                  isCountLength: true,
                  maxCount: 16,
                  heights: (MediaQuery.of(context).size.height * 0.0875),
                ),
                ComInputWidget(
                  cont: phone,
                  title: '전화번호',
                  hintText: '‘-’를 제외하고 숫자입력',
                  isCountLength: true,
                  maxCount: 11,
                  heights: (MediaQuery.of(context).size.height * 0.0875),
                  inputType: TextInputType.number,
                  lengthValidator: true,
                ),
                ComInputWidget(
                  cont: birth,
                  title: '생년월일',
                  hintText: 'YYYYMMDD',
                  isCountLength: true,
                  maxCount: 8,
                  heights: (MediaQuery.of(context).size.height * 0.0875),
                  inputType: TextInputType.number,
                  lengthValidator: true,
                ),
              ]
            )
          ),
          // 약관 통의 체크박스
          Padding (
            padding: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children : [
                CheckboxListTile(
                  title: const AutoSizeText('약관에 동의합니다.', maxLines: 1,style: TextStyle(fontSize: 20, color: Colors.black)),
                  value: isCheck,
                  onChanged: (value) {
                    setState(() {
                      isCheck = value!;
                    });
                  },
                  checkColor: BaseColor.primaryColor,
                  activeColor: BaseColor.primaryColor,
                  checkboxShape: const CircleBorder(),
                  side:  BorderSide(
                    color: checkError
                    ?  Colors.red
                    :  Colors.grey
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  // 체크박스 원으로
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: checkError
                    ? const BorderSide(color: Colors.red)
                    : const BorderSide(color: Colors.grey)
                  ),

                ),
                const SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    checkError
                    ? '약관에 동의해주세요.'
                    : '',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  )
                )
              ]
            )
          )
        ],
      )
    );
  }

  Widget thirdPage(){
    _anyProgress  = 1;
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
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: constraints.maxWidth * 0.9,
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
                        image: AssetImage('assets/images/water_img.png'),
                        fit: BoxFit.contain
                      )
                    ),
                  ), 
                  // 카드번호 작은 텍스트
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      // 2000-2000-2000-2000 to 2000-2000-10**-****
                      '샘수터 카드 ${number.text.substring(0,4)}-${number.text.substring(4,8)}-${number.text.substring(8,10)}**-****',
                      style: const TextStyle(
                        fontFamily: 'NotoSansKR',
                        color: Color.fromARGB(255, 41, 35, 35),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
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
                if(homeModel.myAddressInfo.isEmpty){
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                      value: homeModel,
                      child: const MorePop(),
                    ),
                  ));
                }
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            )
          ],
        );

      },
    );
  }
 
  Widget pageLayout(){
    return SizedBox(
      width: double.infinity,
      // fistpage and secondPage slide animation
      child: PageView(
        controller: homeModel.payPageController,
        onPageChanged: (idx) {
          // setState(() => homeModel.menuIndex = idx);
          if(idx == 2){
            homeModel.isNextButton = false;
          }else{
            homeModel.isNextButton = true;
          }
        },
        children: [
          firstPage(),
          secondPage(),
          thirdPage(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      homeModel.isNextButton = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    homeModel = Provider.of<HomeModel>(context);
    return Scaffold(
      body: CustomAppbar(
        leading: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () async{
              if(homeModel.payPageController.page == 0){
                Navigator.pop(context);
              }else{
                homeModel.payPageController.animateToPage(0, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
              }
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
            ),
          ),
        ),
        botNav: homeModel.isNextButton
        ? Container(
          height: MediaQuery.of(context).size.height * 0.08,
          color: BaseColor.primaryColor,
          child: Row(
            children: [botNav(
              '다음', 
              3,
              onTaps: (idx) async{
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