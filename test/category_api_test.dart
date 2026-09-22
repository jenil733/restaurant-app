import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/error/failure.dart';
import 'package:restaurant_app/src/core/utils/helper/image_helper.dart';
import 'package:restaurant_app/src/data/models/category_model.dart';
import 'package:restaurant_app/src/domain/repository/category_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_categories_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/add_category_usecase.dart';
import 'package:restaurant_app/src/domain/usecase/delete_category_usecase.dart';

class MockCategoryRepository implements CategoryRepository {
  bool wasGetCalled = false;
  bool wasAddCalled = false;
  bool wasDeleteCalled = false;
  Map<String, dynamic>? lastParams;
  AddCategoryRequestModel? lastAddRequest;
  DeleteCategoryRequestModel? lastDeleteRequest;
  bool shouldThrow = false;
  String errorMessage = 'Error fetching categories';

  @override
  Future<CategoryResponseModel> getCategories({
    Map<String, dynamic>? queryParams,
  }) async {
    wasGetCalled = true;
    lastParams = queryParams;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return CategoryResponseModel(
      success: true,
      message: 'Categories fetched successfully',
      categories: [
        CategoryModel(
          id: 1,
          name: 'Pizza',
          description: 'Delicious pizzas',
          image: 'https://example.com/pizza.png',
          status: '1',
        ),
        CategoryModel(
          id: 2,
          name: 'Burger',
          description: 'Juicy burgers',
          image: 'https://example.com/burger.png',
          status: '1',
        ),
      ],
      code: 200,
    );
  }

  @override
  Future<AddCategoryResponseModel> addCategory(
    AddCategoryRequestModel request,
  ) async {
    wasAddCalled = true;
    lastAddRequest = request;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return AddCategoryResponseModel(
      success: true,
      message: 'Category added successfully',
      category: CategoryModel(
        id: 3,
        name: request.name,
        description: request.description,
      ),
      code: 200,
    );
  }

