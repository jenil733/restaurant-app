import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/data/models/product_model.dart';
import 'package:restaurant_app/src/domain/repository/product_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_restaurant_products_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/add_product_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/update_product_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/delete_product_usecase.dart';

class MockProductRepository implements ProductRepository {
  bool wasGetCalled = false;
  bool wasAddCalled = false;
  bool wasUpdateCalled = false;
  bool wasDeleteCalled = false;
  Map<String, dynamic>? lastParams;
  AddProductRequestModel? lastAddRequest;
  dynamic lastUpdateId;
  UpdateProductRequestModel? lastUpdateRequest;
  DeleteProductRequestModel? lastDeleteRequest;
  bool shouldThrow = false;
  String errorMessage = 'Error fetching products';

  @override
  Future<ProductResponseModel> getProducts({
    Map<String, dynamic>? queryParams,
  }) async {
    wasGetCalled = true;
    lastParams = queryParams;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return ProductResponseModel(
      success: true,
      message: 'Products fetched successfully',
      products: [
        ProductModel(
          id: 1,
          title: 'The Spice Pizza',
          description: 'Delicious pizza with spices',
          originalPrice: '200',
          discountedPrice: '150',
          discountText: '25 %',
          isVeg: true,
          categoryName: 'Pizza',
        ),
        ProductModel(
          id: 2,
          title: 'Chicken Burger',
          description: 'Crunchy chicken patty burger',
          originalPrice: '180',
          discountedPrice: '140',
          discountText: '20 %',
          isVeg: false,
          categoryName: 'Burger',
        ),
      ],
      code: 200,
    );
  }

  @override
  Future<AddProductResponseModel> addProduct(
    AddProductRequestModel request,
  ) async {
    wasAddCalled = true;
    lastAddRequest = request;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return AddProductResponseModel(
      success: true,
      message: 'Product added successfully',
      product: ProductModel(
        id: 99,
        title: request.name,
        description: request.desc ?? '',
        originalPrice: request.mrp,
        discountedPrice: request.mrp,
        discountText: '${request.discount} %',
        isVeg: request.foodType == '1' || request.foodType.toLowerCase() == 'veg',
        categoryId: request.category,
      ),
      code: 200,
    );
  }

  @override
  Future<UpdateProductResponseModel> updateProduct(
    dynamic id,
    UpdateProductRequestModel request,
  ) async {
    wasUpdateCalled = true;
    lastUpdateId = id;
    lastUpdateRequest = request;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return UpdateProductResponseModel(
      success: true,
      message: 'Product updated successfully',
      product: ProductModel(
        id: id,
        title: request.name ?? 'Updated Product',
        description: request.desc ?? '',
        originalPrice: request.mrp ?? '200',
        discountedPrice: request.mrp ?? '200',
        discountText: '${request.discount ?? "0"} %',
        isVeg: request.foodType == '1' || request.foodType?.toLowerCase() == 'veg',
        categoryId: request.category,
      ),
      code: 200,
    );
  }

