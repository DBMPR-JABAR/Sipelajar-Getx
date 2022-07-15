import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../data/model/api/newsResponseModel.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({Key? key, required this.newsData}) : super(key: key);
  final NewsData newsData;
  @override
  State<NewsDetail> createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: widget.newsData.pathUrl,
                errorWidget: (context, url, error) {
                  return const Icon(Icons.error);
                },
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                  ),
                ),
                fit: BoxFit.fill,
                width: Get.width,
                height: Get.height / 2.5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.newsData.title,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Html(data: widget.newsData.content),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
