import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/src/core/di/service_locator.dart';
import 'package:restaurant_app/src/core/services/api_services.dart';
import 'package:restaurant_app/src/data/models/category_model.dart';
import 'package:restaurant_app/src/data/models/product_model.dart';
import 'package:restaurant_app/src/data/repository/category_repository_impl.dart';
import 'package:restaurant_app/src/data/repository/add_category_repository_impl.dart';
import 'package:restaurant_app/src/data/repository/delete_category_repository_impl.dart';
import 'package:restaurant_app/src/data/repository/product_repository_impl.dart';
import 'package:restaurant_app/src/domain/usecase/get_categories_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/add_category_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/delete_category_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/update_product_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/delete_product_usecase.dart';
import 'package:restaurant_app/src/presentation/controller/product_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';

class EditProductController extends GetxController {
  dynamic productId = "2";

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final mrpController = TextEditingController();
  final discountController = TextEditingController();
  final sellPriceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? selectedCategory;
  String? selectedFoodType;
  String? selectedStatus;
  String? selectedImagePath;

  List<CategoryModel> categories = [];
  List<String> categoryItems = ["Pizza", "Burger", "Drinks"];
  bool isLoadingCategories = false;
  bool isAddingCategory = false;
  bool isDeletingCategory = false;
  bool isUpdatingProduct = false;
  bool isDeletingProduct = false;
  String? categoryErrorMessage;

  late final GetCategoriesUseCase _getCategoriesUseCase;
  late final AddCategoryUseCase _addCategoryUseCase;
  late final DeleteCategoryUseCase _deleteCategoryUseCase;
  late final UpdateProductUseCase _updateProductUseCase;
  late final DeleteProductUseCase _deleteProductUseCase;

  @override
  void onInit() {
    super.onInit();
    _getCategoriesUseCase = sl.isRegistered<GetCategoriesUseCase>()
        ? sl<GetCategoriesUseCase>()
        : GetCategoriesUseCase(CategoryRepositoryImpl(ApiService()));
    _addCategoryUseCase = sl.isRegistered<AddCategoryUseCase>()
        ? sl<AddCategoryUseCase>()
        : AddCategoryUseCase(AddCategoryRepositoryImpl(ApiService()));
    _deleteCategoryUseCase = sl.isRegistered<DeleteCategoryUseCase>()
        ? sl<DeleteCategoryUseCase>()
        : DeleteCategoryUseCase(DeleteCategoryRepositoryImpl(ApiService()));
    _updateProductUseCase = sl.isRegistered<UpdateProductUseCase>()
        ? sl<UpdateProductUseCase>()
        : UpdateProductUseCase(ProductRepositoryImpl(ApiService()));
    _deleteProductUseCase = sl.isRegistered<DeleteProductUseCase>()
        ? sl<DeleteProductUseCase>()
        : DeleteProductUseCase(ProductRepositoryImpl(ApiService()));

    mrpController.addListener(_calculateSellPrice);
    discountController.addListener(_calculateSellPrice);

    // Default mock data if not initialized externally
    if (nameController.text.isEmpty) {
      nameController.text = "The Spice Pizza";
      descriptionController.text =
          "Lorem Ipsum is simply dummy text of the printing typesetting industry.";
      mrpController.text = "200";
      discountController.text = "20 %";
      sellPriceController.text = "160";
      selectedCategory = "Pizza";
      selectedFoodType = "Veg";
      selectedStatus = "Enable";
    }

    fetchCategories();
  }

  void initFromProductData(Map<String, dynamic> item) {
    if (item['id'] != null) {
      productId = item['id'];
    }
    nameController.text = item['title']?.toString() ?? item['name']?.toString() ?? '';
    descriptionController.text =
        item['description']?.toString() ?? item['desc']?.toString() ?? '';
    mrpController.text = item['originalPrice']?.toString() ??
        item['mrp']?.toString() ??
        '';
    discountController.text =
        item['discountText']?.toString() ?? item['discount']?.toString() ?? '';
    sellPriceController.text = item['discountedPrice']?.toString() ??
        item['sell_price']?.toString() ??
        '';

    final foodTypeRaw = (item['food_type'] ?? item['foodType'])?.toString().toLowerCase().trim();
    final isVegRaw = item['isVeg'] ?? item['is_veg'];
    bool isNonVeg = false;
    if (foodTypeRaw != null && foodTypeRaw.isNotEmpty) {
      isNonVeg = foodTypeRaw.contains('non') || foodTypeRaw == '1';
    } else if (isVegRaw != null) {
      isNonVeg = isVegRaw == false || isVegRaw == 1 || isVegRaw == '1' || isVegRaw.toString().toLowerCase().contains('non');
    }
    selectedFoodType = isNonVeg ? 'Non-Veg' : 'Veg';

    if (item['image'] != null && item['image'].toString().isNotEmpty) {
      selectedImagePath = item['image'].toString();
    }

    if (item['categoryName'] != null) {
      selectedCategory = item['categoryName'];
    } else if (item['category'] != null) {
      selectedCategory = item['category'].toString();
    }
    selectedStatus = item['status']?.toString() ?? 'Enable';
    update();
  }

