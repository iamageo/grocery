import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.g.dart';

@JsonSerializable()
class ItemModel {
  String id;

  @JsonKey(name: 'title')
  String itemName;

  @JsonKey(name: 'picture')
  String imgUrl;

  String unit;
  double price;
  String description;

  ItemModel({
      required this.id,
      required this.itemName,
      required this.imgUrl,
      required this.unit,
      required this.price,
      required this.description
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => _$ItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$ItemModelToJson(this);

  @override
  String toString() {
    return 'ItemModel{id: $id, itemName: $itemName, imgUrl: $imgUrl, unit: $unit, price: $price, description: $description}';
  }

}
