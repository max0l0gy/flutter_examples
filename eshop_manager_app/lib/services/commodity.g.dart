// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commodity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommodityGrid _$CommodityGridFromJson(Map<String, dynamic> json) {
  return CommodityGrid(
    json['totalPages'] as int,
    json['currentPage'] as int,
    json['totalRecords'] as int,
    (json['commodityData'] as List)
        ?.map((e) =>
            e == null ? null : Commodity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CommodityGridToJson(CommodityGrid instance) =>
    <String, dynamic>{
      'totalPages': instance.totalPages,
      'currentPage': instance.currentPage,
      'totalRecords': instance.totalRecords,
      'commodityData':
          instance.commodityData?.map((e) => e?.toJson())?.toList(),
    };

Commodity _$CommodityFromJson(Map<String, dynamic> json) {
  return Commodity(
    json['id'] as int,
    json['name'] as String,
    json['shortDescription'] as String,
    json['overview'] as String,
    json['dateOfCreation'] as int,
    json['type'] == null
        ? null
        : CommodityType.fromJson(json['type'] as Map<String, dynamic>),
    (json['images'] as List)?.map((e) => e as String)?.toList(),
    (json['branches'] as List)
        ?.map((e) => e == null
            ? null
            : CommodityBranch.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CommodityToJson(Commodity instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shortDescription': instance.shortDescription,
      'overview': instance.overview,
      'dateOfCreation': instance.dateOfCreation,
      'type': instance.type?.toJson(),
      'images': instance.images,
      'branches': instance.branches?.map((e) => e?.toJson())?.toList(),
    };

CommodityBranch _$CommodityBranchFromJson(Map<String, dynamic> json) {
  return CommodityBranch(
    json['id'] as int,
    json['commodityId'] as int,
    json['amount'] as int,
    (json['price'] as num)?.toDouble(),
    json['currency'] as String,
    (json['attributes'] as List)
        ?.map((e) =>
            e == null ? null : AttributeDto.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CommodityBranchToJson(CommodityBranch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'commodityId': instance.commodityId,
      'amount': instance.amount,
      'price': instance.price,
      'currency': instance.currency,
      'attributes': instance.attributes?.map((e) => e?.toJson())?.toList(),
    };

AttributeDto _$AttributeDtoFromJson(Map<String, dynamic> json) {
  return AttributeDto(
    json['name'] as String,
    json['value'] as String,
    json['measure'] as String,
  );
}

Map<String, dynamic> _$AttributeDtoToJson(AttributeDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'measure': instance.measure,
    };
