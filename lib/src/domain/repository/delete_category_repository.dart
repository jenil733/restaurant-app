import '../../data/models/delete_category_model.dart';

abstract class DeleteCategoryRepository {
  Future<DeleteCategoryResponseModel> deleteCategory(DeleteCategoryRequestModel request);
}
