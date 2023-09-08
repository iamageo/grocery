import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/constants.dart';
import 'package:grocery/app_colors.dart';
import 'package:grocery/utils/app_data.dart';
import '../../components/custom_shimmer.dart';
import '../base/controller/navigation_controller.dart';
import '../cart/controller/cart_controller.dart';
import 'components/category_item.dart';
import 'components/grid_item.dart';
import 'controller/home_controller_tab.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GlobalKey<CartIconKey> globalKeyCartItems = GlobalKey<CartIconKey>();

  final searchController = TextEditingController();
  final navigationController = Get.find<NavigationController>();

  late Function(GlobalKey) runAddToCardAnimation;

  void itemSelectedCartAnimations(GlobalKey gkImage) {
    runAddToCardAnimation(gkImage);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "Grocery App",
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              right: 15,
            ),
            child: GetBuilder<CartController>(
              builder: (controller) {
                return GestureDetector(
                  onTap: () {
                    navigationController.navigatePageView(NavigationTabs.cart);
                  },
                  child: Badge(
                    backgroundColor: CustomColors.customContrastColor,
                    label: Text(
                      controller.getCartTotalItems().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    child: AddToCartIcon(
                      key: globalKeyCartItems,
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: AddToCartAnimation(
        gkCart: globalKeyCartItems,
        previewDuration: const Duration(milliseconds: 100),
        previewCurve: Curves.ease,
        receiveCreateAddToCardAnimationMethod: (addToCardAnimationMethod) {
          runAddToCardAnimation = addToCardAnimationMethod;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Constants.kPaddingHorizontal,
              vertical: Constants.kPaddingvertical),
          child: Column(
            children: [
              GetBuilder<HomeController>(builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      controller.searchTitle.value = value;
                    },
                    decoration: InputDecoration(
                        suffixIcon: controller.searchTitle.value.isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  searchController.clear();
                                  controller.searchTitle.value = "";
                                  FocusScope.of(context).unfocus();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ))
                            : null,
                        prefixIcon: Icon(
                          Icons.search,
                          color: CustomColors.customContrastColor,
                          size: 21,
                        ),
                        isDense: true,
                        hintText: "Pesquise aqui..",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60),
                            borderSide: const BorderSide(
                                width: 0, style: BorderStyle.solid))),
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              GetBuilder<HomeController>(
                builder: (controller) {
                  return Container(
                    padding: const EdgeInsets.only(left: 10),
                    height: 40,
                    child: !controller.isLoadingCategory
                        ? ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                              return CategoryItem(
                                onPress: () {
                                  controller.selectCategory(
                                      controller.allCategories[index]);
                                },
                                category: controller.allCategories[index].title,
                                isSelected: controller.allCategories[index] ==
                                    controller.selectedCategory,
                              );
                            },
                            separatorBuilder: (_, index) =>
                                const SizedBox(width: 10),
                            itemCount: controller.allCategories.length,
                          )
                        : ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                              10,
                              (index) => Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 12),
                                child: CustomShimmer(
                                  height: 20,
                                  width: 80,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                  );
                },
              ),


              GetBuilder<HomeController>(builder: (controller) {
                return Expanded(
                  child: !controller.isLoadingProducts
                      ? Visibility(
                          visible: (controller.selectedCategory?.items ?? [])
                              .isNotEmpty,
                          replacement: buildEmptySearch(),
                          child: buildGridProducts(controller),
                        )
                      : buildGridShimmer(),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  GridView buildGridProducts(HomeController controller) {
    return GridView.builder(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 9 / 11),
        itemCount: controller.allProducts.length,
        itemBuilder: (_, index) {
          if ((index + 1) == controller.allProducts.length &&
              !controller.isLastPage) {
            controller.loadMoreProducts();
          }

          return GridItem(
            item: controller.allProducts[index],
            cartAnimationMethod: itemSelectedCartAnimations,
          );
        });
  }

  Column buildEmptySearch() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_off,
          size: 40,
          color: CustomColors.customSwatchColor,
        ),
        const Text("Não há itens para apresentar.")
      ],
    );
  }

  GridView buildGridShimmer() {
    return GridView.count(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 9 / 11.5,
      children: List.generate(
        10,
        (index) => CustomShimmer(
          height: double.infinity,
          width: double.infinity,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
