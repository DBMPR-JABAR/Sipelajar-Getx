import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.5),
      child: const Center(
        child: SpinKitFadingFour(
          color: Colors.black,
          size: 50.0,
        ),
      ),
    );
  }
}
