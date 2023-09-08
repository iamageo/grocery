const baseUrl = "https://parseapi.back4app.com/functions";

abstract class ApiEndPoints {

  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/signup";
  static const String validate = "$baseUrl/validate-token";
  static const String resetPassword = "$baseUrl/reset-password";
  static const String getAllCategories = "$baseUrl/get-category-list";
  static const String getAllProducts = "$baseUrl/get-product-list";
  static const String getCartItems = '$baseUrl/get-cart-items';
  static const String addItemToCart = '$baseUrl/add-item-to-cart';
  static const String changeItemQuantity = '$baseUrl/modify-item-quantity';
  static const String checkout = '$baseUrl/checkout';
  static const String getAllOrders = '$baseUrl/get-orders';
  static const String getOrderItems = '$baseUrl/get-order-items';
  static const String changePassword = '$baseUrl/change-password';
}
