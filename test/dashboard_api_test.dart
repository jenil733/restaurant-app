import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/data/models/dashboard_model.dart';
import 'package:restaurant_app/src/domain/repository/dashboard_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_dashboard_usecase.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';

class _FakeDashboardRepository implements DashboardRepository {
  DashboardResponseModel response;

  _FakeDashboardRepository(this.response);

  @override
  Future<DashboardResponseModel> getDashboard() async {
    return response;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Dashboard API & Domain Unit Tests', () {
    test('ApiRoutes contains getDashboard endpoints', () {
      expect(ApiRoutes.getDashboard, '/get_dashboard');
      expect(ApiRoutes.apiKey, isNotEmpty);
    });

    test('DashboardResponseModel parses standard success JSON', () {
      final json = {
        'status': 'success',
        'message': 'Dashboard loaded',
        'data': {
          'orders_count': 150,
          'products_count': 85,
          'pending_orders': 12,
          'completed_orders': 138,
          'total_earnings': 45200.50,
          'is_approved': true,
          'is_rejected': false,
          'restaurant_name': 'Ajay Restaurant',
          'recent_orders': [
            {
              'id': 101,
              'order_id': '#1001',
              'product_name': 'Chicken Biriyani',
              'qty': 2,
              'status': 'Pending',
              'total_amount': 450.0,
            }
          ]
        }
      };

      final model = DashboardResponseModel.fromJson(json);
      expect(model.success, isTrue);
      expect(model.message, 'Dashboard loaded');
      expect(model.data, isNotNull);
      expect(model.data!.totalOrders, 150);
      expect(model.data!.totalProducts, 85);
      expect(model.data!.pendingOrders, 12);
      expect(model.data!.completedOrders, 138);
      expect(model.data!.totalEarnings, 45200.50);
      expect(model.data!.isApproved, isTrue);
      expect(model.data!.isRejected, isFalse);
      expect(model.data!.restaurantName, 'Ajay Restaurant');
      expect(model.data!.recentOrders.length, 1);
      expect(model.data!.recentOrders.first.orderId, '#1001');
      expect(model.data!.recentOrders.first.productName, 'Chicken Biriyani');
      expect(model.data!.recentOrders.first.quantity, 2);
      expect(model.data!.recentOrders.first.status, 'Pending');
    });

    test('DashboardResponseModel parses alternative aliases and root-level fields', () {
      final json = {
        'success': true,
        'total_orders': '250',
        'total_products': '120',
        'pending': '5',
        'completed': '245',
        'revenue': '102500',
        'approved': '1',
        'rejected': '0',
        'name': 'Royal Dine',
        'latest_orders': [
          {
            'order_id': '#2001',
            'product': 'Paneer Butter Masala',
            'quantity': '3',
            'status': 'Completed',
            'total': '750',
          }
        ]
      };

      final model = DashboardResponseModel.fromJson(json);
      expect(model.success, isTrue);
      expect(model.data, isNotNull);
      expect(model.data!.totalOrders, 250);
      expect(model.data!.totalProducts, 120);
      expect(model.data!.pendingOrders, 5);
      expect(model.data!.completedOrders, 245);
      expect(model.data!.totalEarnings, 102500.0);
      expect(model.data!.isApproved, isTrue);
      expect(model.data!.isRejected, isFalse);
      expect(model.data!.restaurantName, 'Royal Dine');
      expect(model.data!.recentOrders.length, 1);
      expect(model.data!.recentOrders.first.orderId, '#2001');
      expect(model.data!.recentOrders.first.productName, 'Paneer Butter Masala');
      expect(model.data!.recentOrders.first.quantity, 3);
      expect(model.data!.recentOrders.first.status, 'Completed');
    });

    test('GetDashboardUseCase delegates request to DashboardRepository', () async {
      final expectedResponse = DashboardResponseModel(
        success: true,
        data: DashboardDataModel(
          totalOrders: 320,
          totalProducts: 45,
        ),
      );

      final fakeRepo = _FakeDashboardRepository(expectedResponse);
      final useCase = GetDashboardUseCase(fakeRepo);

      final result = await useCase();
      expect(result.success, isTrue);
      expect(result.data?.totalOrders, 320);
      expect(result.data?.totalProducts, 45);
    });

    test('HomeController fetches and populates dashboard observables', () async {
      final fakeData = DashboardResponseModel(
        success: true,
        data: DashboardDataModel(
          totalOrders: 88,
          totalProducts: 24,
          isApproved: true,
          isRejected: false,
          recentOrders: [
            DashboardOrderModel(
              orderId: '#9999',
              productName: 'Mutton Chukka',
              quantity: 1,
              status: 'Delivered',
            ),
          ],
        ),
      );

      final fakeRepo = _FakeDashboardRepository(fakeData);
      final useCase = GetDashboardUseCase(fakeRepo);
      final controller = HomeController(getDashboardUseCase: useCase);

      await controller.fetchDashboard();

      expect(controller.totalOrders.value, 88);
      expect(controller.totalProducts.value, 24);
      expect(controller.isApproved.value, isTrue);
      expect(controller.isRejected.value, isFalse);
      expect(controller.recentOrders.length, 1);
      expect(controller.recentOrders.first.orderId, '#9999');
      expect(controller.recentOrders.first.productName, 'Mutton Chukka');
    });
  });
}
