import '../../data/models/order_invoice_model.dart';

abstract class OrderInvoiceRepository {
  Future<OrderInvoiceResponseModel> getOrderInvoice(dynamic orderId);
}
