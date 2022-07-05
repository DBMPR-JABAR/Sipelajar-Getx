import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../data/model/api/resultSurveiModel.dart';
import '../../../../../data/model/local/entryLubangModel.dart';

class DetailResult extends StatefulWidget {
  const DetailResult({Key? key, this.dataOnline, this.dataOffile})
      : super(key: key);
  final SurveiILubangDetail? dataOnline;
  final EntryLubangModel? dataOffile;
  @override
  State<DetailResult> createState() => _DetailResultState();
}

class _DetailResultState extends State<DetailResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.dataOnline?.ruasJalanId ?? widget.dataOffile?.ruasJalanId}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: CachedNetworkImage(
                  imageUrl:
                      'http://173.103.11.101/temanjabar/public/map-dashboard/intervention-mage/${widget.dataOnline?.image ?? widget.dataOffile?.image}',
                  fit: BoxFit.cover,
                  height: 300),
            ),
          ],
        ),
      ),
    );
  }
}
