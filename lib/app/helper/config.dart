class Config {
  static const String baseUrl = "https://tj.temanjabar.net/api";
  //https://tj.temanjabar.net/api
  //http://192.168.0.124/temanjabar/public/api

  static Uri loginUrl = Uri.parse('$baseUrl/auth/login');
  static Uri startSurvei = Uri.parse('$baseUrl/survei-lubang/start');
}
