import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/di/service_locator.dart';
import 'package:restaurant_app/src/core/services/api_services.dart';
import 'package:restaurant_app/src/data/models/product_model.dart';
import 'package:restaurant_app/src/data/repository/product_repository_impl.dart';
import 'package:restaurant_app/src/domain/usecase/get_restaurant_products_usecase.dart';

class ProductController extends GetxController {
  bool isLoading = false;
  String? errorMessage;

  List<ProductModel> productList = [];
  List<Map<String, dynamic>> products = [];

  late final GetRestaurantProductsUseCase _getRestaurantProductsUseCase;

  @override
  void onInit() {
    super.onInit();
    _getRestaurantProductsUseCase =
        sl.isRegistered<GetRestaurantProductsUseCase>()
            ? sl<GetRestaurantProductsUseCase>()
            : GetRestaurantProductsUseCase(ProductRepositoryImpl(ApiService()));
    fetchProducts();
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (!isRefresh) {
      isLoading = true;
      errorMessage = null;
      update();
    }

    try {
      final response = await _getRestaurantProductsUseCase();
      productList = response.products;
      products = response.products.map((p) => p.toCardMap()).toList();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("Error fetching restaurant products: $e");
    } finally {
      isLoading = false;
      update();
    }
  }
}
