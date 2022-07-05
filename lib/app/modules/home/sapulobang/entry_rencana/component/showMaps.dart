import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sipelajar/app/modules/home/sapulobang/entry_rencana/component/previewImage.dart';

import '../../../../../data/model/api/rencanaPenanganModel.dart';
import '../../../../../helper/utils.dart';
import '../../../../../services/api/utilsProvider.dart';

class ShowMaps extends StatefulWidget {
  const ShowMaps({Key? key, required this.data, required this.ruasJalanId})
      : super(key: key);
  final DataPerencanaan data;
  final String ruasJalanId;
  @override
  State<ShowMaps> createState() => _ShowMapsState();
}

class _ShowMapsState extends State<ShowMaps> {
  List<LatLng> polyline = <LatLng>[];
  late LatLng latLng;
  @override
  void initState() {
    getDataMaps(widget.ruasJalanId);
    latLng =
        LatLng(double.parse(widget.data.lat), double.parse(widget.data.long));
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
                  Positioned(
                    bottom: 0,
                    child: Card(
                      color: const Color.fromARGB(255, 250, 248, 248)
                          .withOpacity(0.5),
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
                                  labelBuilder(
                                      'Mandor', widget.data.userCreate.name),
                                  const SizedBox(height: 10),
                                  labelBuilder('Lokasi',
                                      ' KM.${widget.data.lokasiKode}. ${widget.data.lokasiKm} - ${widget.data.lokasiM}'),
                                  const SizedBox(height: 10),
                                  labelBuilder(
                                      'Kategori', widget.data.kategori),
                                  const SizedBox(height: 10),
                                  labelBuilder(
                                      'Ukuran', widget.data.kategoriKedalaman),
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
                  ),
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
}
