import '../../data/models/update_product_model.dart';
import '../repository/update_product_repository.dart';

class UpdateProductUseCase {
  final UpdateProductRepository _repository;

  UpdateProductUseCase(this._repository);

  Future<UpdateProductResponseModel> call({
    dynamic id,
    required UpdateProductRequestModel request,
  }) {
    return _repository.updateProduct(id ?? request.productId ?? request.id, request);
  }
}
