class Config {
  static const String baseUrl = "https://tj.temanjabar.net/api";
  //https://tj.temanjabar.net/api
  //http://192.168.0.124/temanjabar/public/api
  static Uri loginUrl = Uri.parse('$baseUrl/auth/login');
  static Uri startSurvei = Uri.parse('$baseUrl/survei-lubang/start');
  static Uri resultSurvei = Uri.parse('$baseUrl/survei-lubang/result');
  static Uri storeSurvei = Uri.parse('$baseUrl/survei-lubang/store/tambah');
  static Uri listRencana = Uri.parse('$baseUrl/rencana-penanganan-lubang/list');
  static String rejectLobang = '$baseUrl/sapu-lubang/data-lubang/reject';
  static String jadwalLubang = '$baseUrl/rencana-penanganan-lubang/execute';
}
