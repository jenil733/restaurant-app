import '../../data/models/sales_report_model.dart';

abstract class SalesReportRepository {
  Future<SalesReportResponseModel> getSalesReport({
    required String fromDate,
    required String toDate,
  });
}
