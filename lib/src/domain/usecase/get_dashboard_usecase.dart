import '../../data/models/dashboard_model.dart';
import '../repository/dashboard_repository.dart';

class GetDashboardUseCase {
  final DashboardRepository repository;

  GetDashboardUseCase(this.repository);

  Future<DashboardResponseModel> call() async {
    return await repository.getDashboard();
  }
}
