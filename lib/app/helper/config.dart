class Config {
  static const String baseUrl = "https://tj.temanjabar.net/api";
  //https://tj.temanjabar.net/api
  //http://192.168.0.124/temanjabar/public/api
  static Uri loginUrl = Uri.parse('$baseUrl/auth/login');
  static Uri updateFcm = Uri.parse('$baseUrl/user/refresh_fcm');
  static Uri startSurvei = Uri.parse('$baseUrl/survei-lubang/start');
  static Uri resultSurvei = Uri.parse('$baseUrl/survei-lubang/result');
  static Uri storeSurvei = Uri.parse('$baseUrl/survei-lubang/store/tambah');
  static Uri listRencana = Uri.parse('$baseUrl/rencana-penanganan-lubang/list');
  static String rejectLobang = '$baseUrl/sapu-lubang/data-lubang/reject';
  static String jadwalLubang = '$baseUrl/rencana-penanganan-lubang/execute';
  static Uri listPenanganan = Uri.parse('$baseUrl/penanganan-lubang/list');
  static String excutePenanganan = '$baseUrl/penanganan-lubang/execute';
  static Uri rekapData = Uri.parse('$baseUrl/sapu-lubang/rekapitulasi');
  static Uri rekapLubang =
      Uri.parse('$baseUrl/sapu-lubang/list/lubang/belum_ditangani');
  static Uri rekapPotensi = Uri.parse('$baseUrl/sapu-lubang/list/potensi/show');
  static Uri rekapDalamPerencanaan =
      Uri.parse('$baseUrl/sapu-lubang/list/lubang/dalam_perencanaan');
  static Uri rekapSelesai =
      Uri.parse('$baseUrl/sapu-lubang/list/lubang/sudah_ditangani');
  static Uri listNews = Uri.parse('$baseUrl/news/for-slider');
  static Uri listDraftPenanganan =
      Uri.parse('$baseUrl/penanganan-lubang/list_by_user');
  static String deleteLubang = '$baseUrl/survei-lubang/delete';
  static String deletePotensiLubang = '$baseUrl/survei-potensi-lubang/delete';
}
