import 'package:get/get.dart';
import 'package:grocery/models/category_model.dart';
import 'package:grocery/models/item_model.dart';
import 'package:grocery/models/result/home_result.dart';
import 'package:grocery/ui/pages/home/repository/home_repository.dart';

import '../../../../utils/services.dart';

class HomeController extends GetxController {
  final services = Services();
  final homeRepository = HomeRepository();
  bool isLoadingCategory = false;
  bool isLoadingProducts = true;

  List<CategoryModel> allCategories = [];
  List<ItemModel> get allProducts => selectedCategory?.items ?? [];
  CategoryModel? selectedCategory;

  RxString searchTitle = ''.obs;

  bool get isLastPage {
    if (selectedCategory!.items.length < 6) return true;
    return selectedCategory!.pagination * 6 > allProducts.length;
  }

  void setLoading(bool value, {bool isProduct = false}) {
    if (!isProduct) {
      isLoadingCategory = value;
    } else {
      isLoadingProducts = value;
    }

    update();
  }

  void setLoadingProducts(bool value) {
    isLoadingProducts = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();

    debounce(searchTitle, (callback) {
      filterByTitle();
    }, time: const Duration(milliseconds: 600));

    getAllCategories();
  }

  void selectCategory(CategoryModel categoryModel) {
    selectedCategory = categoryModel;
    update();

    if(selectedCategory!.items.isNotEmpty) return;
    getAllProducts();
  }

  void filterByTitle() {
    for (var category in allCategories) {
      category.items.clear();
      category.pagination = 0;
    }

    if(searchTitle.value.isEmpty) {
      allCategories.removeAt(0);
    } else {
      CategoryModel? c = allCategories.firstWhereOrNull((element) => element.id == '');

      if(c == null) {
        final allProductsCategory = CategoryModel(title: "Todos", id: "", items: [], pagination: 0);
        allCategories.insert(0, allProductsCategory);
      } else {
        c.items.clear();
        c.pagination = 0;
      }
    }

    selectedCategory = allCategories.first;
    update();
    getAllProducts();

  }

  void loadMoreProducts() {
    selectedCategory!.pagination++;

    getAllProducts(canLoad: false);
  }

  Future<void> getAllCategories() async {
    setLoading(true, isProduct: false);
    HomeResult<CategoryModel> homeResult =
        await homeRepository.getAllCategories();
    setLoading(false, isProduct: false);

    homeResult.when(success: (data) {
      allCategories.assignAll(data);

      if (allCategories.isEmpty) return;

      selectCategory(allCategories.first);
    }, error: (message) {
      services.showToast(message: message, isError: true);
    });
  }

  Future<void> getAllProducts({bool canLoad = true}) async {
    Map<String, dynamic> body = {
      'page': selectedCategory!.pagination,
      'categoryId': selectedCategory!.id,
      'itemsPerPage': 6
    };

    if(searchTitle.value.isNotEmpty) {
      body['title'] = searchTitle.value;
      if(selectedCategory!.id == "") {
        body.remove('categoryId');
      }
    }

    if (canLoad) {
      setLoading(true, isProduct: true);
    }
    HomeResult<ItemModel> homeResult =
        await homeRepository.getAllProducts(body);
    setLoading(false, isProduct: true);

    homeResult.when(success: (data) {
      selectedCategory!.items.addAll(data);
    }, error: (message) {
      services.showToast(message: message, isError: true);
    });
  }
}
