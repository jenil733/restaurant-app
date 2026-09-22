import '../../data/models/recent_orders_model.dart';

abstract class RecentOrdersRepository {
  Future<RecentOrdersResponseModel> getRecentOrders();
}
