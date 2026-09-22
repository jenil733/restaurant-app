import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/orders_model.dart';
import 'package:restaurant_app/src/data/models/recent_orders_model.dart';
import 'package:restaurant_app/src/domain/repository/recent_orders_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_recent_orders_usecase.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';

class MockRecentOrdersRepository implements RecentOrdersRepository {
  bool wasCalled = false;
  bool shouldThrow = false;
  String errorMessage = 'Failed to fetch recent orders';

  @override
  Future<RecentOrdersResponseModel> getRecentOrders() async {
    wasCalled = true;
    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }
    return RecentOrdersResponseModel(
      success: true,
      message: 'Recent orders fetched successfully',
      code: 200,
      data: [
        OrderModel(
          id: 1,
          orderId: '#1001',
          productName: 'Paneer Butter Masala',
          quantity: 2,
          status: 'Pending',
          amount: 350.0,
          date: '2026-09-21',
        ),
        OrderModel(
          id: 2,
          orderId: '#1002',
          productName: 'Chicken Biryani',
          quantity: 1,
          status: 'Accepted',
          amount: 220.0,
          date: '2026-09-21',
        ),
      ],
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Recent Orders API & Domain Unit Tests', () {
    test('ApiRoutes contains recentOrders endpoint', () {
      expect(ApiRoutes.recentOrders, '/recent_orders');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('RecentOrdersResponseModel parses standard json list response', () {
      final json = {
        "success": true,
        "message": "Recent orders retrieved",
        "code": 200,
        "data": [
          {
            "id": 1,
            "order_id": "#1001",
            "product_name": "Veg Fried Rice",
            "qty": 2,
            "status": "Pending",
            "total_amount": 180.0
          },
          {
            "id": 2,
            "order_id": "#1002",
            "product_name": "Gobi Manchurian",
            "qty": 1,
            "status": "Delivered",
            "total_amount": 120.0
          }
        ]
      };

      final response = RecentOrdersResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Recent orders retrieved');
      expect(response.data.length, 2);
      expect(response.data[0].orderId, '#1001');
      expect(response.data[0].productName, 'Veg Fried Rice');
      expect(response.data[0].quantity, 2);
      expect(response.data[0].status, 'Pending');
      expect(response.data[0].amount, 180.0);
      expect(response.data[1].orderId, '#1002');
    });

    test('RecentOrdersResponseModel parses nested object response', () {
      final json = {
        "status": "success",
        "message": "Success",
        "data": {
          "recent_orders": [
            {
              "id": 3,
              "order_id": "#1003",
              "product_name": "Butter Naan",
              "quantity": 3,
              "status": "Accepted",
              "amount": 90.0
            }
          ]
        }
      };

      final response = RecentOrdersResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.data.length, 1);
      expect(response.data[0].orderId, '#1003');
      expect(response.data[0].productName, 'Butter Naan');
      expect(response.data[0].quantity, 3);
    });

    test('GetRecentOrdersUseCase calls repository', () async {
      final mockRepo = MockRecentOrdersRepository();
      final useCase = GetRecentOrdersUseCase(mockRepo);

      final result = await useCase();

      expect(mockRepo.wasCalled, isTrue);
      expect(result.success, isTrue);
      expect(result.data.length, 2);
      expect(result.data[0].productName, 'Paneer Butter Masala');
    });

    test('GetRecentOrdersUseCase handles repository failure', () async {
      final mockRepo = MockRecentOrdersRepository()..shouldThrow = true;
      final useCase = GetRecentOrdersUseCase(mockRepo);

      expect(() => useCase(), throwsA(isA<ServerFailure>()));
    });

    test('HomeController fetches and populates recent orders', () async {
      final mockRepo = MockRecentOrdersRepository();
      final useCase = GetRecentOrdersUseCase(mockRepo);

      final controller = HomeController(getRecentOrdersUseCase: useCase);
      await controller.fetchRecentOrders();

      expect(controller.recentOrders.length, 2);
      expect(controller.recentOrders[0].orderId, '#1001');
      expect(controller.recentOrders[0].productName, 'Paneer Butter Masala');
      expect(controller.recentOrders[0].quantity, 2);
      expect(controller.recentOrders[1].orderId, '#1002');
    });
  });
}
