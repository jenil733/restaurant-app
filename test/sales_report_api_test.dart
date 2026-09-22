import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/sales_report_model.dart';
import 'package:restaurant_app/src/domain/repository/sales_report_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_sales_report_usecase.dart';

class MockSalesReportRepository implements SalesReportRepository {
  bool wasCalled = false;
  String? lastFromDate;
  String? lastToDate;
  bool shouldThrow = false;
  String errorMessage = 'Error fetching sales report';

  @override
  Future<SalesReportResponseModel> getSalesReport({
    required String fromDate,
    required String toDate,
  }) async {
    wasCalled = true;
    lastFromDate = fromDate;
    lastToDate = toDate;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return SalesReportResponseModel(
      success: true,
      message: 'Request successful',
      data: SalesReportDataModel(
        totalSales: 15400.50,
        totalOrders: 120,
        avgOrder: 128.3,
        customers: 85,
        recentOrders: [
          SalesReportOrderModel(
            id: 101,
            orderId: '#ORD101',
            productName: 'Chicken Biriyani',
            quantity: 2,
            status: 'Completed',
            amount: 500,
          ),
          SalesReportOrderModel(
            id: 102,
            orderId: '#ORD102',
            productName: 'Veg Burger',
            quantity: 1,
            status: 'Pending',
            amount: 150,
          ),
        ],
      ),
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Sales Report API & Domain Unit Tests', () {
    test('ApiRoutes contains salesReport endpoint', () {
      expect(ApiRoutes.salesReport, '/sales_report');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('SalesReportResponseModel parses live server response correctly', () {
      final json = {
        "success": true,
        "data": {
          "total_sales": 25000,
          "total_orders": 150,
          "avg_order": 166.6,
          "customers": 90,
          "recent_orders": [
            {
              "id": 1,
              "order_id": "#1001",
              "product_name": "Chicken Biriyani",
              "quantity": 2,
              "status": "Pending",
              "amount": 350
            }
          ]
        },
        "message": "Request successful",
        "code": 200
      };

      final response = SalesReportResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Request successful');
      expect(response.data, isNotNull);
      expect(response.data?.totalSales, 25000);
      expect(response.data?.totalOrders, 150);
      expect(response.data?.avgOrder, 166.6);
      expect(response.data?.customers, 90);
      expect(response.data?.recentOrders.length, 1);

      final firstOrder = response.data!.recentOrders.first;
      expect(firstOrder.orderId, '#1001');
      expect(firstOrder.productName, 'Chicken Biriyani');
      expect(firstOrder.quantity, 2);
      expect(firstOrder.status, 'Pending');
      expect(firstOrder.amount, 350);
    });

    test('SalesReportResponseModel parses empty data correctly', () {
      final json = {
        "success": true,
        "data": {
          "total_sales": 0,
          "total_orders": 0,
          "avg_order": 0,
          "customers": 0,
          "recent_orders": []
        },
        "message": "Request successful",
        "code": 200
      };

      final response = SalesReportResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.data?.totalSales, 0);
      expect(response.data?.totalOrders, 0);
      expect(response.data?.recentOrders, isEmpty);
    });

    test('GetSalesReportUseCase delegates request to SalesReportRepository', () async {
      final mockRepo = MockSalesReportRepository();
      final useCase = GetSalesReportUseCase(mockRepo);

      final result = await useCase(
        fromDate: '2026-09-01',
        toDate: '2026-09-03',
      );

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastFromDate, '2026-09-01');
      expect(mockRepo.lastToDate, '2026-09-03');
      expect(result.success, isTrue);
      expect(result.data?.totalOrders, 120);
      expect(result.data?.recentOrders.length, 2);
    });

    test('GetSalesReportUseCase handles repository failure', () async {
      final mockRepo = MockSalesReportRepository()..shouldThrow = true;
      final useCase = GetSalesReportUseCase(mockRepo);

      expect(
        () => useCase(
          fromDate: '2026-09-01',
          toDate: '2026-09-03',
        ),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
