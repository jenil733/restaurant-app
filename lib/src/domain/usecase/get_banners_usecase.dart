import '../../data/models/banner_model.dart';
import '../repository/banner_repository.dart';

class GetBannersUseCase {
  final BannerRepository repository;

  GetBannersUseCase(this.repository);

  Future<BannerResponseModel> call() async {
    return await repository.getBanners();
  }
}
