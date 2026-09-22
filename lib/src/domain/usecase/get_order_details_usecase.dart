import '../../data/models/order_detail_model.dart';
import '../repository/order_detail_repository.dart';

class GetOrderDetailsUseCase {
  final OrderDetailRepository _repository;

  GetOrderDetailsUseCase(this._repository);

  Future<OrderDetailResponseModel> call(dynamic orderId) {
    return _repository.getOrderDetails(orderId);
  }
}
