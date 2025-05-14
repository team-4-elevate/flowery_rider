import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'driver.dart';

part 'user_data_model.g.dart';

@JsonSerializable()
class UserDataModel extends Equatable {
  final String? message;
  final DriverData? driver;

  const UserDataModel({this.message, this.driver});

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return _$UserDataModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);

  @override
  List<Object?> get props => [message, driver];
}
