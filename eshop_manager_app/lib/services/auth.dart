import 'dart:convert';
import 'package:E0ShopManager/utils/constants.dart';

import 'networking.dart';

import 'package:E0ShopManager/utils/eshop_manager.dart';

const endpoint = EshopManagerProperties.managerEndpoint;
const checkAuthUrl = '$endpoint/rest/api/private/checkAuth';

class Authenticate {
  final EshopManager eshopManager;

  Authenticate(this.eshopManager);

  Future<List<String>> getAuthorities() async {
    dynamic authorities =
        await NetworkHelper(basicCridentials: eshopManager.getCridentials())
            .getPrivateData(checkAuthUrl);
    return _convertAuthorities(authorities);
  }

  List<String> _convertAuthorities(dynamic authCheckResponse) {
    if (authCheckResponse == null) return [];
    List<dynamic> auth = authCheckResponse['authorities'];
    return auth.map((e) => e['authority'].toString()).toList();
  }
}
