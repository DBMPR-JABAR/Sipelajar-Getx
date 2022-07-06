import 'package:get/get.dart';
import 'package:sipelajar/app/services/api/surveiProvider.dart';

class RekapHasilController extends GetxController {
  var totalLubang = '0'.obs;
  var totalPotensiLubang = '0'.obs;
  var totalPanjangLubang = '0'.obs;
  var totalPanjangPotensiLubang = '0'.obs;

  var totalPerencanaan = '0'.obs;
  var panjangPerencanaan = '0'.obs;
  var totalPenanganan = '0'.obs;
  var panjangPenanganan = '0'.obs;

  @override
  void onInit() {
    getdataRekap();
    super.onInit();
  }

  getdataRekap() async {
    await SurveiProvider.rekapSurvei().then((value) => {
          if (value != null)
            {
              totalLubang.value = value.data.jumlah.sisa,
              totalPanjangLubang.value = value.data.panjang.sisa,
              totalPotensiLubang.value = value.data.jumlah.potensi,
              totalPanjangPotensiLubang.value = value.data.panjang.potensi,
              totalPerencanaan.value = value.data.jumlah.perencanaan,
              panjangPerencanaan.value = value.data.panjang.perencanaan,
              totalPenanganan.value = value.data.jumlah.penanganan,
              panjangPenanganan.value = value.data.panjang.penanganan,
            }
        });
  }
}
