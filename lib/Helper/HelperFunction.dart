import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{

  /// keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

   /// saving data to shared preferences
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }




  /// getting data from shared preferences

  static Future<bool?> getUserLoggedInStatus() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    /// this statement return true if our saved key matches with userLoggedInKey
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserUserName() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    /// this statement return true if our saved key matches with userLoggedInKey
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserUserEmail() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    /// this statement return true if our saved key matches with userLoggedInKey
    return sf.getString(userEmailKey);
  }
}