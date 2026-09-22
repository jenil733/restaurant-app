import '../../data/models/delete_product_model.dart';

abstract class DeleteProductRepository {
  Future<DeleteProductResponseModel> deleteProduct(DeleteProductRequestModel request);
}
