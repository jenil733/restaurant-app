import '../../data/models/add_product_model.dart';

abstract class AddProductRepository {
  Future<AddProductResponseModel> addProduct(AddProductRequestModel request);
}
