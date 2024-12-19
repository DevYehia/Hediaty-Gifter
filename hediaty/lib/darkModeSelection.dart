import 'package:shared_preferences/shared_preferences.dart';

class DarkModeSelection{

  static bool isDarkModeFetched = false;
  static bool? darkMode;
  static Future<void> getDarkModeFromPref() async{

    if(!isDarkModeFetched){
      var prefs = await SharedPreferences.getInstance();
      darkMode = prefs.getBool("dark")??false;
      isDarkModeFetched = true;
    }
  }
  static bool? getDarkMode(){
    return darkMode;
  }
}