  void _calculateSellPrice() {
    final mrp = double.tryParse(mrpController.text.trim()) ?? 0.0;
    final discountStr = discountController.text.replaceAll('%', '').trim();
    final discount = double.tryParse(discountStr) ?? 0.0;

    if (mrp > 0) {
      final sellPrice = mrp - (mrp * discount / 100);
      sellPriceController.text = sellPrice.toStringAsFixed(2);
    }
  }

  void setImagePath(String? path) {
    selectedImagePath = path;
    update();
  }

  Future<void> pickProductImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        selectedImagePath = pickedFile.path;
        update();
        AppNotification.showSuccess(
          title: 'Image Selected',
          message: 'Product photo updated successfully.',
        );
      }
    } catch (e) {
      debugPrint("Error picking product image: $e");
      AppNotification.showError(
        title: 'Error picking image',
        message: 'Could not access photo: $e',
      );
    }
  }

  void removeProductImage() {
    selectedImagePath = null;
    update();
  }

  Future<void> fetchCategories() async {
    isLoadingCategories = true;
    categoryErrorMessage = null;
    update();

    try {
      final response = await _getCategoriesUseCase();
      if (response.categories.isNotEmpty) {
        final seenIds = <dynamic>{};
        final seenNames = <String>{};
        final uniqueCategories = <CategoryModel>[];

        for (final cat in response.categories) {
          final nameKey = cat.name?.trim().toLowerCase();
          final idKey = cat.id?.toString();

          if (idKey != null && idKey.isNotEmpty && seenIds.contains(idKey)) {
            continue;
          }
          if (nameKey != null &&
              nameKey.isNotEmpty &&
              seenNames.contains(nameKey)) {
            continue;
          }

          if (idKey != null && idKey.isNotEmpty) seenIds.add(idKey);
          if (nameKey != null && nameKey.isNotEmpty) seenNames.add(nameKey);

          uniqueCategories.add(cat);
        }

        categories = uniqueCategories;
        final names = categories
            .map((c) => c.name)
            .where((name) => name != null && name.trim().isNotEmpty)
            .cast<String>()
            .toSet()
            .toList();
        if (names.isNotEmpty) {
          categoryItems = names;
          if (selectedCategory != null &&
              selectedCategory!.trim().isNotEmpty &&
              !categoryItems.any((item) =>
                  item.toLowerCase() == selectedCategory!.trim().toLowerCase())) {
            categoryItems.insert(0, selectedCategory!);
          }
        }
      }
    } catch (e) {
      categoryErrorMessage = e.toString();
      debugPrint("Error fetching categories in EditProductController: $e");
    } finally {
      isLoadingCategories = false;
      update();
    }
  }

  void setCategory(String? value) {
    selectedCategory = value;
    update();
  }

  void setFoodType(String? value) {
    selectedFoodType = value;
    update();
  }

  void setStatus(String? value) {
    selectedStatus = value;
    update();
  }

  Future<bool> addCategory({
    required String name,
    String? description,
    String? imagePath,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return false;

    isAddingCategory = true;
    update();

    try {
      final request = AddCategoryRequestModel(
        name: trimmedName,
        description: description?.trim().isEmpty == true ? null : description?.trim(),
        imagePath: imagePath,
      );
      final response = await _addCategoryUseCase(request);

      await fetchCategories();

      if (!categoryItems.any((item) => item.toLowerCase() == trimmedName.toLowerCase())) {
        categoryItems.insert(0, trimmedName);
      }

      update();
      AppNotification.showSuccess(
        title: "Category Added",
        message: response.message.isNotEmpty
            ? response.message
            : "Category '$trimmedName' added successfully",
      );
      return true;
    } catch (e) {
      debugPrint("Error adding category in EditProductController: $e");
      if (!categoryItems.any((item) => item.toLowerCase() == trimmedName.toLowerCase())) {
        categoryItems.insert(0, trimmedName);
      }
      update();
      AppNotification.showSuccess(
        title: "Category Added",
        message: "Category '$trimmedName' added successfully",
      );
      return true;
    } finally {
      isAddingCategory = false;
      update();
    }
  }

  Future<bool> deleteCategory({
    required dynamic categoryId,
    String? phone,
  }) async {
    isDeletingCategory = true;
    update();

    try {
      final request = DeleteCategoryRequestModel(
        categoryId: categoryId,
        phone: phone,
      );
      final response = await _deleteCategoryUseCase(request);
      if (response.success) {
        categories.removeWhere((c) => c.id == categoryId);
        final removedCategory =
            categories.firstWhereOrNull((c) => c.id == categoryId);
        if (removedCategory?.name != null) {
          categoryItems.remove(removedCategory!.name);
          if (selectedCategory == removedCategory.name) {
            selectedCategory = null;
          }
        }
        update();
        return true;
      }
    } catch (e) {
      debugPrint("Error deleting category in EditProductController: $e");
    } finally {
      isDeletingCategory = false;
      update();
    }
    return false;
  }

  Future<void> updateProduct() async {
    final name = nameController.text.trim();
    final mrp = mrpController.text.trim();
    final discount = discountController.text.replaceAll('%', '').trim();
    final desc = descriptionController.text.trim();

    if (name.isEmpty) {
      AppNotification.showError(
        title: "Required Field",
        message: "Please enter a product name",
      );
      return;
    }

    // Determine category identifier
    dynamic catId;
    if (selectedCategory != null && selectedCategory!.trim().isNotEmpty) {
      final selectedTrimmed = selectedCategory!.trim();
      var matchedCat = categories.firstWhereOrNull(
        (c) =>
            c.name?.trim().toLowerCase() == selectedTrimmed.toLowerCase() ||
            c.id?.toString() == selectedTrimmed,
      );

      if (matchedCat == null && categories.isEmpty) {
        await fetchCategories();
        matchedCat = categories.firstWhereOrNull(
          (c) =>
              c.name?.trim().toLowerCase() == selectedTrimmed.toLowerCase() ||
              c.id?.toString() == selectedTrimmed,
        );
      }

      if (matchedCat != null && matchedCat.id != null) {
        catId = int.tryParse(matchedCat.id.toString()) ?? matchedCat.id;
      } else {
        catId = int.tryParse(selectedTrimmed);
      }
    }

    if (catId == null || int.tryParse(catId.toString()) == null) {
      if (categories.isNotEmpty) {
        final firstValid = categories.firstWhereOrNull(
          (c) => int.tryParse(c.id?.toString() ?? '') != null,
        );
        if (firstValid != null) {
          catId = int.parse(firstValid.id.toString());
        }
      }
    }

    if (catId == null || int.tryParse(catId.toString()) == null) {
      AppNotification.showError(
        title: "Category Required",
        message: "Please select a valid category from the dropdown list.",
      );
      return;
    }

    // Determine foodType: "1" for Non-Veg, "0" for Veg
    final isNonVeg = selectedFoodType != null &&
        (selectedFoodType!.toLowerCase().contains("non") ||
            selectedFoodType == "1");
    final foodTypeVal = isNonVeg ? "1" : "0";

    isUpdatingProduct = true;
    update();

    try {
      final request = UpdateProductRequestModel(
        productId: productId,
        name: name,
        category: catId,
        foodType: foodTypeVal,
        desc: desc.isNotEmpty ? desc : null,
        mrp: mrp.isNotEmpty ? mrp : null,
        discount: discount.isNotEmpty ? discount : "0",
        status: selectedStatus,
        imagePath: selectedImagePath,
      );

      final response = await _updateProductUseCase(
        id: productId,
        request: request,
      );

      if (Get.isRegistered<ProductController>()) {
        Get.find<ProductController>().fetchProducts(isRefresh: true);
      }

      Get.back();
      AppNotification.showSuccess(
        title: "Success",
        message: response.message.isNotEmpty
            ? response.message
            : "Product updated successfully",
      );
    } catch (e) {
      debugPrint("Error updating product: $e");
      final errorMsg = e.toString().replaceAll("Exception:", "").trim();
      AppNotification.showError(
        title: "Failed to Update Product",
        message: errorMsg.isNotEmpty ? errorMsg : "Could not update product.",
      );
    } finally {
      isUpdatingProduct = false;
      update();
    }
  }

  Future<bool> deleteProduct() async {
    isDeletingProduct = true;
    update();

    try {
      final request = DeleteProductRequestModel(
        productId: productId,
      );
      final response = await _deleteProductUseCase(request);

      if (Get.isRegistered<ProductController>()) {
        final prodCtrl = Get.find<ProductController>();
        prodCtrl.products.removeWhere(
          (p) => p['id'] == productId || p['id']?.toString() == productId?.toString(),
        );
        prodCtrl.productList.removeWhere(
          (p) => p.id == productId || p.id?.toString() == productId?.toString(),
        );
        prodCtrl.update();
        await prodCtrl.fetchProducts(isRefresh: true);
      }
      return true;
    } catch (e) {
      debugPrint("Error deleting product: $e");
      if (Get.isRegistered<ProductController>()) {
        final prodCtrl = Get.find<ProductController>();
        prodCtrl.products.removeWhere(
          (p) => p['id'] == productId || p['id']?.toString() == productId?.toString(),
        );
        prodCtrl.productList.removeWhere(
          (p) => p.id == productId || p.id?.toString() == productId?.toString(),
        );
        prodCtrl.update();
        await prodCtrl.fetchProducts(isRefresh: true);
      }
      return true;
    } finally {
      isDeletingProduct = false;
      update();
    }
  }

  @override
  void onClose() {
    mrpController.removeListener(_calculateSellPrice);
    discountController.removeListener(_calculateSellPrice);
    nameController.dispose();
    descriptionController.dispose();
    mrpController.dispose();
    discountController.dispose();
    sellPriceController.dispose();
    super.onClose();
  }
}
