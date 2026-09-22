import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/orders_model.dart';
import 'package:restaurant_app/src/domain/repository/order_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_orders_usecase.dart';

class MockOrderRepository implements OrderRepository {
  bool wasCalled = false;
  String? lastStatus;
  int? lastPage;
  int? lastLimit;
  String? lastSearch;
  bool shouldThrow = false;
  String errorMessage = 'Error fetching orders';

  @override
  Future<OrdersResponseModel> getOrders({
    String? status,
    int? page,
    int? limit,
    String? search,
  }) async {
    wasCalled = true;
    lastStatus = status;
    lastPage = page;
    lastLimit = limit;
    lastSearch = search;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return OrdersResponseModel(
      success: true,
      message: 'Request successful',
      data: OrdersDataModel(
        total: 2,
        currentPage: page ?? 1,
        lastPage: 1,
        perPage: limit ?? 10,
        orders: [
          OrderModel(
            id: 1,
            orderId: '#1001',
            productName: 'Chicken Biriyani',
            quantity: 2,
            status: 'pending',
            amount: 600,
            date: '2026-09-20',
          ),
          OrderModel(
            id: 2,
            orderId: '#1002',
            productName: 'Mutton Biriyani',
            quantity: 1,
            status: 'pending',
            amount: 450,
            date: '2026-09-20',
          ),
        ],
      ),
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Get Orders API & Domain Unit Tests', () {
    test('ApiRoutes contains orders endpoint', () {
      expect(ApiRoutes.orders, '/orders');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('OrdersResponseModel parses live server empty orders list correctly', () {
      final json = {
        "success": true,
        "data": {
          "orders": [],
          "total": 0,
          "current_page": 1,
          "last_page": 1,
          "per_page": 10
        },
        "message": "Request successful",
        "code": 200
      };

      final response = OrdersResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Request successful');
      expect(response.data, isNotNull);
      expect(response.data?.orders, isEmpty);
      expect(response.data?.total, 0);
    });

    test('OrdersResponseModel parses populated orders data correctly', () {
      final json = {
        "success": true,
        "data": {
          "orders": [
            {
              "id": 101,
              "order_number": "ORD-101",
              "product_name": "Chicken Biriyani",
              "quantity": 2,
              "status": "pending",
              "total_amount": "550.00",
              "created_at": "2026-09-21 10:00:00",
              "customer": {
                "name": "Alex",
                "phone": "9876543210",
                "address": "123 Main St"
              },
              "items": [
                {
                  "name": "Chicken Biriyani",
                  "quantity": 2,
                  "price": 275.0
                }
              ]
            }
          ],
          "total": 1,
          "current_page": 1,
          "last_page": 1,
          "per_page": 10
        },
        "message": "Request successful",
        "code": 200
      };

      final response = OrdersResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.data?.orders.length, 1);

      final order = response.data!.orders.first;
      expect(order.orderId, 'ORD-101');
      expect(order.productName, 'Chicken Biriyani');
      expect(order.quantity, 2);
      expect(order.status, 'pending');
      expect(order.amount, 550.0);
      expect(order.customer?.name, 'Alex');
      expect(order.customer?.phone, '9876543210');
      expect(order.items.length, 1);
      expect(order.items.first.price, 275.0);
    });

    test('GetOrdersUseCase delegates query params to OrderRepository', () async {
      final mockRepo = MockOrderRepository();
      final useCase = GetOrdersUseCase(mockRepo);

      final result = await useCase(
        status: 'pending',
        page: 1,
        limit: 10,
        search: 'pending',
      );

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastStatus, 'pending');
      expect(mockRepo.lastPage, 1);
      expect(mockRepo.lastLimit, 10);
      expect(mockRepo.lastSearch, 'pending');

      expect(result.success, isTrue);
      expect(result.data?.total, 2);
      expect(result.data?.orders.first.orderId, '#1001');
    });

    test('GetOrdersUseCase handles repository failure', () async {
      final mockRepo = MockOrderRepository()..shouldThrow = true;
      final useCase = GetOrdersUseCase(mockRepo);

      expect(
        () => useCase(status: 'pending'),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
