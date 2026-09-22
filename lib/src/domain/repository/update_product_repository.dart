import '../../data/models/update_product_model.dart';

abstract class UpdateProductRepository {
  Future<UpdateProductResponseModel> updateProduct(dynamic id, UpdateProductRequestModel request);
}
