import 'dart:convert';

import 'package:database_project/env/env.dart';
import 'package:http/http.dart' as http;


Future<Map> waterList() async{
var headers = {
  'Authorization': 'Bearer $token',
  'Content-Type': 'application/json'
};
  var request = http.Request('GET', Uri.parse('$api/water/list?page=0&amount=10'));
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

Future<Map> setWater(String waterid, int amount, int cycle) async{
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };
  var request = http.Request('PATCH', Uri.parse('$api/user/setWater'));
  request.body = json.encode({
    "waterId": waterid,
    "amount": amount,
    "cycle": cycle
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