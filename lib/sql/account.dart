import 'dart:convert';

import 'package:database_project/env/env.dart';
import 'package:http/http.dart' as http;

Future<Map> login(String email, String password) async{
  var headers = {
    'Content-Type': 'application/json'
  };
  var request = http.Request('POST', Uri.parse('$api/login'));
  request.body = json.encode({
    "email": email,
    "password": password
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    Map data = json.decode(await response.stream.bytesToString());
    data['statusCode'] = response.statusCode;
    return data;
  }
  else {
    Map data = json.decode(await response.stream.bytesToString());
    data['statusCode'] = response.statusCode;
    return data;
  }
}


Future<Map> regi(
  {
    required String email,
    required String password,
    required String survey_inmate,
    required String survey_residence,
    required String survey_taste,
    required String survey_amount
  }
) async{
  var headers = {
    'Content-Type': 'application/json'
  };
  var request = http.Request('POST', Uri.parse('$api/signup'));
  request.body = json.encode({
    "email": email,
    "password": password,
    "survey_inmate": survey_inmate,
    "survey_residence": survey_residence,
    "survey_taste": survey_taste,
    "survey_amount": survey_amount
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    Map data = json.decode(await response.stream.bytesToString());
    data['statusCode'] = response.statusCode;
    return data;
  }
  else {
    Map data = json.decode(await response.stream.bytesToString());
    data['statusCode'] = response.statusCode;
    return data;
  }
}



Future<Map> userInfo() async{
var headers = {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json'
};
  var request = http.Request('GET', Uri.parse('$api/user/info'));
  request.body = '''''';
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    Map data = json.decode(await response.stream.bytesToString());
    data['statusCode'] = response.statusCode;
    return data;
  }
  else {
    Map data = json.decode(await response.stream.bytesToString());
    data['statusCode'] = response.statusCode;
    return data;
  }
}
