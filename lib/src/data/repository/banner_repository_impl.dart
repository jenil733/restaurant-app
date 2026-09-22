import '../../core/const/api_routes.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/banner_repository.dart';
import '../models/banner_model.dart';

class BannerRepositoryImpl implements BannerRepository {
  final ApiService _apiService;

  BannerRepositoryImpl(this._apiService);

  @override
  Future<BannerResponseModel> getBanners() async {
    final response = await _apiService.get(ApiRoutes.banners);
    return BannerResponseModel.fromJson(response);
  }
}
