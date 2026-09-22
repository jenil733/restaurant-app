import '../../data/models/delete_category_model.dart';
import '../repository/delete_category_repository.dart';

class DeleteCategoryUseCase {
  final DeleteCategoryRepository _repository;

  DeleteCategoryUseCase(this._repository);

  Future<DeleteCategoryResponseModel> call(DeleteCategoryRequestModel request) {
    return _repository.deleteCategory(request);
  }
}
