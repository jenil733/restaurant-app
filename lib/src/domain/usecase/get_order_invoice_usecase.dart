import '../../data/models/order_invoice_model.dart';
import '../repository/order_invoice_repository.dart';

class GetOrderInvoiceUseCase {
  final OrderInvoiceRepository _repository;

  GetOrderInvoiceUseCase(this._repository);

  Future<OrderInvoiceResponseModel> call(dynamic orderId) {
    return _repository.getOrderInvoice(orderId);
  }
}
