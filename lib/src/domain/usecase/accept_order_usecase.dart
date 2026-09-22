import '../../data/models/accept_order_model.dart';
import '../repository/accept_order_repository.dart';

class AcceptOrderUseCase {
  final AcceptOrderRepository _repository;

  AcceptOrderUseCase(this._repository);

  Future<AcceptOrderResponseModel> call(dynamic orderId) {
    return _repository.acceptOrder(orderId);
  }
}
