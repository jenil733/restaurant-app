import '../../data/models/update_bank_details_model.dart';

abstract class BankDetailsRepository {
  Future<UpdateBankDetailsResponseModel> updateBankDetails(UpdateBankDetailsRequestModel request);
}
