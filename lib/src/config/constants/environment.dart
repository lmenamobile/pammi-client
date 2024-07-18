
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {

  static initEnvironment() async {
    await dotenv.load(fileName: ".env");
  }

  static String apiUrl                = dotenv.env['API_URL'] ?? 'not found';
  static String secretKeyHash         = dotenv.env['SECRET_KEY_HASH'] ?? 'not found';
  static String googleMapsApiKey      = dotenv.env['GOOGLE_API_KEY'] ?? 'not found';
  static String passwordSocialNetwork = dotenv.env['PASSWORD_SOCIAL_NETWORK'] ?? 'not found';


}