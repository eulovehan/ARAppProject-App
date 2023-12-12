
import 'package:flutter/material.dart';

class HomeModel with ChangeNotifier{
  int _menuIndex = 0;

  HomeModel(BuildContext context);
  int get menuIndex => _menuIndex;
  set menuIndex(int value) {
    _menuIndex = value;
    notifyListeners();
  }

  final List _menuList = [
    '홈',
    '생수',
    '결제',
    '더보기',
  ];
  List get menuList => _menuList;

  List _waterList = [
  ];
  List get waterList => _waterList;
  set waterList(List value) {
    // lsit value안에 Map들의 imageUrl이란 값이 공백일때 'assets/images/water_img.png'로 변경 후 저장
    for(int i = 0; i < value.length; i++){
      if(value[i]['imageUrl'] == ''){
        value[i]['imageUrl'] = 'assets/images/water_img.png';
      }
    }
    _waterList = value;
    notifyListeners();
  }


  Map _myInfo = {};
  Map get myInfo => _myInfo;
  set myInfo(Map value) {
    _myInfo = value;
    notifyListeners();
  }

  loginSetting(){
    if(_myInfo.containsKey('isSetWater')){
      _isSetWater = _myInfo['isSetWater'];
      if(_isSetWater){
        _waterTitle = _myInfo['water'];
        _waterTitle['leftDay'] = _myInfo['leftDay'];
        _waterTitle['imageUrl'] = 'assets/images/water_img.png';
        _waterTitle['waterAmount'] = _myInfo['price'];
        _waterTitle['cycle'] = _myInfo['cycle'];
      }
    }
    notifyListeners();
  }

  bool _isSetWater = true;
  bool get isSetWater => _isSetWater;
  set isSetWater(bool value) {
    _isSetWater = value;
    notifyListeners();
  }

  Map _waterTitle = {};
  Map get waterTitle => _waterTitle;
  set waterTitle(Map value) {
    _waterTitle = value;
    notifyListeners();
  }



  Map? _waterListSelcted = {};
  Map get waterListSelcted => _waterListSelcted ?? {};
  set waterListSelcted(Map value) {
    _waterListSelcted = value;
    notifyListeners();
  }
  setWaterListSelcted(Map value, {bool noti = true}) {
    if(_waterListSelcted != null){
      _waterListSelcted!.removeWhere((key, value) => key != 'waterAmount' && key != 'cycle');
    } 

    if(noti)
      notifyListeners();
  }

  bool _isWaterListSelctedPage = false;
  bool get isWaterListSelctedPage => _isWaterListSelctedPage;
  set isWaterListSelctedPage(bool value) {
    _isWaterListSelctedPage = value;
    notifyListeners();
  }


  setValueWaterListSelcted(String key ,dynamic value){
    _waterListSelcted ??= {};
    _waterListSelcted![key] = value;
    notifyListeners();
  }



  bool _isNextButton = true;
  bool get isNextButton => _isNextButton;
  set isNextButton(bool value) {
    _isNextButton = value;
    notifyListeners();
  }

  Map _myCardInfo = {
  };
  Map get myCardInfo => _myCardInfo;
  set myCardInfo(Map value) {
    _myCardInfo = value;
    notifyListeners();
  }

  
  PageController _payPageController = PageController(initialPage: 0);
  PageController get payPageController => _payPageController;
  set payPageController(PageController value) {
    _payPageController = value;
    notifyListeners();
  }



  Map _myAddressInfo = {};
  Map get myAddressInfo => _myAddressInfo;
  set myAddressInfo(Map value) {
    _myAddressInfo = value;
    notifyListeners();
  }




  void logout(){
    _isSetWater = false;
    _waterTitle = {};
    _waterListSelcted = {};
    _isWaterListSelctedPage = false;
    _myCardInfo = {};
    menuIndex = 0;
    notifyListeners();
  }

}