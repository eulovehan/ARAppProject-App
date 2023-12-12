import 'dart:convert';

import 'package:database_project/env/env.dart';
import 'package:http/http.dart' as http;

Future<Map> addressList() async{
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };
  var request = http.Request('GET', Uri.parse('$api/user/address/info'));
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

Future<Map> addressUpdate(
  {
    required String address,
    required String detailAddress,
    required String addressPublicPassword,
  }
) async{
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };
  var request = http.Request('PATCH', Uri.parse('$api/user/address/update'));
  request.body = json.encode({
    "address": address,
    "detailAddress": detailAddress,
    "addressPublicPassword": addressPublicPassword.trim() == '' ? null : addressPublicPassword
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



Future<Map> peopleDie(
  {
    required String address,
    required String detailAddress,
    required String addressPublicPassword,
  }
) async{
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };
  var request = http.Request('PATCH', Uri.parse('$api/user/address/update'));
  request.body = json.encode({
    "address": address,
    "detailAddress": detailAddress,
    "addressPublicPassword": addressPublicPassword.trim() == '' ? null : addressPublicPassword
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
