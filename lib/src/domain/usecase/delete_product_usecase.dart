import '../../data/models/delete_product_model.dart';
import '../repository/delete_product_repository.dart';

class DeleteProductUseCase {
  final DeleteProductRepository _repository;

  DeleteProductUseCase(this._repository);

  Future<DeleteProductResponseModel> call(DeleteProductRequestModel request) {
    return _repository.deleteProduct(request);
  }
}
