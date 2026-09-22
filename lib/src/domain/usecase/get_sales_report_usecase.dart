import '../../data/models/sales_report_model.dart';
import '../repository/sales_report_repository.dart';

class GetSalesReportUseCase {
  final SalesReportRepository _repository;

  GetSalesReportUseCase(this._repository);

  Future<SalesReportResponseModel> call({
    required String fromDate,
    required String toDate,
  }) {
    return _repository.getSalesReport(
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
