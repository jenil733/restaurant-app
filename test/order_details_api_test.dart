import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/order_detail_model.dart';
import 'package:restaurant_app/src/data/models/orders_model.dart';
import 'package:restaurant_app/src/domain/repository/order_detail_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_order_details_usecase.dart';

class MockOrderDetailRepository implements OrderDetailRepository {
  bool wasCalled = false;
  dynamic lastOrderId;
  bool shouldThrow = false;
  String errorMessage = 'Error fetching order details';

  @override
  Future<OrderDetailResponseModel> getOrderDetails(dynamic orderId) async {
    wasCalled = true;
    lastOrderId = orderId;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return OrderDetailResponseModel(
      success: true,
      message: 'Request successful',
      data: OrderModel(
        id: 1,
        orderId: '#1001',
        productName: 'Chicken Biriyani',
        quantity: 2,
        status: 'Pending',
        amount: 600,
        subtotal: 550,
        deliveryCharge: 50,
        discount: 0,
        paymentStatus: 'Paid',
        paymentMethod: 'Online',
        date: '12 May 2025',
        time: '10:30 AM',
        customer: CustomerInfoModel(
          name: 'John Miller',
          phone: '9876543212',
          address: '2972 Westheimer Rd.Santa Ana, Illinois 85486',
        ),
        items: [
          OrderItemDetailModel(
            id: 10,
            name: 'Chicken Biriyani',
            quantity: 2,
            price: 275,
            image: 'https://example.com/biriyani.jpg',
          ),
        ],
      ),
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Get Order Details API & Domain Unit Tests', () {
    test('ApiRoutes contains orderDetails endpoint', () {
      expect(ApiRoutes.orderDetails, '/order_details');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
    });

    test('OrderDetailResponseModel parses server response correctly', () {
      final json = {
        "success": true,
        "data": {
          "id": 1,
          "order_number": "ORD-1001",
          "status": "Pending",
          "subtotal": 500,
          "delivery_charge": 40,
          "discount": 20,
          "total_amount": 520,
          "payment_status": "Paid",
          "payment_method": "Online",
          "created_at": "2026-09-21 10:30:00",
          "customer": {
            "name": "John Miller",
            "phone": "9876543212",
            "address": "2972 Westheimer Rd."
          },
          "items": [
            {
              "name": "Chicken Biriyani",
              "quantity": 2,
              "price": 250,
              "image": "https://example.com/biriyani.jpg"
            }
          ]
        },
        "message": "Request successful",
        "code": 200
      };

      final response = OrderDetailResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.data, isNotNull);
      expect(response.data?.orderId, 'ORD-1001');
      expect(response.data?.status, 'Pending');
      expect(response.data?.subtotal, 500);
      expect(response.data?.deliveryCharge, 40);
      expect(response.data?.discount, 20);
      expect(response.data?.amount, 520);
      expect(response.data?.customer?.name, 'John Miller');
      expect(response.data?.customer?.phone, '9876543212');
      expect(response.data?.items.length, 1);
      expect(response.data?.items.first.name, 'Chicken Biriyani');
    });

    test('GetOrderDetailsUseCase delegates request to OrderDetailRepository', () async {
      final mockRepo = MockOrderDetailRepository();
      final useCase = GetOrderDetailsUseCase(mockRepo);

      final result = await useCase(1);

      expect(mockRepo.wasCalled, isTrue);
      expect(mockRepo.lastOrderId, 1);
      expect(result.success, isTrue);
      expect(result.data?.orderId, '#1001');
      expect(result.data?.customer?.name, 'John Miller');
    });

    test('GetOrderDetailsUseCase handles repository failure', () async {
      final mockRepo = MockOrderDetailRepository()..shouldThrow = true;
      final useCase = GetOrderDetailsUseCase(mockRepo);

      expect(
        () => useCase(1),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
