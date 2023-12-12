import 'package:auto_size_text/auto_size_text.dart';
import 'package:database_project/provider.dart/homeModel.dart';
import 'package:database_project/provider.dart/providerModel.dart';
import 'package:database_project/route/home/more/morePop.dart';
import 'package:database_project/style/baseColor.dart';
import 'package:database_project/widget/classInfo.dart';
import 'package:database_project/widget/dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoreIndexPage extends StatefulWidget {
  const MoreIndexPage({super.key});

  @override
  State<MoreIndexPage> createState() => _MoreIndexPageState();
}

class _MoreIndexPageState extends State<MoreIndexPage> {
  late HomeModel homeModel = Provider.of<HomeModel>(context);
  late ProviderModel providerModel = Provider.of<ProviderModel>(context);

  Widget topTextButton(){
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: ()  async{
          await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return PopupConfirmDialog(
                title: const Text('회원탈퇴'),
                subtitle: '',
                content: const [
                  Text(
                    '회원탈퇴를 하시겠습니까?\n구독중인 서비스가 완전히 중단됩니다\n정말 진행하시겠습니까?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
                action: [
                  DialogActionInfo(
                    index: 0, 
                    text: '탈퇴',
                    textColor: Colors.white,
                    backgroundColor: Color.fromRGBO(255, 156, 148, 1),
                    onPressed: () async{
                      await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return PopupConfirmDialog(
                            title: Text(''), 
                            subtitle: '',
                            content: [
                              Text(
                                '회원탈퇴가 되었습니다.\n감사합니다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                            action: [
                              const DialogActionInfo(
                                index: 0, 
                                text: '확인',
                                textColor: Colors.white,
                                backgroundColor: BaseColor.primaryColor
                              ),
                            ],
                          );
                      });
                    }
                  ),
                  const DialogActionInfo(
                    index: 1, 
                    text: '닫기',
                    textColor: Colors.white,
                    backgroundColor: BaseColor.primaryColor
                  ),
                ],
                 
              );
          });
        }, 
        child: const AutoSizeText(
          '회원탈퇴',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            decoration: TextDecoration.underline
          ),
        )
      )
    );
  }

  Widget moreListTile(String title, Function() onTap){
    return ListTile(
      onTap: (){
        onTap();
      },
      title: AutoSizeText(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 20,
      ),
    );
  }

  Widget pageLayout(){
    return SizedBox(
      width: double.infinity,
      // l;ist menu
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          // topTextButton(),
          const SizedBox(height: 20),
          // menu
          Expanded(
            child: ListView(
              children: [                
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),                
                moreListTile('배송지 수정', () async{
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider.value(
                      value: homeModel,
                      child: const MorePop(),
                    ),
                  ));
                }),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                moreListTile('로그아웃', (){
                  providerModel.logout();
                  homeModel.logout();
                }),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

              ]
            )
          )
        ]
      )
    );
  
  }


  @override
  Widget build(BuildContext context) {
    homeModel = Provider.of<HomeModel>(context);
    providerModel = Provider.of<ProviderModel>(context);
    return Scaffold(
      body: Center(
        child: pageLayout()
      ),
    );
  }
}