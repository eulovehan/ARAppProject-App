
import 'package:flutter/material.dart';

class ProviderModel with ChangeNotifier{

  bool _initAccount = false;
  set initAccount(bool value) {_initAccount = value;}

  bool _islogin = false;
  bool get isLogin => _islogin;
  set isLogin(bool value) {
    _islogin = value;
    notifyListeners();
  }

  
  bool _isMainView = false;
  bool get isMainView => _isMainView;
  set isMainView(bool value) {
    _isMainView = value;
    notifyListeners();
  }


  PageController pageAccountController = PageController(
    initialPage: 0
  );
  
  double _pageNumber = 0;
  double get pageNumber => _pageNumber;
  set pageNumber(double value) {
    _pageNumber = value;
    notifyListeners();
  }
  
  double _anyProgress = 0.0;
  double get anyProgress => _anyProgress;
  set anyProgress(double value) {
    _anyProgress = value;
    if(_initAccount){
      notifyListeners();
    }
  }

  bool _nextPageView = false;
  bool get isNextPageView => _nextPageView;
  set isNextPageView(bool value) {
    _nextPageView = value;
    notifyListeners();
  }


  int _ct = 1;
  int get ct => _ct;
  set ct (int value) {
    _ct = value;
    notifyListeners();
  }

  final List<Map> _radioSelected = [
    {
      'title' : '고객님은 현재 몇명과 같이\n지내고 계신가요?',
      'group': '1',
      'selected': 0,
      'selection' : 
      [
        '혼자산다',
        '3명 이상이랑 같이산다',
        '사무실이다',
        '알려주기 싫다',
      ]
    },
    {
      'title' : '어디에 거주하고 계시나요?',
      'group': '2',
      'selected': 0,
      'selection' : 
      [
        '혼자산다',
        '3명 이상이랑 같이산다',
        '사무실이다',
        '알려주기 싫다',
      ]
    },
    {
      'title' : '선호하시는 물 맛은?',
      'group': '3',
      'selected': 0,
      'selection' : 
      [
        '깨끗하고 무난한거',
        '심층수같이 묵직한 맛',
        '수돗물도 잘 마신다',
        '기회가 될때 빗물을 마신다',
        '알려주기 싫다',
      ]
    },
    {
      'title' : '하루 평균 물을 얼마나 섭취하시나요?',
      'group': '3',
      'selected': 0,
      'selection' : 
      [
        '머그컵 3~5잔 정도',
        '1.5L 생수 한 통',
        '1.5L 생수 두개 이상',
        '기회가 될때 빗물을 마신다',
        '알려주기 싫다',
      ]
    },
  ];

  get radioSelection => _radioSelected;

  getRadioSelectionGroup(String groupValue){
    return _radioSelected.where((element) => element['group'] == groupValue).first;
  }
  getRadioSelectionSelected(String groupValue){
    return _radioSelected.where((element) => element['group'] == groupValue).first['selected'];
  }
  setRadioSelectionSelected(String groupValue, dynamic selectedValue){
    _radioSelected.where((element) => element['group'] == groupValue).first['selected'] = selectedValue;
    notifyListeners();
  }


  bool _splash = true;
  bool get isSplash => _splash;
  set isSplash(bool value) {
    _splash = value;
    notifyListeners();
  }

  double _splashProgress = 0.0;
  double get splashProgress => _splashProgress;
  set splashProgress(double value) {
    _splashProgress += value;
    notifyListeners();
  }




  void softReset(){
    _nextPageView = true;
  }

  void logout(){
    _islogin = false;
    _isMainView = false;
    _nextPageView = false;
    _pageNumber = 0;
    _anyProgress = 0.0;
    _splash = false;
    _splashProgress = 0.0;
    _radioSelected.forEach((element) {
      element['selected'] = 0;
    });
    notifyListeners();
  }
}