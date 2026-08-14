import 'package:get/get.dart';

class ProfileController extends GetxController {
  var restaurantName = "Kayall Restaurant".obs;
  var ownerName = "John Miller".obs;
  var mobile = "+91 9834572823".obs;
  var email = "kayal@gmail.com".obs;
  var address = "Chennai, Tamil Nadu".obs;

  var restaurantId = "RST001".obs;
  var storeTiming = "09:00AM - 10:00PM".obs;

  var isActive = true.obs;

  var profileImage = "assets/images/restaurant.jpg".obs;
}