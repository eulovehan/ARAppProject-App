import 'dart:convert';

import 'package:database_project/env/env.dart';
import 'package:http/http.dart' as http;

Future<Map> cardList() async{
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };
  var request = http.Request('GET', Uri.parse('$api/user/card/list?page=0&amount=10'));
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

Future<Map> cardRegister(
  {
    required String number,
    required String password,
    required String exp_month,
    required String exp_year,
    required String name,
    required String phone,
    required String birth
  }
) async{
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };
  var request = http.Request('POST', Uri.parse('$api/user/card/registration'));
  request.body = json.encode({
    "number": number,
    "password": password,
    "exp_month": exp_month,
    "exp_year": exp_year,
    "name": name,
    "phone": phone,
    "birth": birth
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

Future<Map> removeCard(String id) async{
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };
  var request = http.Request('DELETE', Uri.parse('$api/user/card/remove/$id'));
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


