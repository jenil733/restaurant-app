import '../../data/models/product_model.dart';
import '../repository/product_repository.dart';

class GetRestaurantProductsUseCase {
  final ProductRepository _repository;

  GetRestaurantProductsUseCase(this._repository);

  Future<ProductResponseModel> call({Map<String, dynamic>? queryParams}) {
    return _repository.getProducts(queryParams: queryParams);
  }
}
