import 'package:grocery/models/category_model.dart';
import 'package:grocery/models/item_model.dart';
import 'package:grocery/models/result/home_result.dart';
import 'package:grocery/services/api_endpoints.dart';
import 'package:grocery/services/http_manager.dart';

class HomeRepository {
  final HttpManager httpManager = HttpManager();

  Future<HomeResult<CategoryModel>> getAllCategories() async {
    final result = await httpManager.restRequest(
        url: ApiEndPoints.getAllCategories, method: HttpMethods.post);

    if (result['result'] != null) {
      List<CategoryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CategoryModel.fromJson)
              .toList();

      return HomeResult.success(data);
    } else {
      return HomeResult.error(
          "Ocorreu um erro inesperado ao recuperar as categorias!");
    }
  }

  Future<HomeResult<ItemModel>> getAllProducts(
      Map<String, dynamic> body) async {
    final result = await httpManager.restRequest(
        url: ApiEndPoints.getAllProducts, method: HttpMethods.post, body: body);

    if (result['result'] != null) {
      List<ItemModel> data = (List<Map<String, dynamic>>.from(result['result']))
          .map(ItemModel.fromJson)
          .toList();

      return HomeResult.success(data);
    } else {
      return HomeResult.error(
          "Ocorreu um erro inesperado ao recuperar as itens!");
    }
  }
}