  @override
  Future<DeleteCategoryResponseModel> deleteCategory(
    DeleteCategoryRequestModel request,
  ) async {
    wasDeleteCalled = true;
    lastDeleteRequest = request;

    if (shouldThrow) {
      throw ServerFailure(message: errorMessage);
    }

    return DeleteCategoryResponseModel(
      success: true,
      message: 'Category deleted successfully',
      code: 200,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Category API Unit Tests', () {
    test('ApiRoutes contains categories, addCategory and deleteCategory constants', () {
      expect(ApiRoutes.categories, '/categories');
      expect(ApiRoutes.addCategory, '/add_category');
      expect(ApiRoutes.deleteCategory, '/delete_category');
      expect(
        ApiRoutes.baseURL,
        'http://64.227.170.206/kayal.com/public/api/restaurant',
      );
      expect(
        ApiRoutes.apiKey,
        'sdfghjkcvbnfghjkcvbnmdfghjdfvgbncvbn',
      );
    });

    test('CategoryResponseModel parses JSON response with direct list', () {
      final json = {
        'status': true,
        'message': 'Categories list',
        'data': [
          {
            'id': 101,
            'name': 'Pasta',
            'description': 'Italian pasta dishes',
            'image': 'pasta.jpg',
            'status': 'active',
          },
          {
            'id': 102,
            'name': 'Desserts',
            'description': 'Sweet treats',
            'image': 'dessert.jpg',
            'status': 'active',
          }
        ],
        'code': 200,
      };

      final response = CategoryResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Categories list');
      expect(response.categories.length, 2);
      expect(response.categories.first.id, 101);
      expect(response.categories.first.name, 'Pasta');
      expect(response.categories.first.description, 'Italian pasta dishes');
      expect(response.categories.first.image, 'pasta.jpg');
      expect(response.categories.last.name, 'Desserts');
      expect(response.code, 200);

      final map = response.toJson();
      expect(map['status'], isTrue);
      expect((map['data'] as List).length, 2);
    });

    test('CategoryResponseModel parses alternative JSON aliases and nested structures', () {
      final json = {
        'success': 'true',
        'message': 'OK',
        'data': {
          'categories': [
            {
              'id': 'cat_1',
              'category_name': 'Cold Drinks',
              'category_image': 'drink.png',
            },
            {
              'id': 'cat_2',
              'title': 'Hot Beverages',
              'icon': 'coffee.png',
            }
          ]
        },
      };

      final response = CategoryResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.categories.length, 2);
      expect(response.categories[0].name, 'Cold Drinks');
      expect(response.categories[0].image, 'drink.png');
      expect(response.categories[1].name, 'Hot Beverages');
      expect(response.categories[1].image, 'coffee.png');
    });

    test('AddCategoryRequestModel creates valid JSON and FormData', () async {
      final request = AddCategoryRequestModel(
        name: 'juice',
        description: 'Fresh fruit juices',
      );

      final json = request.toJson();
      expect(json['name'], 'juice');
      expect(json['description'], 'Fresh fruit juices');

      final formData = await request.toFormData();
      expect(
        formData.fields.any((field) => field.key == 'name' && field.value == 'juice'),
        isTrue,
      );
      expect(
        formData.fields.any((field) => field.key == 'description' && field.value == 'Fresh fruit juices'),
        isTrue,
      );
    });

    test('AddCategoryResponseModel parses success response and category correctly', () {
      final json = {
        'status': true,
        'message': 'Category added successfully',
        'data': {
          'id': 15,
          'name': 'Juice',
          'description': 'Fresh fruit juices',
        },
        'code': 200,
      };

      final response = AddCategoryResponseModel.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Category added successfully');
      expect(response.category?.id, 15);
      expect(response.category?.name, 'Juice');
      expect(response.category?.description, 'Fresh fruit juices');

      final map = response.toJson();
      expect(map['status'], isTrue);
      expect(map['data']['name'], 'Juice');
    });

    test('DeleteCategoryRequestModel creates valid JSON and FormData', () async {
      final request = DeleteCategoryRequestModel(
        categoryId: 2,
        phone: '9898989898',
      );

      expect(request.categoryId, 2);
      expect(request.phone, '9898989898');

      final json = request.toJson();
      expect(json['phone'], '9898989898');

      final formData = await request.toFormData();
      expect(
        formData.fields.any((field) => field.key == 'phone' && field.value == '9898989898'),
        isTrue,
      );
    });

    test('DeleteCategoryResponseModel parses success and error JSON correctly', () {
      final json = {
        'status': true,
        'message': 'Category deleted successfully',
        'code': 200,
      };

      final response = DeleteCategoryResponseModel.fromJson(json);
      expect(response.success, isTrue);
      expect(response.message, 'Category deleted successfully');
      expect(response.code, 200);

      final map = response.toJson();
      expect(map['status'], isTrue);
      expect(map['message'], 'Category deleted successfully');
    });

    test('GetCategoriesUseCase delegates request to CategoryRepository', () async {
      final mockRepo = MockCategoryRepository();
      final useCase = GetCategoriesUseCase(mockRepo);

      final result = await useCase(queryParams: {'status': 'active'});

      expect(mockRepo.wasGetCalled, isTrue);
      expect(mockRepo.lastParams, {'status': 'active'});
      expect(result.success, isTrue);
      expect(result.categories.length, 2);
      expect(result.categories[0].name, 'Pizza');
      expect(result.categories[1].name, 'Burger');
    });

    test('AddCategoryUseCase delegates request to CategoryRepository', () async {
      final mockRepo = MockCategoryRepository();
      final useCase = AddCategoryUseCase(mockRepo);

      final request = AddCategoryRequestModel(name: 'juice');
      final result = await useCase(request);

      expect(mockRepo.wasAddCalled, isTrue);
      expect(mockRepo.lastAddRequest?.name, 'juice');
      expect(result.success, isTrue);
      expect(result.category?.name, 'juice');
    });

    test('AddCategoryUseCase handles repository failure', () async {
      final mockRepo = MockCategoryRepository()..shouldThrow = true;
      final useCase = AddCategoryUseCase(mockRepo);

      expect(
        () => useCase(AddCategoryRequestModel(name: 'juice')),
        throwsA(isA<ServerFailure>()),
      );
    });

    test('DeleteCategoryUseCase delegates request to CategoryRepository', () async {
      final mockRepo = MockCategoryRepository();
      final useCase = DeleteCategoryUseCase(mockRepo);

      final request = DeleteCategoryRequestModel(categoryId: 2, phone: '9898989898');
      final result = await useCase(request);

      expect(mockRepo.wasDeleteCalled, isTrue);
      expect(mockRepo.lastDeleteRequest?.categoryId, 2);
      expect(mockRepo.lastDeleteRequest?.phone, '9898989898');
      expect(result.success, isTrue);
      expect(result.message, 'Category deleted successfully');
    });

    test('AddCategoryResponseModel handles numerical status codes and category payloads', () {
      final json = {
        'status': 1,
        'message': 'Category added successfully',
        'data': {
          'id': 20,
          'name': 'Smoothies',
        },
      };

      final response = AddCategoryResponseModel.fromJson(json);
      expect(response.success, isTrue);
      expect(response.category?.id, 20);
      expect(response.category?.name, 'Smoothies');
    });

    test('CategoryResponseModel handles numerical status and result key', () {
      final json = {
        'status': 200,
        'result': [
          {'id': 1, 'name': 'Juices'},
          {'id': 2, 'name': 'Shakes'},
        ],
      };

      final response = CategoryResponseModel.fromJson(json);
      expect(response.success, isTrue);
      expect(response.categories.length, 2);
      expect(response.categories[0].name, 'Juices');
    });

    test('ImageHelper.getImageUrl correctly resolves all image paths', () {
      expect(ImageHelper.getImageUrl(null), isNull);
      expect(ImageHelper.getImageUrl(''), isNull);
      expect(ImageHelper.getImageUrl('null'), isNull);
      expect(ImageHelper.getImageUrl('assets/images/logo.png'), 'assets/images/logo.png');

      // Full external URL
      expect(
        ImageHelper.getImageUrl('https://example.com/photo.jpg'),
        'https://example.com/photo.jpg',
      );

      // Legacy domain replaced
      expect(
        ImageHelper.getImageUrl('http://pickmysnacks.com/storage/categories/pizza.jpg'),
        'http://64.227.170.206/kayal.com/public/storage/categories/pizza.jpg',
      );

      // Relative storage path
      expect(
        ImageHelper.getImageUrl('storage/categories/pizza.jpg'),
        'http://64.227.170.206/kayal.com/public/storage/categories/pizza.jpg',
      );
      expect(
        ImageHelper.getImageUrl('/storage/categories/pizza.jpg'),
        'http://64.227.170.206/kayal.com/public/storage/categories/pizza.jpg',
      );
      expect(
        ImageHelper.getImageUrl('public/storage/categories/pizza.jpg'),
        'http://64.227.170.206/kayal.com/public/storage/categories/pizza.jpg',
      );

      // Relative direct path
      expect(
        ImageHelper.getImageUrl('categories/pizza.jpg'),
        'http://64.227.170.206/kayal.com/public/storage/categories/pizza.jpg',
      );

      // Uploads path
      expect(
        ImageHelper.getImageUrl('uploads/categories/pizza.jpg'),
        'http://64.227.170.206/kayal.com/public/uploads/categories/pizza.jpg',
      );
    });

    test('CategoryModel properly extracts non-empty image from various aliases', () {
      // Empty image key does not block fallback
      final json1 = {
        'id': 1,
        'name': 'Dessert',
        'image': '',
        'category_image': 'dessert_cat.png',
      };
      expect(CategoryModel.fromJson(json1).image, 'dessert_cat.png');

      // Null image string does not block fallback
      final json2 = {
        'id': 2,
        'name': 'Salads',
        'image': 'null',
        'icon': 'salad_icon.png',
      };
      expect(CategoryModel.fromJson(json2).image, 'salad_icon.png');

      // Nested map image format
      final json3 = {
        'id': 3,
        'name': 'Drinks',
        'media': {'url': 'http://example.com/drinks.png'},
      };
      expect(CategoryModel.fromJson(json3).image, 'http://example.com/drinks.png');
    });
  });
}

