import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  final String url;

  NetworkHelper(this.url);

  Future<dynamic> getData() async {
    try {
      print('OpenWeahetUrl is $url');
      http.Response uriResponse = await http.get(url);
      if (uriResponse.statusCode == 200) {
        return jsonDecode(uriResponse.body);
      } else {
        print(uriResponse.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
}