  @override
  Future<DeleteProductResponseModel> deleteProduct(
    DeleteProductRequestModel request,
  ) async {
    wasDeleteCalled = true;
    lastDeleteRequest = request;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return DeleteProductResponseModel(
      success: true,
      message: 'Product deleted successfully',
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Product API Unit Tests', () {
    test('ApiRoutes contains products and addProduct endpoints', () {
      expect(ApiRoutes.products, '/products');
      expect(ApiRoutes.addProduct, '/add_product');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
      expect(
        ApiRoutes.apiKey,
        'sdfghjkcvbnfghjkcvbnmdfghjdfvgbncvbn',
      );
    });

    test('ProductModel parses JSON correctly with full attributes', () {
      final json = {
        'id': 10,
        'name': 'Margherita Pizza',
        'description': 'Classic cheese pizza',
        'mrp': '250',
        'sell_price': '200',
        'discount': '20 %',
        'food_type': 'Veg',
        'category_id': 1,
        'category_name': 'Pizza',
        'image': 'pizza.png',
        'status': 'active',
      };

      final product = ProductModel.fromJson(json);

      expect(product.id, 10);
      expect(product.title, 'Margherita Pizza');
      expect(product.description, 'Classic cheese pizza');
      expect(product.originalPrice, '250');
      expect(product.discountedPrice, '200');
      expect(product.discountText, '20 %');
      expect(product.isVeg, isTrue);
      expect(product.categoryId, 1);
      expect(product.categoryName, 'Pizza');
      expect(product.image, 'pizza.png');

      final map = product.toJson();
      expect(map['name'], 'Margherita Pizza');
      expect(map['is_veg'], isTrue);
    });

    test('ProductModel parses non-veg and numeric veg flags properly', () {
      final json = {
        'id': 11,
        'title': 'BBQ Chicken Wings',
        'description': 'Smoky wings',
        'price': '300',
        'sale_price': '270',
        'discount_percent': '10',
        'is_veg': 0,
      };

      final product = ProductModel.fromJson(json);

      expect(product.id, 11);
      expect(product.title, 'BBQ Chicken Wings');
      expect(product.originalPrice, '300');
      expect(product.discountedPrice, '270');
      expect(product.discountText, '10 %');
      expect(product.isVeg, isFalse);

      final cardMap = product.toCardMap();
      expect(cardMap['title'], 'BBQ Chicken Wings');
      expect(cardMap['isVeg'], isFalse);
    });

    test('ProductResponseModel parses JSON response list', () {
      final json = {
        'status': true,
        'message': 'Products list',
        'data': [
          {
            'id': 1,
            'name': 'Cold Coffee',
            'mrp': '120',
            'sell_price': '100',
            'food_type': 'Veg',
          },
        ],
        'code': 200,
      };

      final response = ProductResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.products.length, 1);
      expect(response.products.first.title, 'Cold Coffee');
      expect(response.code, 200);

      final map = response.toJson();
      expect(map['status'], isTrue);
      expect((map['data'] as List).length, 1);
    });

    test('AddProductRequestModel creates valid JSON and FormData', () async {
      final request = AddProductRequestModel(
        name: 'pine apple juice',
        category: '1',
        foodType: '0',
        desc: '123456',
        mrp: '200',
        discount: '10',
      );

      final json = request.toJson();
      expect(json['name'], 'pine apple juice');
      expect(json['category'], '1');
      expect(json['food_type'], '0');
      expect(json['desc'], '123456');
      expect(json['mrp'], '200');
      expect(json['discount'], '10');

      final formData = await request.toFormData();
      expect(
        formData.fields.any((f) => f.key == 'name' && f.value == 'pine apple juice'),
        isTrue,
      );
      expect(
        formData.fields.any((f) => f.key == 'category' && f.value == '1'),
        isTrue,
      );
      expect(
        formData.fields.any((f) => f.key == 'food_type' && f.value == '0'),
        isTrue,
      );
      expect(
        formData.fields.any((f) => f.key == 'desc' && f.value == '123456'),
        isTrue,
      );
    });

    test('AddProductResponseModel parses success response and product correctly', () {
      final json = {
        'status': true,
        'message': 'Product added successfully',
        'data': {
          'id': 55,
          'name': 'Pineapple Juice',
          'mrp': '200',
          'sell_price': '180',
          'food_type': '1',
        },
        'code': 200,
      };

      final response = AddProductResponseModel.fromJson(json);
      expect(response.success, isTrue);
      expect(response.message, 'Product added successfully');
      expect(response.product?.id, 55);
      expect(response.product?.title, 'Pineapple Juice');
      expect(response.product?.originalPrice, '200');
    });

    test('GetRestaurantProductsUseCase delegates request to ProductRepository', () async {
      final mockRepo = MockProductRepository();
      final useCase = GetRestaurantProductsUseCase(mockRepo);

      final result = await useCase(queryParams: {'category_id': 1});

      expect(mockRepo.wasGetCalled, isTrue);
      expect(mockRepo.lastParams, {'category_id': 1});
      expect(result.success, isTrue);
      expect(result.products.length, 2);
      expect(result.products[0].title, 'The Spice Pizza');
      expect(result.products[1].title, 'Chicken Burger');
    });

    test('GetRestaurantProductsUseCase handles repository failures', () async {
      final mockRepo = MockProductRepository()..shouldThrow = true;
      final useCase = GetRestaurantProductsUseCase(mockRepo);

      expect(
        () => useCase(),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('AddProductUseCase delegates request to ProductRepository', () async {
      final mockRepo = MockProductRepository();
      final useCase = AddProductUseCase(mockRepo);

      final request = AddProductRequestModel(
        name: 'pine apple juice',
        category: '1',
        foodType: '0',
        mrp: '200',
        discount: '10',
      );

      final result = await useCase(request);

      expect(mockRepo.wasAddCalled, isTrue);
      expect(mockRepo.lastAddRequest?.name, 'pine apple juice');
      expect(result.success, isTrue);
      expect(result.product?.title, 'pine apple juice');
    });

    test('AddProductUseCase handles repository failure', () async {
      final mockRepo = MockProductRepository()..shouldThrow = true;
      final useCase = AddProductUseCase(mockRepo);

      expect(
        () => useCase(
          AddProductRequestModel(
            name: 'pine apple juice',
            category: '1',
            foodType: '0',
            mrp: '200',
            discount: '10',
          ),
        ),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('ApiRoutes contains updateProduct constant', () {
      expect(ApiRoutes.updateProduct, '/update_product');
      expect('${ApiRoutes.updateProduct}/2', '/update_product/2');
      expect('${ApiRoutes.updateProduct}/5', '/update_product/5');
    });

    test('UpdateProductRequestModel creates valid JSON and FormData', () async {
      final request = UpdateProductRequestModel(
        productId: 2,
        name: 'mango juice',
        category: '1',
        foodType: '0',
        desc: 'Fresh cold mango juice',
        mrp: '220',
        discount: '15',
        status: 'Enable',
      );

      final json = request.toJson();
      expect(json['id'], '2');
      expect(json['name'], 'mango juice');
      expect(json['category'], '1');
      expect(json['food_type'], '0');
      expect(json['desc'], 'Fresh cold mango juice');
      expect(json['mrp'], '220');
      expect(json['discount'], '15');
      expect(json['status'], 'Enable');

      final formData = await request.toFormData();
      expect(
        formData.fields.any((f) => f.key == 'id' && f.value == '2'),
        isTrue,
      );
      expect(
        formData.fields.any((f) => f.key == 'name' && f.value == 'mango juice'),
        isTrue,
      );
      expect(
        formData.fields.any((f) => f.key == 'category' && f.value == '1'),
        isTrue,
      );
    });

    test('UpdateProductResponseModel parses success response and product correctly', () {
      final json = {
        'status': true,
        'message': 'Product updated successfully',
        'data': {
          'id': 2,
          'name': 'Mango Juice',
          'mrp': '220',
          'sell_price': '187',
          'discount': '15 %',
          'food_type': '1',
        },
        'code': 200,
      };

      final response = UpdateProductResponseModel.fromJson(json);
      expect(response.success, isTrue);
      expect(response.message, 'Product updated successfully');
      expect(response.product?.id, 2);
      expect(response.product?.title, 'Mango Juice');
      expect(response.product?.originalPrice, '220');
      expect(response.product?.discountedPrice, '187');
    });

    test('UpdateProductUseCase delegates request to ProductRepository', () async {
      final mockRepo = MockProductRepository();
      final useCase = UpdateProductUseCase(mockRepo);

      final request = UpdateProductRequestModel(
        productId: 2,
        name: 'mango juice',
        category: '1',
        foodType: '0',
        mrp: '220',
        discount: '15',
      );

      final result = await useCase(id: 2, request: request);

      expect(mockRepo.wasUpdateCalled, isTrue);
      expect(mockRepo.lastUpdateId, 2);
      expect(mockRepo.lastUpdateRequest?.name, 'mango juice');
      expect(result.success, isTrue);
      expect(result.product?.id, 2);
      expect(result.product?.title, 'mango juice');
    });

    test('UpdateProductUseCase handles repository failure', () async {
      final mockRepo = MockProductRepository()..shouldThrow = true;
      final useCase = UpdateProductUseCase(mockRepo);

      expect(
        () => useCase(
          id: 2,
          request: UpdateProductRequestModel(
            name: 'mango juice',
          ),
        ),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('ApiRoutes contains deleteProduct constant', () {
      expect(ApiRoutes.deleteProduct, '/delete_product');
      expect('${ApiRoutes.deleteProduct}/4', '/delete_product/4');
      expect('${ApiRoutes.deleteProduct}/10', '/delete_product/10');
    });

    test('DeleteProductRequestModel creates valid JSON and FormData', () async {
      final request = DeleteProductRequestModel(
        productId: 4,
        phone: '9898989898',
      );

      final json = request.toJson();
      expect(json['phone'], '9898989898');

      final formData = await request.toFormData();
      expect(
        formData.fields.any((f) => f.key == 'phone' && f.value == '9898989898'),
        isTrue,
      );
    });

    test('DeleteProductResponseModel parses success and error responses correctly', () {
      final successJson = {
        'status': true,
        'message': 'Product deleted successfully',
        'code': 200,
      };

      final response = DeleteProductResponseModel.fromJson(successJson);
      expect(response.success, isTrue);
      expect(response.message, 'Product deleted successfully');
      expect(response.code, 200);

      final errorJson = {
        'status': false,
        'message': 'Product not found',
        'code': 404,
      };
      final errorResponse = DeleteProductResponseModel.fromJson(errorJson);
      expect(errorResponse.success, isFalse);
      expect(errorResponse.message, 'Product not found');
    });

    test('DeleteProductUseCase delegates request to ProductRepository', () async {
      final mockRepo = MockProductRepository();
      final useCase = DeleteProductUseCase(mockRepo);

      final request = DeleteProductRequestModel(productId: 4);
      final result = await useCase(request);

      expect(mockRepo.wasDeleteCalled, isTrue);
      expect(mockRepo.lastDeleteRequest?.productId, 4);
      expect(result.success, isTrue);
      expect(result.message, 'Product deleted successfully');
    });

    test('DeleteProductUseCase handles repository failure', () async {
      final mockRepo = MockProductRepository()..shouldThrow = true;
      final useCase = DeleteProductUseCase(mockRepo);

      expect(
        () => useCase(DeleteProductRequestModel(productId: 4)),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
