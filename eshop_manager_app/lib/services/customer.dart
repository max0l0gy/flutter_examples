import 'package:E0ShopManager/utils/constants.dart';
import 'package:E0ShopManager/utils/eshop_manager.dart';
import 'package:json_annotation/json_annotation.dart';

import 'networking.dart';

part 'customer.g.dart';

const endpoint = EshopManagerProperties.managerEndpoint;
const getCustomerByIdUrl = '$endpoint/rest/api/private/customer/id/{id}';

class CommodityModel {
  final EshopManager eshopManager;
  NetworkHelper _networkHelper;

  CommodityModel(this.eshopManager) {
    _networkHelper =
        NetworkHelper(basicCridentials: eshopManager.getCridentials());
  }

  Future<Customer> getById(int id) async {
    dynamic customer = await _networkHelper
        .getPrivateData(getCustomerByIdUrl.replaceAll('{id}', id.toString()));
    return _convertFromJson(customer);
  }

  Customer _convertFromJson(dynamic orders) {
    return Customer.fromJson(orders);
  }
}

@JsonSerializable(explicitToJson: true)
class Customer {
  int id;
  String email;
  String fullName;
  String country;
  String postcode;
  String city;
  String address;

  Customer(this.id, this.email, this.fullName, this.country, this.postcode,
      this.city, this.address);

  String fullAddress() {
    return '$postcode , $country, $city, $address';
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
