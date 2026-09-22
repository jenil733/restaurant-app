import '../../data/models/add_product_model.dart';
import '../repository/add_product_repository.dart';

class AddProductUseCase {
  final AddProductRepository _repository;

  AddProductUseCase(this._repository);

  Future<AddProductResponseModel> call(AddProductRequestModel request) {
    return _repository.addProduct(request);
  }
}
