import 'package:dio/dio.dart';
import '../../core/const/api_routes.dart';
import '../../core/error/failure.dart';
import '../../core/services/api_services.dart';
import '../../domain/repository/bank_details_repository.dart';
import '../models/update_bank_details_model.dart';

class BankDetailsRepositoryImpl implements BankDetailsRepository {
  final ApiService _apiService;

  BankDetailsRepositoryImpl(this._apiService);

  String _extractErrorMessage(DioException e, String fallback) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map;
      if (data['errors'] is Map && (data['errors'] as Map).isNotEmpty) {
        final errorMap = data['errors'] as Map;
        final firstError = errorMap.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        } else if (firstError is String) {
          return firstError;
        }
      }
      if (data['message'] != null && data['message'].toString().trim().isNotEmpty) {
        return data['message'].toString();
      }
    }
    return fallback;
  }

  @override
  Future<UpdateBankDetailsResponseModel> updateBankDetails(UpdateBankDetailsRequestModel request) async {
    try {
      final formData = await request.toFormData();
      final response = await _apiService.post(
        ApiRoutes.updateBankDetails,
        data: formData,
      );
      return UpdateBankDetailsResponseModel.fromJson(response);
    } on DioException catch (e) {
      throw ServerFailure(message: _extractErrorMessage(e, 'Failed to update bank details'));
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(message: e.toString());
    }
  }
}
