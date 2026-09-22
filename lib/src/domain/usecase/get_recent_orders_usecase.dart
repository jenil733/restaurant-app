import '../../data/models/recent_orders_model.dart';
import '../repository/recent_orders_repository.dart';

class GetRecentOrdersUseCase {
  final RecentOrdersRepository _repository;

  GetRecentOrdersUseCase(this._repository);

  Future<RecentOrdersResponseModel> call() {
    return _repository.getRecentOrders();
  }
}
