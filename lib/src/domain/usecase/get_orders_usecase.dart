import '../../data/models/orders_model.dart';
import '../repository/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository _repository;

  GetOrdersUseCase(this._repository);

  Future<OrdersResponseModel> call({
    String? status,
    int? page,
    int? limit,
    String? search,
  }) {
    return _repository.getOrders(
      status: status,
      page: page,
      limit: limit,
      search: search,
    );
  }
}
