import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String basicCridentials;

  NetworkHelper({this.basicCridentials});

  Map<String, String> basicAuthorizationHeader() {
    return {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Basic ${basicCridentials}'
    };
  }

  dynamic decodeResponse(http.Response resp) {
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body);
    } else {
      print('!STATUS!=${resp.statusCode}');
      print(resp);
      return null;
    }
  }

  Future<dynamic> getData(String url) async {
    try {
      http.Response uriResponse = await http.get(url);
      return decodeResponse(uriResponse);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getPrivateData(String url) async {
    try {
      var resp = await http.get(url, headers: basicAuthorizationHeader());
      return decodeResponse(resp);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> postData(String url, String json) async {
    try {
      http.Response resp =
          await http.post(url, headers: basicAuthorizationHeader(), body: json);
      return decodeResponse(resp);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> putData(String url, String json) async {
    try {
      http.Response resp =
          await http.put(url, headers: basicAuthorizationHeader(), body: json);
      return decodeResponse(resp);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> deleteData(String url) async {
    try {
      var resp = await http.delete(url, headers: basicAuthorizationHeader());
      if (resp.statusCode == 200) {
        return jsonDecode(resp.body);
      } else {
        print(resp.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
}
