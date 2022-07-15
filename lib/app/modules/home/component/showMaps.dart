import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sipelajar/app/modules/home/component/previewImage.dart';
import '../../../data/model/api/resultSurveiModel.dart';
import '../../../data/model/local/entryLubangModel.dart';
import '../../../helper/utils.dart';
import '../../../services/api/utilsProvider.dart';

class ShowMaps extends StatefulWidget {
  const ShowMaps(
      {Key? key,
      this.data,
      required this.ruasJalanId,
      this.dataLobang,
      this.dataLobangOffline})
      : super(key: key);
  final dynamic data;
  final String ruasJalanId;
  final dynamic dataLobang;
  final EntryLubangModel? dataLobangOffline;
  @override
  State<ShowMaps> createState() => _ShowMapsState();
}

class _ShowMapsState extends State<ShowMaps> {
  List<LatLng> polyline = <LatLng>[];
  late LatLng latLng;
  @override
  void initState() {
    getDataMaps(widget.ruasJalanId);
    widget.data != null
        ? latLng = LatLng(
            double.parse(widget.data.lat), double.parse(widget.data.long))
        : latLng = LatLng(double.parse(widget.dataLobang!.lat),
            double.parse(widget.dataLobang!.long));

    super.initState();
  }

  void getDataMaps(String id) async {
    polyline = await UtilsProvider.getPolyline(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: latLng,
                  zoom: 13.0,
                ),
                layers: [
                  PolylineLayerOptions(
                    polylineCulling: false,
                    polylines: [
                      Polyline(
                        points: polyline,
                        strokeWidth: 3.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
                nonRotatedChildren: [
                  if (widget.data != null) cardBuilderDynamic(),
                  if (widget.dataLobang != null) cardBuilder(),
                  if (widget.dataLobangOffline != null) cardBuilderOffline()
                ],
                children: [
                  TileLayerWidget(
                    options: TileLayerOptions(
                      urlTemplate:
                          'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}',
                      subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
                    ),
                  ),
                  MarkerLayerWidget(
                    options: MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: latLng,
                          builder: (context) => const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned cardBuilderDynamic() {
    return Positioned(
      bottom: 0,
      child: Card(
        color: const Color.fromARGB(255, 250, 248, 248).withOpacity(0.5),
        elevation: 5,
        child: SizedBox(
          height: Get.height * 0.4,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: InkWell(
                  child: Container(
                    width: Get.width * 0.4,
                    height: Get.height * 0.3,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            'https://tj.temanjabar.net/map-dashboard/intervention-mage/${widget.data.image}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(() => PreviewImage(
                          imageUrl:
                              'https://tj.temanjabar.net/map-dashboard/intervention-mage/${widget.data.image}',
                        ));
                  },
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    labelBuilder('ID', widget.data.id.toString()),
                    const SizedBox(height: 10),
                    labelBuilder('Mandor', widget.data.userCreate.name ?? '-'),
                    const SizedBox(height: 10),
                    labelBuilder('Lokasi',
                        ' KM.${widget.data.lokasiKode}. ${widget.data.lokasiKm} - ${widget.data.lokasiM}'),
                    const SizedBox(height: 10),
                    labelBuilder('Kategori', widget.data.kategori),
                    const SizedBox(height: 10),
                    labelBuilder('Ukuran', widget.data.kategoriKedalaman),
                    const SizedBox(height: 10),
                    labelBuilder('Panjang', widget.data.panjang),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned cardBuilder() {
    return Positioned(
      bottom: 0,
      child: Card(
        color: const Color.fromARGB(255, 250, 248, 248).withOpacity(0.5),
        elevation: 5,
        child: SizedBox(
          height: Get.height * 0.4,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: InkWell(
                  child: Container(
                    width: Get.width * 0.4,
                    height: Get.height * 0.3,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            'https://tj.temanjabar.net/map-dashboard/intervention-mage/${widget.dataLobang!.image}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    Get.to(() => PreviewImage(
                          imageUrl:
                              'https://tj.temanjabar.net/map-dashboard/intervention-mage/${widget.dataLobang!.image}',
                        ));
                  },
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    labelBuilder('ID', widget.dataLobang!.id.toString()),
                    const SizedBox(height: 10),
                    labelBuilder('Lokasi',
                        ' KM.${widget.dataLobang!.lokasiKode}. ${widget.dataLobang!.lokasiKm} - ${widget.dataLobang!.lokasiM}'),
                    const SizedBox(height: 10),
                    labelBuilder('Kategori', widget.dataLobang!.kategori),
                    const SizedBox(height: 10),
                    labelBuilder(
                        'Ukuran', widget.dataLobang!.kategoriKedalaman),
                    const SizedBox(height: 10),
                    labelBuilder('Panjang', widget.dataLobang!.panjang),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned cardBuilderOffline() {
    return Positioned(
      bottom: 0,
      child: Card(
        color: const Color.fromARGB(255, 250, 248, 248).withOpacity(0.5),
        elevation: 5,
        child: SizedBox(
          height: Get.height * 0.4,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  width: Get.width * 0.4,
                  height: Get.height * 0.3,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: Image.file(File(widget.dataLobangOffline!.image))
                          .image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    labelBuilder('ID', widget.dataLobangOffline!.id.toString()),
                    const SizedBox(height: 10),
                    labelBuilder('Lokasi',
                        ' KM.${widget.dataLobangOffline!.lokasiKode}. ${widget.dataLobangOffline!.lokasiKm} - ${widget.dataLobangOffline!.lokasiM}'),
                    const SizedBox(height: 10),
                    labelBuilder(
                        'Kategori', widget.dataLobangOffline!.kategori),
                    const SizedBox(height: 10),
                    labelBuilder(
                        'Ukuran', widget.dataLobangOffline!.kategoriKedalaman),
                    const SizedBox(height: 10),
                    labelBuilder('Panjang', widget.dataLobangOffline!.panjang),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
