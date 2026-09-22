import '../../core/const/api_routes.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/dashboard_repository.dart';
import '../models/dashboard_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final ApiService _apiService;

  DashboardRepositoryImpl(this._apiService);

  @override
  Future<DashboardResponseModel> getDashboard() async {
    final response = await _apiService.get(ApiRoutes.getDashboard);
    return DashboardResponseModel.fromJson(response);
  }
}
