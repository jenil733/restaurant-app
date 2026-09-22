import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/order_invoice_model.dart';
import 'package:restaurant_app/src/domain/repository/order_invoice_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_order_invoice_usecase.dart';

class MockOrderInvoiceRepository implements OrderInvoiceRepository {
  bool wasCalled = false;
  dynamic lastOrderId;
  bool shouldThrow = false;
  String errorMessage = 'Failed to fetch order invoice';

  @override
  Future<OrderInvoiceResponseModel> getOrderInvoice(dynamic orderId) async {
    wasCalled = true;
    lastOrderId = orderId;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return OrderInvoiceResponseModel(
      success: true,
      message: 'Invoice fetched successfully',
      code: 200,
      data: OrderInvoiceDataModel(
        invoiceNo: 'INV-1001',
        orderId: '1',
        customerName: 'John Doe',
        restaurantName: 'Kayal Restaurant',
        subtotal: 500.0,
        tax: 25.0,
        deliveryCharge: 30.0,
        discount: 10.0,
        grandTotal: 545.0,
        invoiceUrl: 'https://pickmysnacks.com/invoices/inv_1001.pdf',
        items: [
          InvoiceItemModel(
            name: 'Chicken Briyani',
            quantity: 2,
            price: 250.0,
            total: 500.0,
          ),
        ],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Order Invoice API & Domain Unit Tests', () {
    test('ApiRoutes contains orderInvoice endpoint', () {
      expect(ApiRoutes.orderInvoice, '/order_invoice');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('OrderInvoiceResponseModel parses standard invoice data response', () {
      final json = {
        "success": true,
        "message": "Invoice details retrieved",
        "code": 200,
        "data": {
          "invoice_no": "INV-2026-001",
          "order_id": "1",
          "date": "2026-09-21",
          "invoice_url": "https://example.com/invoice/1.pdf",
          "customer_name": "Alice Smith",
          "customer_phone": "9876543210",
          "restaurant_name": "Kayal Seafoods",
          "subtotal": 400.0,
          "tax": 20.0,
          "delivery_charge": 40.0,
          "discount": 0.0,
          "grand_total": 460.0,
          "payment_status": "Paid",
          "payment_method": "UPI",
          "items": [
            {
              "name": "Fish Curry Meals",
              "qty": 2,
              "price": 200.0,
              "total": 400.0
            }
          ]
        }
      };

      final response = OrderInvoiceResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Invoice details retrieved');
      expect(response.data, isNotNull);
      expect(response.data!.invoiceNo, 'INV-2026-001');
      expect(response.data!.customerName, 'Alice Smith');
      expect(response.data!.restaurantName, 'Kayal Seafoods');
      expect(response.data!.grandTotal, 460.0);
      expect(response.data!.items.length, 1);
      expect(response.data!.items.first.name, 'Fish Curry Meals');
      expect(response.data!.invoiceUrl, 'https://example.com/invoice/1.pdf');
    });

    test('OrderInvoiceResponseModel parses direct URL string response', () {
      final json = {
        "status": "success",
        "message": "Invoice URL",
        "data": "https://example.com/invoices/direct.pdf"
      };

      final response = OrderInvoiceResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.data, isNotNull);
      expect(response.data!.invoiceUrl, 'https://example.com/invoices/direct.pdf');
      expect(response.data!.downloadUrl, 'https://example.com/invoices/direct.pdf');
    });

    test('GetOrderInvoiceUseCase delegates order ID to OrderInvoiceRepository', () async {
      final mockRepo = MockOrderInvoiceRepository();
      final useCase = GetOrderInvoiceUseCase(mockRepo);

      final result = await useCase(1);

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastOrderId, 1);
      expect(result.success, isTrue);
      expect(result.data?.invoiceNo, 'INV-1001');
      expect(result.data?.grandTotal, 545.0);
    });

    test('GetOrderInvoiceUseCase handles repository failure', () async {
      final mockRepo = MockOrderInvoiceRepository()..shouldThrow = true;
      final useCase = GetOrderInvoiceUseCase(mockRepo);

      expect(
        () => useCase(1),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
