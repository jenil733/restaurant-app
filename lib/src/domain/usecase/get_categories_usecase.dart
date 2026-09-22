import '../../data/models/category_model.dart';
import '../repository/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<CategoryResponseModel> call({Map<String, dynamic>? queryParams}) {
    return _repository.getCategories(queryParams: queryParams);
  }
}
