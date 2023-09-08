import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel {
  String? id;
  String? fullname;
  String? email;
  String? phone;
  String? cpf;
  String? token;
  String? password;

  UserModel(
      {this.id, this.fullname, this.email, this.phone, this.cpf, this.token, this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return 'UserModel{id: $id, fullname: $fullname, email: $email, phone: $phone, cpf: $cpf, token: $token, password: $password}';
  }
}