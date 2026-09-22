import '../../data/models/accept_order_model.dart';

abstract class AcceptOrderRepository {
  Future<AcceptOrderResponseModel> acceptOrder(dynamic orderId);
}
