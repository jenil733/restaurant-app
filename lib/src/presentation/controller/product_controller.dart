import 'package:get/get.dart';

class ProductController extends GetxController {
  final List<Map<String, dynamic>> products = [
    {
      'title': 'The Spice Pizza',
      'isVeg': false,
      'originalPrice': '200',
      'discountedPrice': '150',
      'discountText': '20 %',
      'description': 'Lorem Ipsum is simply dummy text of the printing typesetting industry.',
    },
    {
      'title': 'The Spice Pizza',
      'isVeg': true,
      'originalPrice': '200',
      'discountedPrice': '150',
      'discountText': '20 %',
      'description': 'Lorem Ipsum is simply dummy text of the printing typesetting industry.',
    },
    {
      'title': 'The Spice Pizza',
      'isVeg': true,
      'originalPrice': '200',
      'discountedPrice': '150',
      'discountText': '20 %',
      'description': 'Lorem Ipsum is simply dummy text of the printing typesetting industry.',
    },
    {
      'title': 'The Spice Pizza',
      'isVeg': false,
      'originalPrice': '200',
      'discountedPrice': '150',
      'discountText': '20 %',
      'description': 'Lorem Ipsum is simply dummy text of the printing typesetting industry.',
    },
  ];
}
