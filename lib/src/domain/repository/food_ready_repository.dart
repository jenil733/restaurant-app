import '../../data/models/food_ready_model.dart';

abstract class FoodReadyRepository {
  Future<FoodReadyResponseModel> markFoodReady(dynamic orderId);
}
