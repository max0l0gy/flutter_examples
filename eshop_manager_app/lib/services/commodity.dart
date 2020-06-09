import 'dart:convert';
import 'dart:io';

import 'package:E0ShopManager/utils/constants.dart';
import 'package:E0ShopManager/utils/eshop_manager.dart';
import 'package:json_annotation/json_annotation.dart';

import 'commodity_type.dart';
import 'networking.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'commodity.g.dart';

const endpoint = 'http://192.168.199.5:8080';
const listCommodityGridUrl =
    '$endpoint/rest/api/public/commodities/?page={page}&rows={rows}';
const fileUplad = '$endpoint/rest/api/private/upload/';
const addCommodityUrl = '$endpoint/rest/api/private/commodity/';

class CommodityModel {
  final EshopManager eshopManager;
  NetworkHelper _networkHelper;

  CommodityModel(this.eshopManager) {
    _networkHelper =
        NetworkHelper(basicCridentials: eshopManager.getCridentials());
  }

  Future<String> uploadFile(File file) async {
    dynamic resp = await _networkHelper.postFile(file, fileUplad);
    return resp['uri'];
  }

  Future<CommodityGrid> getCommodityGrid(int page, int rows) async {
    String getUrl = listCommodityGridUrl.replaceAll('{page}', page.toString());
    getUrl = getUrl.replaceAll('{rows}', rows.toString());
    dynamic items = await _networkHelper.getPrivateData(getUrl);
    print(items);
    return CommodityGrid.fromJson(items);
  }

  Future<Message> addCommodity(RequestCommodity rc) async {
    dynamic message =
        await _networkHelper.postData(addCommodityUrl, rc.toJsonString());
    return Message.fromJson(message);
  }
}

@JsonSerializable(explicitToJson: true)
class Message {
  static String SUCCESS = 'success';
  static String ERROR = 'error';
  String status;
  String url;
  String message;
  List<ErrorDetail> errors;

  Message(this.status, this.url, this.message, this.errors);
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ErrorDetail {
  String field;
  String message;

  ErrorDetail(this.field, this.message);
  factory ErrorDetail.fromJson(Map<String, dynamic> json) =>
      _$ErrorDetailFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorDetailToJson(this);
}

/**
 * https://flutter.dev/docs/development/data-and-backend/json
 * One-time code generation
 * y running flutter pub run build_runner build in the project root, you generate JSON serialization code for your models whenever they are needed. This triggers a one-time build that goes through the source files, picks the relevant ones, and generates the necessary serialization code for them.
 */
@JsonSerializable(explicitToJson: true)
class CommodityGrid {
  int totalPages;
  int currentPage;
  int totalRecords;
  List<Commodity> commodityData;

  CommodityGrid(
      this.totalPages, this.currentPage, this.totalRecords, this.commodityData);

  factory CommodityGrid.fromJson(Map<String, dynamic> json) =>
      _$CommodityGridFromJson(json);
  Map<String, dynamic> toJson() => _$CommodityGridToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Commodity {
  int id;
  String name;
  String shortDescription;
  String overview;
  int dateOfCreation;
  CommodityType type;
  List<String> images;
  List<CommodityBranch> branches;

  Commodity(this.id, this.name, this.shortDescription, this.overview,
      this.dateOfCreation, this.type, this.images, this.branches);

  DateTime getDateOfCreation() {
    return DateTime.fromMillisecondsSinceEpoch(dateOfCreation);
  }

  factory Commodity.fromJson(Map<String, dynamic> json) =>
      _$CommodityFromJson(json);
  Map<String, dynamic> toJson() => _$CommodityToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CommodityBranch {
  int id;
  int commodityId;
  int amount;
  double price;
  String currency;
  List<AttributeDto> attributes;

  CommodityBranch(this.id, this.commodityId, this.amount, this.price,
      this.currency, this.attributes);

  factory CommodityBranch.fromJson(Map<String, dynamic> json) =>
      _$CommodityBranchFromJson(json);
  Map<String, dynamic> toJson() => _$CommodityBranchToJson(this);
}

@JsonSerializable()
class AttributeDto {
  String name;
  String value;
  String measure;

  AttributeDto(this.name, this.value, this.measure);

  factory AttributeDto.fromJson(Map<String, dynamic> json) =>
      _$AttributeDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AttributeDtoToJson(this);
}

@JsonSerializable()
class RequestCommodity {
  String name;
  String shortDescription;
  String overview;
  int amount;
  double price;
  String currencyCode;
  int typeId;
  Set<int> propertyValues = {};
  List<String> images = [];
  int branchId;

  RequestCommodity({
    this.name,
    this.shortDescription,
    this.overview,
    this.amount,
    this.price,
    this.currencyCode,
    this.typeId,
    this.propertyValues,
    this.images,
    this.branchId,
  }) {
    if (this.propertyValues == null) propertyValues = {};
    if (this.images == null) this.images = List(EshopNumbers.UPLOAD_IMAGES);
    if (this.amount == null) this.amount = 1;
    if (this.price == null) this.price = 50;
  }
  Map<String, dynamic> toJson() => _$RequestCommodityToJson(this);
  String toJsonString() => jsonEncode(toJson());
}
