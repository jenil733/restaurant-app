import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/utils/helper/image_helper.dart';
import 'package:restaurant_app/src/data/models/category_model.dart';
import 'package:restaurant_app/src/presentation/controller/category_controller.dart';
import 'package:restaurant_app/src/presentation/view/products/add_category_screen.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';

import 'package:restaurant_app/src/core/utils/helper/approval_helper.dart';

class CategoryScreen extends StatelessWidget {
  final bool selectMode;
  final ValueChanged<CategoryModel>? onCategorySelected;

  const CategoryScreen({
    super.key,
    this.selectMode = false,
    this.onCategorySelected,
  });

  void _onAddCategory(BuildContext context, CategoryController controller) {
    if (!isRestaurantApproved()) {
      showApprovalRequiredDialog(context, action: 'add categories');
      return;
    }
    controller.resetAddForm();
    Get.to(() => const AddCategoryScreen());
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<CategoryController>()
        ? Get.find<CategoryController>()
        : Get.put(CategoryController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Category",
        actionText: "Add Category",
        onActionPressed: () => _onAddCategory(context, controller),
      ),
      body: GetBuilder<CategoryController>(
        builder: (controller) {
          return SafeArea(
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.searchCategories,
                      decoration: InputDecoration(
                        hintText: "Search categories...",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Colors.grey,
                          size: 22,
                        ),
                        suffixIcon: controller.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                onPressed: controller.clearSearch,
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                // Category Count Info
                if (!controller.isLoading && controller.categories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Total Categories (${controller.filteredCategories.length})",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),

                // Main Content
                Expanded(
                  child: _buildBody(context, controller),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, CategoryController controller) {
    if (controller.isLoading && controller.categories.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (controller.filteredCategories.isEmpty) {
      final isSearching = controller.searchQuery.isNotEmpty;
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => controller.fetchCategories(isRefresh: true),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isSearching
                              ? Icons.search_off_rounded
                              : Icons.category_outlined,
                          size: 42,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        isSearching
                            ? "No Matching Categories"
                            : "No Categories Found",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textprimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isSearching
                            ? "No category matches '${controller.searchQuery}'. Try another keyword."
                            : "Add categories to organize your food menu and make item selection easy.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: isSearching
                            ? controller.clearSearch
                            : () => _onAddCategory(context, controller),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: Icon(
                          isSearching ? Icons.clear_rounded : Icons.add_rounded,
                          size: 20,
                        ),
                        label: Text(
                          isSearching ? "Clear Search" : "Add Category",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => controller.fetchCategories(isRefresh: true),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        itemCount: controller.filteredCategories.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final category = controller.filteredCategories[index];
          return _buildCategoryCard(context, controller, category);
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    CategoryController controller,
    CategoryModel category,
  ) {
    final name = category.name ?? 'Unnamed Category';
    final desc = category.description;
    final image = category.image;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onCategorySelected != null
              ? () {
                  onCategorySelected!(category);
                  Get.back();
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Category Image/Icon
                _buildCategoryAvatar(image, name),

                const SizedBox(width: 14),

                // Name & Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textprimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (desc != null && desc.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          desc,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Delete Button (if id exists)
                if (category.id != null)
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                    onPressed: () => _showDeleteCategoryDialog(
                      context,
                      controller,
                      category,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryAvatar(String? image, String name) {
    Widget imageContent = _buildFallbackIcon(name);

    if (image != null &&
        image.trim().isNotEmpty &&
        image.trim().toLowerCase() != 'null') {
      final trimmed = image.trim();

      if (trimmed.startsWith('assets/')) {
        imageContent = Image.asset(
          trimmed,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallbackIcon(name),
        );
      } else {
        bool isLocalFile = false;
        try {
          final file = File(trimmed);
          if (file.existsSync()) {
            isLocalFile = true;
            imageContent = Image.file(
              file,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildFallbackIcon(name),
            );
          }
        } catch (_) {}

        if (!isLocalFile) {
          final resolvedUrl = ImageHelper.getImageUrl(trimmed);
          if (resolvedUrl != null && resolvedUrl.isNotEmpty) {
            imageContent = Image.network(
              resolvedUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildFallbackIcon(name),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.primary,
                    ),
                  ),
                );
              },
            );
          } else {
            imageContent = _buildFallbackIcon(name);
          }
        }
      }
    } else {
      imageContent = _buildFallbackIcon(name);
    }

    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: imageContent,
      ),
    );
  }

  Widget _buildFallbackIcon(String name) {
    final firstChar = name.isNotEmpty ? name[0].toUpperCase() : 'C';
    return Center(
      child: Text(
        firstChar,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  void _showDeleteCategoryDialog(
    BuildContext context,
    CategoryController controller,
    CategoryModel category,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Delete Category",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textprimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Are you sure you want to delete '${category.name ?? 'this category'}'?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await controller.deleteCategory(
                              categoryId: category.id,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Delete"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
