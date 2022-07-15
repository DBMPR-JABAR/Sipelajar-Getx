import 'package:get/get.dart';

import '../modules/cameraCam/bindings/camera_cam_binding.dart';
import '../modules/cameraCam/views/camera_cam_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/sapulobang/entry_data_lubang/bindings/entry_data_lubang_binding.dart';
import '../modules/home/sapulobang/entry_data_lubang/views/entry_data_lubang_view.dart';
import '../modules/home/sapulobang/entry_penanganan/bindings/entry_penanganan_binding.dart';
import '../modules/home/sapulobang/entry_penanganan/views/entry_penanganan_view.dart';
import '../modules/home/sapulobang/entry_rencana/bindings/entry_rencana_binding.dart';
import '../modules/home/sapulobang/entry_rencana/views/entry_rencana_view.dart';
import '../modules/home/sapulobang/rekap_hasil/bindings/rekap_hasil_binding.dart';
import '../modules/home/sapulobang/rekap_hasil/views/rekap_hasil_view.dart';
import '../modules/home/sapulobang/result_survei/bindings/result_survei_binding.dart';
import '../modules/home/sapulobang/result_survei/views/result_survei_view.dart';
import '../modules/home/sapulobang/start_survei_lubang/bindings/start_survei_lubang_binding.dart';
import '../modules/home/sapulobang/start_survei_lubang/views/start_survei_lubang_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
        name: _Paths.HOME,
        page: () => HomeView(),
        binding: HomeBinding(),
        children: [
          GetPage(
            name: _Paths.START_SURVEI_LUBANG,
            page: () => StartSurveiLubangView(),
            binding: StartSurveiLubangBinding(),
          ),
          GetPage(
            name: _Paths.ENTRY_DATA_LUBANG,
            page: () => EntryDataLubangView(),
            binding: EntryDataLubangBinding(),
          ),
          GetPage(
            name: _Paths.ENTRY_PENANGANAN,
            page: () => const EntryPenangananView(),
            binding: EntryPenangananBinding(),
          ),
          GetPage(
            name: _Paths.RESULT_SURVEI,
            page: () => const ResultSurveiView(),
            binding: ResultSurveiBinding(),
          ),
          GetPage(
            name: _Paths.ENTRY_RENCANA,
            page: () => const EntryRencanaView(),
            binding: EntryRencanaBinding(),
          ),
          GetPage(
            name: _Paths.REKAP_HASIL,
            page: () => const RekapHasilView(),
            binding: RekapHasilBinding(),
          ),
        ]),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CAMERA_CAM,
      page: () => CameraCamView(),
      binding: CameraCamBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
