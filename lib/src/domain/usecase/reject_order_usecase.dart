import '../../data/models/reject_order_model.dart';
import '../repository/reject_order_repository.dart';

class RejectOrderUseCase {
  final RejectOrderRepository _repository;

  RejectOrderUseCase(this._repository);

  Future<RejectOrderResponseModel> call({
    required dynamic orderId,
    required String rejectionReason,
  }) {
    return _repository.rejectOrder(
      orderId: orderId,
      rejectionReason: rejectionReason,
    );
  }
}
