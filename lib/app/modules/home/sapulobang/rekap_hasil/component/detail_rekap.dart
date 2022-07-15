import 'package:flutter/material.dart';

import '../../../component/appbar.dart';

class RekapDetail extends StatefulWidget {
  const RekapDetail({Key? key}) : super(key: key);

  @override
  State<RekapDetail> createState() => _RekapDetailState();
}

class _RekapDetailState extends State<RekapDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('assets/images/sapulobang.png'),
    );
  }
}
