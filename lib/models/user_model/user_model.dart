import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.freezed.dart';
part 'user_model.g.dart';



@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String name,
    required String username,
    required String email,
    required Address address,
    required String phone,
    required String website,
    required Company company,
  }) = _UserModel;
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
class Address with _$Address {
  const factory Address({
    required String street,
    required String suite,
    required String city,
    required String zipcode,
    required Geo geo,
  }) = _Address;
  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

@freezed
class Geo with _$Geo {
  const factory Geo({
    required String lat,
    required String lng,
  }) = _Geo;
  factory Geo.fromJson(Map<String, dynamic> json) => _$GeoFromJson(json);
}


@freezed
class Company with _$Company {
   const factory Company({
 required String name,
 required String catchPhrase,
 required String bs,

   }) = _Company;
    factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
}