import '../../data/models/category_model.dart';
import 'add_category_repository.dart';
import 'delete_category_repository.dart';

export 'add_category_repository.dart';
export 'delete_category_repository.dart';

abstract class CategoryRepository implements AddCategoryRepository, DeleteCategoryRepository {
  Future<CategoryResponseModel> getCategories({Map<String, dynamic>? queryParams});
  @override
  Future<AddCategoryResponseModel> addCategory(AddCategoryRequestModel request);
  @override
  Future<DeleteCategoryResponseModel> deleteCategory(DeleteCategoryRequestModel request);
}
