import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/data/models/banner_model.dart';
import 'package:restaurant_app/src/domain/repository/banner_repository.dart';
import 'package:restaurant_app/src/domain/usecase/get_banners_usecase.dart';
import 'package:restaurant_app/src/presentation/controller/home_controller.dart';

class _FakeBannerRepository implements BannerRepository {
  BannerResponseModel response;

  _FakeBannerRepository(this.response);

  @override
  Future<BannerResponseModel> getBanners() async {
    return response;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Banner API & Domain Unit Tests', () {
    test('ApiRoutes contains banners endpoints', () {
      expect(ApiRoutes.banners, '/banners');
      expect(ApiRoutes.apiKey, isNotEmpty);
    });

    test('BannerResponseModel parses live server format correctly', () {
      final json = {
        'success': true,
        'data': [
          {
            'id': 1,
            'title': 'Grand Opening Offer',
            'image': 'https://example.com/banner1.jpg',
            'link': 'https://example.com/promo',
            'status': 1,
            'created_at': '2026-09-18',
          },
          {
            'id': 2,
            'name': 'Weekend Special 50% OFF',
            'banner_image': 'https://example.com/banner2.png',
            'url': 'https://example.com/weekend',
            'is_active': true,
          }
        ],
        'message': 'Banners fetched successfully.',
        'code': 200,
      };

      final model = BannerResponseModel.fromJson(json);
      expect(model.success, isTrue);
      expect(model.message, 'Banners fetched successfully.');
      expect(model.code, 200);
      expect(model.data.length, 2);

      final b1 = model.data[0];
      expect(b1.id, 1);
      expect(b1.title, 'Grand Opening Offer');
      expect(b1.image, 'https://example.com/banner1.jpg');
      expect(b1.link, 'https://example.com/promo');
      expect(b1.status, 1);
      expect(b1.createdAt, '2026-09-18');

      final b2 = model.data[1];
      expect(b2.id, 2);
      expect(b2.title, 'Weekend Special 50% OFF');
      expect(b2.image, 'https://example.com/banner2.png');
      expect(b2.link, 'https://example.com/weekend');
      expect(b2.status, isTrue);
    });

    test('BannerResponseModel parses empty banner data list', () {
      final json = {
        'success': true,
        'data': [],
        'message': 'Banners fetched successfully.',
        'code': 200,
      };

      final model = BannerResponseModel.fromJson(json);
      expect(model.success, isTrue);
      expect(model.data, isEmpty);
      expect(model.code, 200);
    });

    test('GetBannersUseCase delegates request to BannerRepository', () async {
      final expectedResponse = BannerResponseModel(
        success: true,
        data: [
          BannerModel(
            id: 10,
            title: 'Biriyani Fest',
            image: 'https://example.com/biriyani.jpg',
          ),
        ],
      );

      final fakeRepo = _FakeBannerRepository(expectedResponse);
      final useCase = GetBannersUseCase(fakeRepo);

      final result = await useCase();
      expect(result.success, isTrue);
      expect(result.data.length, 1);
      expect(result.data.first.title, 'Biriyani Fest');
    });

    test('HomeController fetches and populates live banners', () async {
      final fakeData = BannerResponseModel(
        success: true,
        data: [
          BannerModel(
            id: 101,
            title: 'Festive Combo',
            image: 'https://example.com/combo.jpg',
          ),
          BannerModel(
            id: 102,
            title: 'Free Delivery',
            image: 'https://example.com/free_del.jpg',
          ),
        ],
      );

      final fakeRepo = _FakeBannerRepository(fakeData);
      final useCase = GetBannersUseCase(fakeRepo);
      final controller = HomeController(getBannersUseCase: useCase);

      await controller.fetchBanners();

      expect(controller.banners.length, 2);
      expect(controller.banners[0].id, 101);
      expect(controller.banners[0].title, 'Festive Combo');
      expect(controller.banners[1].id, 102);
      expect(controller.banners[1].title, 'Free Delivery');
    });
  });
}
