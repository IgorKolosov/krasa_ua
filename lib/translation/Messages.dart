import 'package:get/get_navigation/src/root/internacionalization.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          "error": "Error!",
          "noInternetConnection": "No internet connection!",
          "tryAgain": "Try again!",
        },
        'uk_UA': {
          "error": "Помилка!",
          "noInternetConnection": "Відсутнє підключення до Інтернету!",
          "tryAgain": "Cпробуйте ще раз",
        }
      };
}
