import '../../data/models/product_model.dart';
import 'add_product_repository.dart';
import 'update_product_repository.dart';
import 'delete_product_repository.dart';

export 'add_product_repository.dart';
export 'update_product_repository.dart';
export 'delete_product_repository.dart';

abstract class ProductRepository
    implements AddProductRepository, UpdateProductRepository, DeleteProductRepository {
  Future<ProductResponseModel> getProducts({Map<String, dynamic>? queryParams});
  @override
  Future<AddProductResponseModel> addProduct(AddProductRequestModel request);
  @override
  Future<UpdateProductResponseModel> updateProduct(dynamic id, UpdateProductRequestModel request);
  @override
  Future<DeleteProductResponseModel> deleteProduct(DeleteProductRequestModel request);
}
