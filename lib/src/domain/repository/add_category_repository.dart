import '../../data/models/add_category_model.dart';

abstract class AddCategoryRepository {
  Future<AddCategoryResponseModel> addCategory(AddCategoryRequestModel request);
}
