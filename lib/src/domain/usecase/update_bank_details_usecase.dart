import '../../data/models/update_bank_details_model.dart';
import '../repository/bank_details_repository.dart';

class UpdateBankDetailsUseCase {
  final BankDetailsRepository _repository;

  UpdateBankDetailsUseCase(this._repository);

  Future<UpdateBankDetailsResponseModel> call(UpdateBankDetailsRequestModel request) {
    return _repository.updateBankDetails(request);
  }
}
