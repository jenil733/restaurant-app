import '../../data/models/reject_order_model.dart';

abstract class RejectOrderRepository {
  Future<RejectOrderResponseModel> rejectOrder({
    required dynamic orderId,
    required String rejectionReason,
  });
}
