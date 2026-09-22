import '../../data/models/orders_model.dart';

abstract class OrderRepository {
  Future<OrdersResponseModel> getOrders({
    String? status,
    int? page,
    int? limit,
    String? search,
  });
}
