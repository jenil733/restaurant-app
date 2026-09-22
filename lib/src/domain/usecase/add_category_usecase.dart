import '../../data/models/add_category_model.dart';
import '../repository/add_category_repository.dart';

class AddCategoryUseCase {
  final AddCategoryRepository _repository;

  AddCategoryUseCase(this._repository);

  Future<AddCategoryResponseModel> call(AddCategoryRequestModel request) {
    return _repository.addCategory(request);
  }
}
