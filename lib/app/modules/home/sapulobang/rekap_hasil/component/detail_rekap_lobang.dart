import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sipelajar/app/helper/loading.dart';
import 'package:sipelajar/app/services/api/surveiProvider.dart';
import '../../../../../data/model/api/rekapLubangResponseModel.dart';
import '../../../../../helper/utils.dart';
import '../../../component/appbar.dart';
import '../../../component/previewImage.dart';
import '../../../component/showMaps.dart';

class RekapLubang extends StatefulWidget {
  const RekapLubang({
    Key? key,
  }) : super(key: key);
  @override
  State<RekapLubang> createState() => _RekapLubangState();
}

class _RekapLubangState extends State<RekapLubang>
    with TickerProviderStateMixin {
  late TabController _tabController;
  var _isLoading = true;
  final List<DataRekapLubang> _resultSurvei = [];
  final List<DataRekapLubang> _resultPotensi = [];

  @override
  void initState() {
    getData();
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void getData() async {
    await SurveiProvider.rekapLobang().then((value) {
      if (value != null) {
        _resultSurvei.addAll(value.data);
      }
    });

    await SurveiProvider.rekapPotensi().then((value) {
      if (value != null) {
        _resultPotensi.addAll(value.data);
      }
    });
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('assets/images/sapulobang.png'),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'Lubang',
                  ),
                  Tab(
                    text: 'Potensi',
                  ),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.yellow,
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                children: [
                  resultDataOnline(data: _resultSurvei),
                  resultDataOnline(data: _resultPotensi),
                ],
              )),
            ],
          ),
        ),
        _isLoading ? Loading() : Container(),
      ]),
    );
  }
}

resultDataOnline({List<DataRekapLubang>? data}) {
  if (data!.isEmpty) {
    return const Center(
      child: Text('Data Masih Kosong', style: TextStyle(fontSize: 20)),
    );
  } else {
    return ListView.separated(
      itemCount: data.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () => Get.to(
                          () => PreviewImage(
                            imageUrl:
                                'https://tj.temanjabar.net/map-dashboard/intervention-mage/${data[index].image}',
                          ),
                        ),
                        child: Container(
                          width: Get.width * 0.4,
                          height: Get.height * 0.4,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  'https://tj.temanjabar.net/map-dashboard/intervention-mage/${data[index].image}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          labelBuilder('ID', data[index].id.toString()),
                          const SizedBox(height: 10),
                          labelBuilder('Mandor', data[index].userCreate.name),
                          const SizedBox(height: 10),
                          labelBuilder('Tanggal', data[index].tanggal!),
                          const SizedBox(height: 10),
                          labelBuilder('Ruas', data[index].ruasJalanId),
                          const SizedBox(height: 10),
                          labelBuilder('Lokasi',
                              ' KM.${data[index].lokasiKode}. ${data[index].lokasiKm} - ${data[index].lokasiM}'),
                          const SizedBox(height: 10),
                          labelBuilder('Kategori', data[index].kategori),
                          const SizedBox(height: 10),
                          labelBuilder('Ukuran', data[index].kategoriKedalaman),
                          const SizedBox(height: 10),
                          labelBuilder('Panjang', data[index].panjang),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(() => ShowMaps(
                                          data: data[index],
                                          ruasJalanId: data[index].ruasJalanId,
                                        ));
                                  },
                                  child: const Text('Detail')),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
