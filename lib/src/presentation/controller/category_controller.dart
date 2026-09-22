import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/src/core/di/service_locator.dart';
import 'package:restaurant_app/src/core/services/api_services.dart';
import 'package:restaurant_app/src/data/models/category_model.dart';
import 'package:restaurant_app/src/data/repository/add_category_repository_impl.dart';
import 'package:restaurant_app/src/data/repository/category_repository_impl.dart';
import 'package:restaurant_app/src/data/repository/delete_category_repository_impl.dart';
import 'package:restaurant_app/src/domain/usecase/add_category_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/delete_category_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/get_categories_usecase.dart';
import 'package:restaurant_app/src/presentation/controller/add_product_controller.dart';
import 'package:restaurant_app/src/presentation/controller/edit_product_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/app_notification.dart';
import 'package:restaurant_app/src/core/utils/helper/approval_helper.dart';

class CategoryController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final searchController = TextEditingController();
  final addNameController = TextEditingController();
  final addDescController = TextEditingController();

  List<CategoryModel> categories = [];
  List<CategoryModel> filteredCategories = [];
  bool isLoading = false;
  bool isAddingCategory = false;
  bool isDeletingCategory = false;
  String? errorMessage;
  String? selectedImagePath;
  String searchQuery = '';

  late final GetCategoriesUseCase _getCategoriesUseCase;
  late final AddCategoryUseCase _addCategoryUseCase;
  late final DeleteCategoryUseCase _deleteCategoryUseCase;

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

    fetchCategories();
  }

  Future<void> fetchCategories({bool isRefresh = false}) async {
    if (!isRefresh) {
      isLoading = true;
      errorMessage = null;
      update();
    }

    try {
      final response = await _getCategoriesUseCase();
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
      _applyFilter();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("Error fetching categories: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  void searchCategories(String query) {
    searchQuery = query.trim().toLowerCase();
    _applyFilter();
    update();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery = '';
    _applyFilter();
    update();
  }

  void _applyFilter() {
    if (searchQuery.isEmpty) {
      filteredCategories = List.from(categories);
    } else {
      filteredCategories = categories.where((category) {
        final name = category.name?.toLowerCase() ?? '';
        final desc = category.description?.toLowerCase() ?? '';
        return name.contains(searchQuery) || desc.contains(searchQuery);
      }).toList();
    }
  }

  Future<void> pickCategoryImage(ImageSource source) async {
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
          message: 'Category photo selected successfully.',
        );
      }
    } catch (e) {
      debugPrint("Error picking category image: $e");
      AppNotification.showError(
        title: 'Error picking image',
        message: 'Could not access photo: $e',
      );
    }
  }

  void removeCategoryImage() {
    selectedImagePath = null;
    update();
  }

  void resetAddForm() {
    addNameController.clear();
    addDescController.clear();
    selectedImagePath = null;
    update();
  }

  Future<bool> addCategory({
    String? name,
    String? description,
    String? imagePath,
  }) async {
    if (!isRestaurantApproved()) {
      AppNotification.showError(
        title: 'Account Verification Pending',
        message: 'You will be able to add categories once your restaurant registration is approved by the admin.',
      );
      return false;
    }

    final catName = (name ?? addNameController.text).trim();
    final catDesc = (description ?? addDescController.text).trim();
    final imgPath = imagePath ?? selectedImagePath;

    if (catName.isEmpty) {
      AppNotification.showError(
        title: 'Required Field',
        message: 'Please enter category name.',
      );
      return false;
    }

    isAddingCategory = true;
    update();

    try {
      final request = AddCategoryRequestModel(
        name: catName,
        description: catDesc.isNotEmpty ? catDesc : null,
        imagePath: imgPath,
      );

      final response = await _addCategoryUseCase(request);

      // Refresh category list from server
      await fetchCategories(isRefresh: true);

      // If server list did not include the new category, add it once
      final exists = categories.any(
        (c) => c.name?.trim().toLowerCase() == catName.toLowerCase(),
      );
      if (!exists) {
        categories.insert(
          0,
          response.category ??
              CategoryModel(
                name: catName,
                description: catDesc.isNotEmpty ? catDesc : null,
                image: imgPath,
              ),
        );
        _applyFilter();
      }

      // Sync with AddProductController if active
      if (Get.isRegistered<AddProductController>()) {
        final addProductCtrl = Get.find<AddProductController>();
        await addProductCtrl.fetchCategories();
        if (!addProductCtrl.categoryItems.any((item) => item.toLowerCase() == catName.toLowerCase())) {
          addProductCtrl.categoryItems.insert(0, catName);
        }
        addProductCtrl.update();
      }

      // Sync with EditProductController if active
      if (Get.isRegistered<EditProductController>()) {
        final editProductCtrl = Get.find<EditProductController>();
        await editProductCtrl.fetchCategories();
        if (!editProductCtrl.categoryItems.any((item) => item.toLowerCase() == catName.toLowerCase())) {
          editProductCtrl.categoryItems.insert(0, catName);
        }
        editProductCtrl.update();
      }

      resetAddForm();
      return true;
    } catch (e) {
      debugPrint("Error adding category: $e");
      final errorMsg = e.toString().replaceAll("Exception:", "").replaceAll("ServerFailure:", "").trim();

      // Check if the category already exists on the server (e.g. duplicate name 500 error)
      await fetchCategories(isRefresh: true);
      final existsOnServer = categories.any(
        (c) => c.name?.trim().toLowerCase() == catName.toLowerCase(),
      );

      if (existsOnServer) {
        if (Get.isRegistered<AddProductController>()) {
          final addProductCtrl = Get.find<AddProductController>();
          await addProductCtrl.fetchCategories();
          if (!addProductCtrl.categoryItems.any((item) => item.toLowerCase() == catName.toLowerCase())) {
            addProductCtrl.categoryItems.insert(0, catName);
          }
          addProductCtrl.update();
        }
        if (Get.isRegistered<EditProductController>()) {
          final editProductCtrl = Get.find<EditProductController>();
          await editProductCtrl.fetchCategories();
          if (!editProductCtrl.categoryItems.any((item) => item.toLowerCase() == catName.toLowerCase())) {
            editProductCtrl.categoryItems.insert(0, catName);
          }
          editProductCtrl.update();
        }
        resetAddForm();
        return true;
      }

      AppNotification.showError(
        title: 'Failed to Add Category',
        message: errorMsg.isNotEmpty ? errorMsg : 'Could not add category on server.',
      );
      return false;
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
        final removedCategory =
            categories.firstWhereOrNull((c) => c.id == categoryId);
        categories.removeWhere((c) => c.id == categoryId);
        _applyFilter();

        if (removedCategory?.name != null &&
            Get.isRegistered<AddProductController>()) {
          final addProductCtrl = Get.find<AddProductController>();
          addProductCtrl.categoryItems.remove(removedCategory!.name);
          if (addProductCtrl.selectedCategory == removedCategory.name) {
            addProductCtrl.selectedCategory = null;
          }
          addProductCtrl.update();
        }

        AppNotification.showDeleted(
          title: 'Deleted',
          message: response.message.isNotEmpty
              ? response.message
              : 'Category deleted successfully.',
        );
        return true;
      } else {
        AppNotification.showError(
          title: 'Delete Failed',
          message: response.message.isNotEmpty
              ? response.message
              : 'Could not delete category.',
        );
        return false;
      }
    } catch (e) {
      debugPrint("Error deleting category: $e");
      final errorMsg = e.toString().replaceAll("Exception:", "").trim();
      AppNotification.showError(
        title: 'Delete Failed',
        message: errorMsg.isNotEmpty ? errorMsg : 'Could not delete category.',
      );
      return false;
    } finally {
      isDeletingCategory = false;
      update();
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    addNameController.dispose();
    addDescController.dispose();
    super.onClose();
  }
}
