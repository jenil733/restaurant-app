import '../../data/models/food_ready_model.dart';
import '../repository/food_ready_repository.dart';

class FoodReadyUseCase {
  final FoodReadyRepository _repository;

  FoodReadyUseCase(this._repository);

  Future<FoodReadyResponseModel> call(dynamic orderId) {
    return _repository.markFoodReady(orderId);
  }
}
