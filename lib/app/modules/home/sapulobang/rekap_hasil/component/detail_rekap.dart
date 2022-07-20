import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sipelajar/app/helper/loading.dart';
import 'package:sipelajar/app/helper/utils.dart';
import 'package:sipelajar/app/services/api/surveiProvider.dart';

import '../../../../../data/model/api/rekapLubangResponseModel.dart';
import '../../../component/appbar.dart';
import '../../../component/previewImage.dart';
import '../../../component/showMaps.dart';

class RekapDetail extends StatefulWidget {
  const RekapDetail({Key? key, required this.argument}) : super(key: key);
  final String argument;

  @override
  State<RekapDetail> createState() => _RekapDetailState();
}

class _RekapDetailState extends State<RekapDetail> {
  final List<DataRekapLubang> _rekapLubang = [];
  var _isLoading = true;
  getData() async {
    if (widget.argument == 'Perencanaan') {
      await SurveiProvider.rekapPerencanaan().then((value) {
        setState(() {
          _rekapLubang.addAll(value!.data);
          _isLoading = false;
        });
      });
    } else {
      await SurveiProvider.rekapPenanganan().then((value) {
        setState(() {
          _rekapLubang.addAll(value!.data);
          _isLoading = false;
        });
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('assets/images/sapulobang.png'),
      body: Stack(
        children: [
          widget.argument == 'Perencanaan'
              ? rekapPerencanaan(data: _rekapLubang)
              : rekapSelesaiPenanganan(data: _rekapLubang),
          _isLoading ? Loading() : Container()
        ],
      ),
    );
  }
}

rekapPerencanaan({List<DataRekapLubang>? data}) {
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
                          labelBuilder(
                              'Status', 'Dalam ${data[index].status!}'),
                          const SizedBox(height: 10),
                          labelBuilder('Mandor', data[index].userCreate.name),
                          const SizedBox(height: 10),
                          labelBuilder('Tanggal', data[index].tanggal!),
                          const SizedBox(height: 10),
                          labelBuilder('Tanggal Perencanaan',
                              data[index].tanggalRencanaPenanganan!),
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

rekapSelesaiPenanganan({List<DataRekapLubang>? data}) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          child: const Center(
                            child: Text('Sebelum',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () => Get.to(
                          () => PreviewImage(
                            imageUrl:
                                'https://tj.temanjabar.net/map-dashboard/intervention-mage/${data[index].imagePenanganan}',
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
                                  'https://tj.temanjabar.net/map-dashboard/intervention-mage/${data[index].imagePenanganan}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: const Center(
                            child: Text('Sesudah',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    labelBuilder('ID', data[index].id.toString()),
                    const SizedBox(height: 10),
                    labelBuilder('Mandor', data[index].userCreate.name),
                    const SizedBox(height: 10),
                    labelBuilder('Tanggal', data[index].tanggal ?? ''),
                    const SizedBox(height: 10),
                    labelBuilder('Tanggal Perencanaan',
                        data[index].tanggalRencanaPenanganan ?? ''),
                    const SizedBox(height: 10),
                    labelBuilder('Tanggal Penanganan',
                        data[index].tanggalPenanganan ?? ''),
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
              )
            ],
          ),
        );
      },
    );
  }
}
