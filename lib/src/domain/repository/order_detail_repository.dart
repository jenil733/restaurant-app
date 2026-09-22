import '../../data/models/order_detail_model.dart';

abstract class OrderDetailRepository {
  Future<OrderDetailResponseModel> getOrderDetails(dynamic orderId);
}
